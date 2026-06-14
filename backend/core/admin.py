from django import forms
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.forms import UserChangeForm, UserCreationForm

from .models import (
    Consultation,
    Medicament,
    Medecin,
    Ordonnance,
    Paiement,
    Patient,
    Receptionniste,
    RendezVous,
    Utilisateur,
)

# ... (Previous Mixins and User Admin forms remain the same)
class PatientProfileAdminFieldsMixin(forms.Form):
    patient_cin = forms.CharField(required=False, label='Patient CIN')
    patient_date_naissance = forms.DateField(
        required=False,
        label='Patient birth date',
        widget=forms.DateInput(attrs={'type': 'date'}),
    )
    patient_sexe = forms.ChoiceField(
        required=False,
        label='Patient sex',
        choices=Patient._meta.get_field('sexe').choices,
    )
    patient_antecedents = forms.CharField(
        required=False,
        label='Patient medical history',
        widget=forms.Textarea(attrs={'rows': 3}),
    )
    patient_allergies = forms.CharField(
        required=False,
        label='Patient allergies',
        widget=forms.Textarea(attrs={'rows': 3}),
    )

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        patient = getattr(self.instance, 'patient', None) if self.instance.pk else None
        if patient:
            self.fields['patient_cin'].initial = patient.cin
            self.fields['patient_date_naissance'].initial = patient.date_naissance
            self.fields['patient_sexe'].initial = patient.sexe
            self.fields['patient_antecedents'].initial = patient.antecedents
            self.fields['patient_allergies'].initial = patient.allergies

    def clean(self):
        cleaned_data = super().clean()
        role = cleaned_data.get('role')
        if role == 'PATIENT':
            required_fields = {
                'patient_cin': 'CIN is required for patient accounts.',
                'patient_date_naissance': 'Birth date is required for patient accounts.',
                'patient_sexe': 'Sex is required for patient accounts.',
            }
            for field_name, message in required_fields.items():
                if not cleaned_data.get(field_name):
                    self.add_error(field_name, message)
        return cleaned_data

    def save(self, commit=True):
        user = super().save(commit=commit)
        if not commit:
            return user
        if user.role == 'PATIENT':
            Patient.objects.update_or_create(
                user=user,
                defaults={
                    'cin': self.cleaned_data['patient_cin'],
                    'date_naissance': self.cleaned_data['patient_date_naissance'],
                    'sexe': self.cleaned_data['patient_sexe'],
                    'antecedents': self.cleaned_data.get('patient_antecedents') or '',
                    'allergies': self.cleaned_data.get('patient_allergies') or '',
                },
            )
        return user

class UtilisateurAdminCreationForm(PatientProfileAdminFieldsMixin, UserCreationForm):
    class Meta(UserCreationForm.Meta):
        model = Utilisateur
        fields = ('username', 'first_name', 'last_name', 'email', 'role', 'telephone')

class UtilisateurAdminChangeForm(PatientProfileAdminFieldsMixin, UserChangeForm):
    class Meta:
        model = Utilisateur
        fields = '__all__'

@admin.register(Utilisateur)
class UtilisateurAdmin(UserAdmin):
    form = UtilisateurAdminChangeForm
    add_form = UtilisateurAdminCreationForm
    model = Utilisateur
    list_display = ('username', 'first_name', 'last_name', 'email', 'role', 'telephone', 'is_staff')
    list_filter = ('role', 'is_staff', 'is_superuser', 'is_active')
    fieldsets = UserAdmin.fieldsets + (
        ('Clinic Role', {'fields': ('role', 'telephone')}),
        ('Patient Profile', {'fields': ('patient_cin', 'patient_date_naissance', 'patient_sexe', 'patient_antecedents', 'patient_allergies')}),
    )
    # Define add_fieldsets explicitly to avoid Django admin adding unexpected
    # pseudo-fields like `usable_password` into the ModelForm fields list.
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'password1', 'password2'),
        }),
        ('Clinic Role', {'fields': ('first_name', 'last_name', 'email', 'role', 'telephone')}),
        ('Patient Profile', {'fields': ('patient_cin', 'patient_date_naissance', 'patient_sexe', 'patient_antecedents', 'patient_allergies')}),
    )
    search_fields = ('username', 'first_name', 'last_name', 'email', 'telephone')
    ordering = ('username',)

@admin.register(Receptionniste)
class ReceptionnisteAdmin(UtilisateurAdmin):
    def get_queryset(self, request):
        return super().get_queryset(request).filter(role='REC')

# --- UPDATED: RendezVous Admin to show Motif and Emergency ---
@admin.register(RendezVous)
class RendezVousAdmin(admin.ModelAdmin):
    list_display = ('date_rdv', 'patient', 'statut', 'is_emergency')
    list_filter = ('statut', 'is_emergency', 'date_rdv')
    search_fields = ('patient__user__last_name', 'motif')
    # Helps see the symptoms in the list view
    readonly_fields = ('date_rdv', 'patient', 'motif', 'is_emergency')

@admin.register(Consultation)
class ConsultationAdmin(admin.ModelAdmin):
    list_display = ('medecin', 'date_consult', 'rdv')

@admin.register(Patient)
class PatientAdmin(admin.ModelAdmin):
    list_display = ('user', 'cin', 'date_naissance', 'sexe', 'age')
    search_fields = ('user__username', 'user__first_name', 'user__last_name', 'cin')

@admin.register(Medecin)
class MedecinAdmin(admin.ModelAdmin):
    list_display = ('user', 'specialite')
    search_fields = ('user__username', 'user__first_name', 'user__last_name', 'specialite')

admin.site.register(Paiement)
admin.site.register(Ordonnance)
admin.site.register(Medicament)
from .models import Notification

@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ('user', 'created_at', 'read')
    list_filter = ('read', 'created_at')
    search_fields = ('user__username', 'message')
