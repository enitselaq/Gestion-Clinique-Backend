from rest_framework import viewsets, permissions, generics, status
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.response import Response

from .models import (
    Utilisateur, Medecin, Patient, RendezVous, 
    Consultation, Ordonnance, Medicament, Paiement, Notification
)
from .serializers import (
    ChangePasswordSerializer, ForgotPasswordResetSerializer,
    PublicSignupSerializer, UserSerializer, MedecinSerializer, PatientSerializer, 
    RendezVousSerializer, ConsultationSerializer, 
    OrdonnanceSerializer, MedicamentSerializer, PaiementSerializer
)
from .serializers import NotificationSerializer
from .permissions import (
    IsAdmin,
    IsAdminOrReceptionistReadOnly,
    IsAdminReceptionistOrReadOwnPatientRecord,
    RendezVousPermission,
    ConsultationPermission,
    OrdonnancePermission,
    MedicamentPermission,
    PaiementPermission,
)
from rest_framework.decorators import action

class PublicSignupView(generics.CreateAPIView):
    serializer_class = PublicSignupSerializer
    permission_classes = [permissions.AllowAny]


class ChangePasswordView(generics.GenericAPIView):
    serializer_class = ChangePasswordSerializer
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        request.user.set_password(serializer.validated_data['new_password'])
        request.user.save(update_fields=['password'])
        Token.objects.filter(user=request.user).delete()
        token = Token.objects.create(user=request.user)
        return Response({'detail': 'Password changed successfully.', 'token': token.key})


class ForgotPasswordResetView(generics.GenericAPIView):
    serializer_class = ForgotPasswordResetSerializer
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        user.set_password(serializer.validated_data['new_password'])
        user.save(update_fields=['password'])
        Token.objects.filter(user=user).delete()
        return Response({'detail': 'Password reset successfully.'}, status=status.HTTP_200_OK)


# --- 1. Admin User Management ---
class UserViewSet(viewsets.ModelViewSet):
    queryset = Utilisateur.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAdmin]

# --- 2. Private Access (Medical Data) ---
class MedecinViewSet(viewsets.ModelViewSet):
    queryset = Medecin.objects.all()
    serializer_class = MedecinSerializer
    permission_classes = [IsAdminOrReceptionistReadOnly]

class PatientViewSet(viewsets.ModelViewSet):
    serializer_class = PatientSerializer
    permission_classes = [IsAdminReceptionistOrReadOwnPatientRecord]

    def get_queryset(self):
        user = self.request.user
        if user.role == 'PATIENT':
            return Patient.objects.select_related('user').filter(user=user)
        return Patient.objects.select_related('user').all()

class RendezVousViewSet(viewsets.ModelViewSet):
    serializer_class = RendezVousSerializer
    permission_classes = [RendezVousPermission]

    def get_queryset(self):
        user = self.request.user
        queryset = RendezVous.objects.select_related('patient__user', 'medecin__user')
        # If the user is a Patient, they only see their own appointments
        if user.role == 'PATIENT':
            return queryset.filter(patient__user=user)
        # If the user is a Medecin, they only see appointments assigned to them
        elif user.role == 'MEDECIN':
            return queryset.filter(medecin__user=user)
        # Admin and receptionists see everything
        return queryset.all()

    def create(self, request, *args, **kwargs):
        # Patients may create their own appointments; enforce ownership and sane defaults.
        user = request.user
        data = request.data.copy()

        # If the requester is a patient, ensure the appointment is for themselves
        if user.role == 'PATIENT':
            try:
                patient = user.patient
            except Exception:
                return Response({'detail': 'Patient profile not found.'}, status=status.HTTP_400_BAD_REQUEST)
            data['patient'] = patient.pk
            # Patients should not set the status; default to ATTENTE
            data.pop('statut', None)

        # Set creator
        data['cree_par'] = user.pk

        serializer = self.get_serializer(data=data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    @action(detail=True, methods=['post'], url_path='confirm')
    def confirm(self, request, pk=None):
        """Confirm an appointment and notify the patient."""
        rdv = self.get_object()
        user = request.user
        # Only receptionists and admins may confirm
        if user.role not in {'ADMIN', 'REC'}:
            return Response({'detail': 'Permission denied.'}, status=status.HTTP_403_FORBIDDEN)

        rdv.statut = 'CONFIRME'
        rdv.save(update_fields=['statut'])

        # create a notification for patient
        Notification.objects.create(user=rdv.patient.user, message=f"Your appointment on {rdv.date_rdv} has been confirmed.")

        return Response(self.get_serializer(rdv).data)

    @action(detail=True, methods=['post'], url_path='assign-doctor')
    def assign_doctor(self, request, pk=None):
        """Assign a doctor to an appointment and notify both parties."""
        rdv = self.get_object()
        user = request.user
        if user.role not in {'ADMIN', 'REC'}:
            return Response({'detail': 'Permission denied.'}, status=status.HTTP_403_FORBIDDEN)

        medecin_id = request.data.get('medecin')
        if not medecin_id:
            return Response({'medecin': ['This field is required.']}, status=status.HTTP_400_BAD_REQUEST)

        try:
            med = Medecin.objects.get(pk=medecin_id)
        except Medecin.DoesNotExist:
            return Response({'medecin': ['Invalid medecin id.']}, status=status.HTTP_400_BAD_REQUEST)

        rdv.medecin = med
        rdv.save(update_fields=['medecin'])

        Notification.objects.create(user=rdv.patient.user, message=f"A doctor has been assigned to your appointment on {rdv.date_rdv}.")
        Notification.objects.create(user=med.user, message=f"You have been assigned to appointment on {rdv.date_rdv}.")

        return Response(self.get_serializer(rdv).data)

    def partial_update(self, request, *args, **kwargs):
        # Doctors are allowed to update some fields (e.g., statut)
        # but should not be able to change the appointment schedule.
        user = request.user
        if user.role == 'MEDECIN' and 'date_rdv' in request.data:
            return Response({'date_rdv': ['Doctors cannot change appointment schedule.']}, status=status.HTTP_400_BAD_REQUEST)
        return super().partial_update(request, *args, **kwargs)

class ConsultationViewSet(viewsets.ModelViewSet):
    serializer_class = ConsultationSerializer
    permission_classes = [ConsultationPermission]

    def get_queryset(self):
        user = self.request.user
        queryset = Consultation.objects.select_related('rdv__patient__user', 'medecin__user')
        if user.role == 'PATIENT':
            return queryset.filter(rdv__patient__user=user)
        elif user.role == 'MEDECIN':
            return queryset.filter(medecin__user=user)
        return queryset.all()

    def create(self, request, *args, **kwargs):
        # Business rules:
        # - rdv must be CONFIRME to create a consultation
        # - patients may only create consultations for their own rdv
        # - medecins may only create consultations for rdv assigned to them
        rdv_id = request.data.get('rdv')
        try:
            rdv = RendezVous.objects.get(pk=rdv_id)
        except Exception:
            return Response({'rdv': ['Invalid rendez-vous.']}, status=status.HTTP_400_BAD_REQUEST)

        if rdv.statut != 'CONFIRME':
            return Response({'rdv': ['Appointment must be confirmed.']}, status=status.HTTP_400_BAD_REQUEST)

        user = request.user
        if user.role == 'PATIENT' and rdv.patient.user != user:
            return Response({'rdv': ['You may only create consultations for your own appointments.']}, status=status.HTTP_400_BAD_REQUEST)
        if user.role == 'MEDECIN' and rdv.medecin and rdv.medecin.user != user:
            return Response({'rdv': ['You may only create consultations for your own appointments.']}, status=status.HTTP_400_BAD_REQUEST)

        return super().create(request, *args, **kwargs)

class OrdonnanceViewSet(viewsets.ModelViewSet):
    serializer_class = OrdonnanceSerializer
    permission_classes = [OrdonnancePermission]

    def get_queryset(self):
        user = self.request.user
        # Optimize with select_related/prefetch_related for the nested medicaments
        qs = Ordonnance.objects.select_related(
            'consultation__rdv__patient__user',
            'consultation__medecin__user',
        ).prefetch_related('medicaments')
        if user.role == 'PATIENT':
            return qs.filter(consultation__rdv__patient__user=user)
        elif user.role == 'MEDECIN':
            return qs.filter(consultation__medecin__user=user)
        return qs

    def create(self, request, *args, **kwargs):
        # Ensure doctors can only create ordonnances for their own consultations
        consultation_id = request.data.get('consultation')
        try:
            consultation = Consultation.objects.select_related('medecin__user').get(pk=consultation_id)
        except Exception:
            return Response({'consultation': ['Invalid consultation.']}, status=status.HTTP_400_BAD_REQUEST)

        user = request.user
        if user.role == 'MEDECIN' and consultation.medecin.user != user:
            return Response({'consultation': ['You may only create prescriptions for your own consultations.']}, status=status.HTTP_400_BAD_REQUEST)

        return super().create(request, *args, **kwargs)

class MedicamentViewSet(viewsets.ModelViewSet):
    queryset = Medicament.objects.select_related(
        'ordonnance__consultation__rdv__patient__user',
        'ordonnance__consultation__medecin__user',
    ).all()
    serializer_class = MedicamentSerializer
    permission_classes = [MedicamentPermission]

class PaiementViewSet(viewsets.ModelViewSet):
    serializer_class = PaiementSerializer
    permission_classes = [PaiementPermission]

    def get_queryset(self):
        user = self.request.user
        queryset = Paiement.objects.select_related('rdv__patient__user')
        if user.role == 'PATIENT':
            return queryset.filter(rdv__patient__user=user)
        return queryset.all()

    def create(self, request, *args, **kwargs):
        # Payments can only be created for completed appointments (TERMINE)
        # Patients can only pay for their own appointments
        rdv_id = request.data.get('rdv')
        try:
            rdv = RendezVous.objects.get(pk=rdv_id)
        except Exception:
            return Response({'rdv': ['Invalid rendez-vous.']}, status=status.HTTP_400_BAD_REQUEST)

        if rdv.statut != 'TERMINE':
            return Response({'rdv': ['Payment can only be registered for completed appointments.']}, status=status.HTTP_400_BAD_REQUEST)

        user = request.user
        if user.role == 'PATIENT' and rdv.patient.user != user:
            return Response({'rdv': ['You may only pay for your own appointments.']}, status=status.HTTP_400_BAD_REQUEST)

        return super().create(request, *args, **kwargs)


class NotificationViewSet(viewsets.ReadOnlyModelViewSet):
    """List current user's notifications and allow marking as read."""
    serializer_class = NotificationSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return Notification.objects.filter(user=user)

    @action(detail=True, methods=['post'], url_path='mark-read')
    def mark_read(self, request, pk=None):
        notif = self.get_object()
        notif.read = True
        notif.save(update_fields=['read'])
        return Response(self.get_serializer(notif).data)

# --- 3. Authentication Logic ---
class CustomAuthToken(ObtainAuthToken):
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data,
                                           context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        
        
        profile_id = None
        if user.role == 'PATIENT':
            profile_id = user.patient.pk 
        elif user.role == 'MEDECIN':
            profile_id = user.medecin.pk

        return Response({
            'token': token.key,
            'user_id': user.pk,
            'profile_id': profile_id, 
            'role': user.role,
            'name': user.get_full_name(),
            'email': user.email
        })
