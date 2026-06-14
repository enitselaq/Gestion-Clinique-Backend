from rest_framework import serializers
from .models import Utilisateur, Medecin, Patient, RendezVous, Consultation, Ordonnance, Medicament, Paiement
from .models import Notification

# ... (Helper functions remain same)
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

# ... (Previous serializers for Signup, Password reset remain same)
class PublicSignupSerializer(serializers.ModelSerializer):
    cin = serializers.CharField(required=True, write_only=True)
    date_naissance = serializers.DateField(required=True, write_only=True)
    sexe = serializers.ChoiceField(choices=[('M', 'Masculin'), ('F', 'Feminin')], required=True, write_only=True)
    antecedents = serializers.CharField(required=False, allow_blank=True, write_only=True)
    allergies = serializers.CharField(required=False, allow_blank=True, write_only=True)

    class Meta:
        model = Utilisateur
        fields = ['username', 'password', 'first_name', 'last_name', 'email', 'telephone', 'cin', 'date_naissance', 'sexe', 'antecedents', 'allergies']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        cin = validated_data.pop('cin')
        dob = validated_data.pop('date_naissance')
        sexe = validated_data.pop('sexe')
        antecedents = validated_data.pop('antecedents', '')
        allergies = validated_data.pop('allergies', '')
        user = Utilisateur.objects.create_user(role='PATIENT', **validated_data)
        Patient.objects.create(user=user, cin=cin, date_naissance=dob, sexe=sexe, antecedents=antecedents, allergies=allergies)
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
            patient = user.patient
        except (Utilisateur.DoesNotExist, Patient.DoesNotExist):
            raise serializers.ValidationError({'username': 'Account/Profile not found.'})

        if patient.cin.upper() != cin or patient.date_naissance != date_naissance:
            raise serializers.ValidationError({'cin': 'Credentials do not match.'})
        attrs['user'] = user
        return attrs

class UserSerializer(serializers.ModelSerializer):
    cin = serializers.SerializerMethodField()
    date_naissance = serializers.SerializerMethodField()
    sexe = serializers.SerializerMethodField()
    antecedents = serializers.SerializerMethodField()
    allergies = serializers.SerializerMethodField()
    specialite = serializers.SerializerMethodField()

    patient_cin = serializers.CharField(write_only=True, required=False, allow_blank=True)
    patient_date_naissance = serializers.DateField(write_only=True, required=False)
    patient_sexe = serializers.ChoiceField(choices=[('M', 'Masculin'), ('F', 'Feminin')], write_only=True, required=False)
    patient_antecedents = serializers.CharField(write_only=True, required=False, allow_blank=True)
    patient_allergies = serializers.CharField(write_only=True, required=False, allow_blank=True)
    medecin_specialite = serializers.CharField(write_only=True, required=False, allow_blank=True)

    class Meta:
        model = Utilisateur
        fields = ['id', 'username', 'password', 'first_name', 'last_name', 'email', 'role', 'telephone', 'cin', 'date_naissance', 'sexe', 'antecedents', 'allergies', 'specialite', 'patient_cin', 'patient_date_naissance', 'patient_sexe', 'patient_antecedents', 'patient_allergies', 'medecin_specialite']
        extra_kwargs = {'password': {'write_only': True, 'required': False}}

    def get_cin(self, obj): return _get_patient_profile(obj).cin if _get_patient_profile(obj) else None
    def get_date_naissance(self, obj): return _get_patient_profile(obj).date_naissance if _get_patient_profile(obj) else None
    def get_sexe(self, obj): return _get_patient_profile(obj).sexe if _get_patient_profile(obj) else None
    def get_antecedents(self, obj): return _get_patient_profile(obj).antecedents if _get_patient_profile(obj) else ''
    def get_allergies(self, obj): return _get_patient_profile(obj).allergies if _get_patient_profile(obj) else ''
    def get_specialite(self, obj): return _get_medecin_profile(obj).specialite if _get_medecin_profile(obj) else ''

    def _sync_related_profiles(self, user, data):
        if user.role == 'PATIENT':
            Patient.objects.update_or_create(user=user, defaults={'cin': data.get('patient_cin'), 'date_naissance': data.get('patient_date_naissance'), 'sexe': data.get('patient_sexe'), 'antecedents': data.get('patient_antecedents', ''), 'allergies': data.get('patient_allergies', '')})
        elif user.role == 'MEDECIN':
            Medecin.objects.update_or_create(user=user, defaults={'specialite': data.get('medecin_specialite', '')})

    def create(self, validated_data):
        related_data = validated_data.copy()
        password = validated_data.pop('password')
        for f in ['patient_cin', 'patient_date_naissance', 'patient_sexe', 'patient_antecedents', 'patient_allergies', 'medecin_specialite']: validated_data.pop(f, None)
        user = Utilisateur.objects.create_user(password=password, **validated_data)
        self._sync_related_profiles(user, related_data)
        return user

    def update(self, instance, validated_data):
        password = validated_data.pop('password', None)
        for f in ['first_name', 'last_name', 'email', 'role', 'telephone']:
            if f in validated_data: setattr(instance, f, validated_data[f])
        if password: instance.set_password(password)
        instance.save()
        self._sync_related_profiles(instance, validated_data)
        return instance

class MedecinSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source='user.get_full_name', read_only=True)
    class Meta:
        model = Medecin
        fields = ['user', 'full_name', 'specialite']

class PatientSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(source='user.get_full_name', read_only=True)
    age = serializers.ReadOnlyField()
    class Meta:
        model = Patient
        fields = ['user', 'full_name', 'cin', 'date_naissance', 'age', 'sexe', 'antecedents', 'allergies']

# --- UPDATED: Appointment Serializer with Motif and Emergency ---
class RendezVousSerializer(serializers.ModelSerializer):
    patient_name = serializers.CharField(source='patient.user.get_full_name', read_only=True)
    medecin_name = serializers.CharField(source='medecin.user.get_full_name', read_only=True)

    class Meta:
        model = RendezVous
        fields = ['id', 'date_rdv', 'statut', 'patient', 'patient_name', 'medecin', 'medecin_name', 'motif', 'is_emergency']

class MedicamentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medicament
        fields = '__all__'

class ConsultationSerializer(serializers.ModelSerializer):
    patient_name = serializers.CharField(source='rdv.patient.user.get_full_name', read_only=True)
    medecin_name = serializers.CharField(source='medecin.user.get_full_name', read_only=True)
    class Meta:
        model = Consultation
        fields = ['id', 'diagnostic', 'notes', 'date_consult', 'rdv', 'patient_name', 'medecin', 'medecin_name']

class OrdonnanceSerializer(serializers.ModelSerializer):
    medicaments = MedicamentSerializer(many=True, read_only=True)
    class Meta:
        model = Ordonnance
        fields = ['id', 'consultation', 'date_creation', 'medicaments']

class PaiementSerializer(serializers.ModelSerializer):
    class Meta:
        model = Paiement
        fields = ['id', 'montant', 'date_paiement', 'rdv']


class NotificationSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.get_full_name', read_only=True)
    class Meta:
        model = Notification
        fields = ['id', 'user', 'user_name', 'message', 'created_at', 'read']
