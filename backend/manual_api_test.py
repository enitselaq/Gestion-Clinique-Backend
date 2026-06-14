import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'clinic_backend.settings')
django.setup()

from django.urls import reverse
from rest_framework.test import APIClient
from core.models import Utilisateur, Patient, Medecin, RendezVous
from rest_framework.authtoken.models import Token

# Create or get a patient user
patient, created = Utilisateur.objects.get_or_create(username='manual_patient', defaults={'role':'PATIENT'})
if created:
    patient.set_password('pass1234')
    patient.save()

Patient.objects.get_or_create(user=patient, defaults={'cin':'ZZ123','date_naissance':'2000-01-01','sexe':'M'})

# Create or get a doctor user
doctor_user, created = Utilisateur.objects.get_or_create(username='manual_doc', defaults={'role':'MEDECIN'})
if created:
    doctor_user.set_password('pass1234')
    doctor_user.save()

Medecin.objects.get_or_create(user=doctor_user, defaults={'specialite':'General'})

doctor = Medecin.objects.get(user=doctor_user)

# Create a confirmed appointment
rdv, created = RendezVous.objects.get_or_create(
    patient=Patient.objects.get(user=patient),
    medecin=doctor,
    date_rdv='2026-06-15T10:00:00Z',
    defaults={'statut':'CONFIRME', 'cree_par': doctor_user}
)

# Create token for patient
Token.objects.filter(user=patient).delete()
token = Token.objects.create(user=patient)

client = APIClient()
client.credentials(HTTP_AUTHORIZATION=f'Token {token.key}')

resp = client.post(reverse('consultation-list'), {'diagnostic':'Manual test diag','notes':'manual test','rdv':rdv.id,'medecin':doctor_user.id}, format='json')
print('status', resp.status_code)
print('data', resp.data)
