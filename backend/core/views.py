from rest_framework import viewsets, permissions, generics, status
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.response import Response

from .models import (
    Utilisateur, Medecin, Patient, RendezVous, 
    Consultation, Ordonnance, Medicament, Paiement
)
from .serializers import (
    ChangePasswordSerializer, ForgotPasswordResetSerializer,
    PublicSignupSerializer, UserSerializer, MedecinSerializer, PatientSerializer, 
    RendezVousSerializer, ConsultationSerializer, 
    OrdonnanceSerializer, MedicamentSerializer, PaiementSerializer
)
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

# --- 3. Authentication Logic ---
class CustomAuthToken(ObtainAuthToken):
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data,
                                           context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        
        # Determine the profile ID based on role
        profile_id = None
        if user.role == 'PATIENT':
            profile_id = user.patient.pk 
        elif user.role == 'MEDECIN':
            profile_id = user.medecin.pk

        return Response({
            'token': token.key,
            'user_id': user.pk,
            'profile_id': profile_id, # Very useful for Flutter navigation
            'role': user.role,
            'name': user.get_full_name(),
            'email': user.email
        })
