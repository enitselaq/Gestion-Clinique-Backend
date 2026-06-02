from rest_framework import serializers
from .models import Utilisateur, Medecin, Patient, RendezVous, Consultation, Ordonnance, Medicament, Paiement


def _get_patient_profile(user):
    try:
        return user.patient
    except Patient.DoesNotExist:
        return None


def _get_medecin_profile(user):
    try:
        return user.medecin
    except Medecin.DoesNotExist:
        return None


class PublicSignupSerializer(serializers.ModelSerializer):
    cin = serializers.CharField(required=True, write_only=True)
    date_naissance = serializers.DateField(required=True, write_only=True)
    sexe = serializers.ChoiceField(choices=[('M', 'Masculin'), ('F', 'Feminin')], required=True, write_only=True)
    antecedents = serializers.CharField(required=False, allow_blank=True, write_only=True)
    allergies = serializers.CharField(required=False, allow_blank=True, write_only=True)

    class Meta:
        model = Utilisateur
        fields = [
            'username',
            'password',
            'first_name',
            'last_name',
            'email',
            'telephone',
            'cin',
            'date_naissance',
            'sexe',
            'antecedents',
            'allergies',
        ]
        extra_kwargs = {
            'password': {'write_only': True},
        }

    def to_internal_value(self, data):
        mutable = data.copy()
        mutable.pop('role', None)
        return super().to_internal_value(mutable)

    def create(self, validated_data):
        cin = validated_data.pop('cin')
        dob = validated_data.pop('date_naissance')
        sexe = validated_data.pop('sexe')
        antecedents = validated_data.pop('antecedents', '')
        allergies = validated_data.pop('allergies', '')
        user = Utilisateur.objects.create_user(role='PATIENT', **validated_data)
        Patient.objects.create(
            user=user,
            cin=cin,
            date_naissance=dob,
            sexe=sexe,
            antecedents=antecedents,
            allergies=allergies,
        )
        return user


class ChangePasswordSerializer(serializers.Serializer):
    current_password = serializers.CharField(write_only=True)
    new_password = serializers.CharField(write_only=True, min_length=6)

    def validate_current_password(self, value):
        user = self.context['request'].user
        if not user.check_password(value):
            raise serializers.ValidationError('Current password is incorrect.')
        return value


class ForgotPasswordResetSerializer(serializers.Serializer):
    username = serializers.CharField()
    cin = serializers.CharField()
    date_naissance = serializers.DateField()
    new_password = serializers.CharField(write_only=True, min_length=6)

    def validate(self, attrs):
        username = attrs['username'].strip()
        cin = attrs['cin'].strip().upper()
        date_naissance = attrs['date_naissance']

        try:
            user = Utilisateur.objects.get(username=username, role='PATIENT')
        except Utilisateur.DoesNotExist:
            raise serializers.ValidationError({'username': 'Patient account not found.'})

        try:
            patient = user.patient
        except Patient.DoesNotExist:
            raise serializers.ValidationError({'username': 'Patient profile is incomplete.'})

        if patient.cin.upper() != cin:
            raise serializers.ValidationError({'cin': 'CIN does not match this account.'})
        if patient.date_naissance != date_naissance:
            raise serializers.ValidationError({'date_naissance': 'Birth date does not match this account.'})

        attrs['user'] = user
        return attrs


# 1. User Account Serializer (Admin-only management)
class UserSerializer(serializers.ModelSerializer):
    cin = serializers.SerializerMethodField()
    date_naissance = serializers.SerializerMethodField()
    sexe = serializers.SerializerMethodField()
    antecedents = serializers.SerializerMethodField()
    allergies = serializers.SerializerMethodField()
    specialite = serializers.SerializerMethodField()

    patient_cin = serializers.CharField(write_only=True, required=False, allow_blank=True)
    patient_date_naissance = serializers.DateField(write_only=True, required=False)
    patient_sexe = serializers.ChoiceField(
        choices=[('M', 'Masculin'), ('F', 'Feminin')],
        write_only=True,
        required=False,
    )
    patient_antecedents = serializers.CharField(write_only=True, required=False, allow_blank=True)
    patient_allergies = serializers.CharField(write_only=True, required=False, allow_blank=True)
    medecin_specialite = serializers.CharField(write_only=True, required=False, allow_blank=True)

    class Meta:
        model = Utilisateur
        fields = [
            'id',
            'username',
            'password',
            'first_name',
            'last_name',
            'email',
            'role',
            'telephone',
            'cin',
            'date_naissance',
            'sexe',
            'antecedents',
            'allergies',
            'specialite',
            'patient_cin',
            'patient_date_naissance',
            'patient_sexe',
            'patient_antecedents',
            'patient_allergies',
            'medecin_specialite',
        ]
        extra_kwargs = {
            'password': {'write_only': True, 'required': False},
        }

    def get_cin(self, obj):
        profile = _get_patient_profile(obj)
        return profile.cin if profile else None

    def get_date_naissance(self, obj):
        profile = _get_patient_profile(obj)
        return profile.date_naissance if profile else None

    def get_sexe(self, obj):
        profile = _get_patient_profile(obj)
        return profile.sexe if profile else None

    def get_antecedents(self, obj):
        profile = _get_patient_profile(obj)
        return profile.antecedents if profile else ''

    def get_allergies(self, obj):
        profile = _get_patient_profile(obj)
        return profile.allergies if profile else ''

    def get_specialite(self, obj):
        profile = _get_medecin_profile(obj)
        return profile.specialite if profile else ''

    def validate(self, attrs):
        role = attrs.get('role', getattr(self.instance, 'role', None))
        instance = self.instance

        if instance is None and not attrs.get('password'):
            raise serializers.ValidationError({'password': 'Password is required when creating a user.'})

        if role == 'PATIENT':
            has_existing_patient = bool(instance and _get_patient_profile(instance))
            if not has_existing_patient:
                required_fields = {
                    'patient_cin': 'CIN is required for patient accounts.',
                    'patient_date_naissance': 'Birth date is required for patient accounts.',
                    'patient_sexe': 'Sex is required for patient accounts.',
                }
                for field_name, message in required_fields.items():
                    if not attrs.get(field_name):
                        raise serializers.ValidationError({field_name: message})

        if role == 'MEDECIN':
            has_existing_doctor = bool(instance and _get_medecin_profile(instance))
            if not has_existing_doctor and not attrs.get('medecin_specialite'):
                raise serializers.ValidationError({'medecin_specialite': 'Speciality is required for doctor accounts.'})

        return attrs

    def _sync_related_profiles(self, user, validated_data):
        patient_cin = validated_data.pop('patient_cin', None)
        patient_date_naissance = validated_data.pop('patient_date_naissance', None)
        patient_sexe = validated_data.pop('patient_sexe', None)
        patient_antecedents = validated_data.pop('patient_antecedents', None)
        patient_allergies = validated_data.pop('patient_allergies', None)
        medecin_specialite = validated_data.pop('medecin_specialite', None)

        if user.role == 'PATIENT':
            patient_profile = _get_patient_profile(user)
            if patient_profile is None:
                patient_profile = Patient.objects.create(
                    user=user,
                    cin=patient_cin,
                    date_naissance=patient_date_naissance,
                    sexe=patient_sexe,
                    antecedents=patient_antecedents or '',
                    allergies=patient_allergies or '',
                )
            else:
                if patient_cin is not None:
                    patient_profile.cin = patient_cin
                if patient_date_naissance is not None:
                    patient_profile.date_naissance = patient_date_naissance
                if patient_sexe is not None:
                    patient_profile.sexe = patient_sexe
                if patient_antecedents is not None:
                    patient_profile.antecedents = patient_antecedents
                if patient_allergies is not None:
                    patient_profile.allergies = patient_allergies
                patient_profile.save()

        if user.role == 'MEDECIN':
            medecin_profile, _ = Medecin.objects.get_or_create(user=user)
            if medecin_specialite is not None:
                medecin_profile.specialite = medecin_specialite
                medecin_profile.save()

    def create(self, validated_data):
        related_data = validated_data.copy()
        password = validated_data.pop('password')
        for field_name in [
            'patient_cin',
            'patient_date_naissance',
            'patient_sexe',
            'patient_antecedents',
            'patient_allergies',
            'medecin_specialite',
        ]:
            validated_data.pop(field_name, None)
        user = Utilisateur.objects.create_user(password=password, **validated_data)
        self._sync_related_profiles(user, related_data)
        return user

    def update(self, instance, validated_data):
        password = validated_data.pop('password', None)
        for field in ['first_name', 'last_name', 'email', 'role', 'telephone']:
            if field in validated_data:
                setattr(instance, field, validated_data[field])
        if password:
            instance.set_password(password)
        instance.save()
        self._sync_related_profiles(instance, validated_data)
        return instance

# 2. Medical Staff Serializer
class MedecinSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=Utilisateur.objects.all())
    full_name = serializers.CharField(source='user.get_full_name', read_only=True)

    class Meta:
        model = Medecin
        fields = ['user', 'full_name', 'specialite']
        
# 3. Patient serializer
class PatientSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(
        queryset=Utilisateur.objects.filter(role='PATIENT')
    )
    age = serializers.ReadOnlyField()
    full_name = serializers.CharField(source='user.get_full_name', read_only=True)

    class Meta:
        model = Patient
        fields = ['user', 'full_name', 'cin', 'date_naissance', 'age', 'sexe', 'antecedents', 'allergies']

# 4. Appointment Serializer
class RendezVousSerializer(serializers.ModelSerializer):
    patient_name = serializers.CharField(source='patient.user.get_full_name', read_only=True)
    medecin_name = serializers.CharField(source='medecin.user.get_full_name', read_only=True)

    def validate(self, attrs):
        request = self.context.get('request')
        user = getattr(request, 'user', None)
        instance = self.instance

        if not user or not user.is_authenticated:
            return attrs

        if user.role == 'MEDECIN':
            if instance is None:
                raise serializers.ValidationError(
                    'Doctors cannot create appointments.'
                )
            if instance.medecin is None or instance.medecin.user_id != user.id:
                raise serializers.ValidationError(
                    {'medecin': 'This appointment is not assigned to the authenticated doctor.'}
                )

            allowed_fields = {'statut'}
            provided_fields = set(attrs.keys())
            if not provided_fields.issubset(allowed_fields):
                raise serializers.ValidationError(
                    'Doctors can only update the appointment status.'
                )

            if attrs.get('statut') != 'TERMINE':
                raise serializers.ValidationError(
                    {'statut': 'Doctors can only mark their appointments as completed.'}
                )

        return attrs

    class Meta:
        model = RendezVous
        fields = ['id', 'date_rdv', 'statut', 'patient', 'patient_name', 'medecin', 'medecin_name']

# 5. Medical Records & Visit Serializers
class MedicamentSerializer(serializers.ModelSerializer):
    def validate(self, attrs):
        request = self.context.get('request')
        user = getattr(request, 'user', None)
        ordonnance = attrs.get('ordonnance') or getattr(self.instance, 'ordonnance', None)

        if ordonnance is None:
            return attrs

        if user and user.is_authenticated and user.role == 'MEDECIN':
            if ordonnance.consultation.medecin.user_id != user.id:
                raise serializers.ValidationError(
                    {'ordonnance': 'Doctors can only add medicines to their own prescriptions.'}
                )

        return attrs

    class Meta:
        model = Medicament
        fields = '__all__'

class ConsultationSerializer(serializers.ModelSerializer):
    patient_name = serializers.CharField(source='rdv.patient.user.get_full_name', read_only=True)
    medecin_name = serializers.CharField(source='medecin.user.get_full_name', read_only=True)

    def validate(self, attrs):
        request = self.context.get('request')
        user = getattr(request, 'user', None)
        rdv = attrs.get('rdv') or getattr(self.instance, 'rdv', None)
        medecin = attrs.get('medecin') or getattr(self.instance, 'medecin', None)

        if rdv is None or medecin is None:
            return attrs

        if user and user.is_authenticated and user.role == 'MEDECIN':
            if medecin.user_id != user.id:
                raise serializers.ValidationError(
                    {'medecin': 'Doctors can only create consultations under their own profile.'}
                )
            if rdv.medecin_id != user.id:
                raise serializers.ValidationError(
                    {'rdv': 'This appointment is not assigned to the authenticated doctor.'}
                )

        if rdv.medecin_id != medecin.user_id:
            raise serializers.ValidationError(
                {'medecin': 'The selected doctor must match the appointment doctor.'}
            )

        if rdv.statut != 'CONFIRME':
            raise serializers.ValidationError(
                {'rdv': 'Only confirmed appointments can be converted into consultations.'}
            )

        if getattr(rdv, 'consultation', None) and self.instance is None:
            raise serializers.ValidationError(
                {'rdv': 'A consultation already exists for this appointment.'}
            )

        return attrs

    class Meta:
        model = Consultation
        fields = ['id', 'diagnostic', 'notes', 'date_consult', 'rdv', 'patient_name', 'medecin', 'medecin_name']

class OrdonnanceSerializer(serializers.ModelSerializer):
    medicaments = MedicamentSerializer(many=True, read_only=True)

    def validate(self, attrs):
        request = self.context.get('request')
        user = getattr(request, 'user', None)
        consultation = attrs.get('consultation') or getattr(self.instance, 'consultation', None)

        if consultation is None:
            return attrs

        if user and user.is_authenticated and user.role == 'MEDECIN':
            if consultation.medecin.user_id != user.id:
                raise serializers.ValidationError(
                    {'consultation': 'Doctors can only create prescriptions for their own consultations.'}
                )

        if getattr(consultation, 'ordonnance', None) and self.instance is None:
            raise serializers.ValidationError(
                {'consultation': 'A prescription already exists for this consultation.'}
            )

        return attrs
    
    class Meta:
        model = Ordonnance
        fields = ['id', 'consultation', 'date_creation', 'medicaments']

# 6. Billing Serializer
class PaiementSerializer(serializers.ModelSerializer):
    def validate(self, attrs):
        request = self.context.get('request')
        user = getattr(request, 'user', None)
        rdv = attrs.get('rdv') or getattr(self.instance, 'rdv', None)
        if rdv is None:
            return attrs

        if user and user.is_authenticated and user.role == 'PATIENT':
            if rdv.patient.user_id != user.id:
                raise serializers.ValidationError(
                    {'rdv': 'Patients can only pay for their own appointments.'}
                )

        if rdv.statut != 'TERMINE':
            raise serializers.ValidationError(
                {'rdv': 'Payment can only be registered after the consultation is completed.'}
            )

        if hasattr(rdv, 'paiement') and self.instance is None:
            raise serializers.ValidationError(
                {'rdv': 'A payment already exists for this appointment.'}
            )

        return attrs

    class Meta:
        model = Paiement
        fields = ['id', 'montant', 'date_paiement', 'rdv']
