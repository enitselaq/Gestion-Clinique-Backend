from django.urls import reverse
from django.test import TestCase
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.test import APITestCase

from .admin import UtilisateurAdminCreationForm
from .models import Consultation, Medecin, Ordonnance, Paiement, Patient, RendezVous, Utilisateur


class UserRegistrationTests(APITestCase):
    def test_public_signup_creates_patient_profile(self):
        response = self.client.post(
            reverse('public-signup'),
            {
                'username': 'patient1',
                'password': 'StrongPass123',
                'first_name': 'Jane',
                'last_name': 'Doe',
                'email': 'jane@example.com',
                'telephone': '0600000000',
                'cin': 'AA123456',
                'date_naissance': '2000-01-02',
                'sexe': 'F',
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        user = Utilisateur.objects.get(username='patient1')
        self.assertEqual(user.role, 'PATIENT')
        self.assertTrue(Patient.objects.filter(user=user, cin='AA123456').exists())

    def test_public_signup_ignores_role_elevation_attempt(self):
        response = self.client.post(
            reverse('public-signup'),
            {
                'username': 'patient_admin_try',
                'password': 'StrongPass123',
                'first_name': 'Fake',
                'last_name': 'Admin',
                'email': 'fake@example.com',
                'telephone': '0600000001',
                'role': 'ADMIN',
                'cin': 'DD123456',
                'date_naissance': '2001-02-03',
                'sexe': 'M',
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        user = Utilisateur.objects.get(username='patient_admin_try')
        self.assertEqual(user.role, 'PATIENT')

    def test_forgot_password_resets_patient_password(self):
        user = Utilisateur.objects.create_user(
            username='forgot_patient',
            password='OldPass123',
            role='PATIENT',
        )
        Patient.objects.create(
            user=user,
            cin='FP123456',
            date_naissance='2000-05-06',
            sexe='F',
        )

        response = self.client.post(
            reverse('forgot-password'),
            {
                'username': 'forgot_patient',
                'cin': 'FP123456',
                'date_naissance': '2000-05-06',
                'new_password': 'NewPass123',
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        user.refresh_from_db()
        self.assertTrue(user.check_password('NewPass123'))


class AdminFormTests(TestCase):
    def test_admin_form_creates_patient_profile_for_patient_user(self):
        form = UtilisateurAdminCreationForm(
            data={
                'username': 'admin_created_patient',
                'password1': 'StrongPass123',
                'password2': 'StrongPass123',
                'first_name': 'Meriem',
                'last_name': 'Patient',
                'email': 'meriem@example.com',
                'role': 'PATIENT',
                'telephone': '0600000022',
                'patient_cin': 'ZX123456',
                'patient_date_naissance': '2002-03-04',
                'patient_sexe': 'F',
                'patient_antecedents': 'Asthma',
                'patient_allergies': 'Penicillin',
            }
        )

        self.assertTrue(form.is_valid(), form.errors)
        user = form.save()

        self.assertEqual(user.role, 'PATIENT')
        patient = Patient.objects.get(user=user)
        self.assertEqual(patient.cin, 'ZX123456')
        self.assertEqual(patient.antecedents, 'Asthma')
        self.assertEqual(patient.allergies, 'Penicillin')


class PermissionTests(APITestCase):
    def setUp(self):
        self.admin = Utilisateur.objects.create_user(
            username='admin1',
            password='StrongPass123',
            role='ADMIN',
        )
        self.receptionist = Utilisateur.objects.create_user(
            username='reception1',
            password='StrongPass123',
            role='REC',
        )
        self.doctor_user = Utilisateur.objects.create_user(
            username='doctor3',
            password='StrongPass123',
            role='MEDECIN',
        )
        self.doctor = Medecin.objects.get(user=self.doctor_user)
        self.doctor.specialite = 'Generaliste'
        self.doctor.save()
        self.patient_user = Utilisateur.objects.create_user(
            username='patient2',
            password='StrongPass123',
            role='PATIENT',
        )
        self.other_patient_user = Utilisateur.objects.create_user(
            username='patient3',
            password='StrongPass123',
            role='PATIENT',
        )
        self.patient = Patient.objects.create(
            user=self.patient_user,
            cin='BB123456',
            date_naissance='1999-05-01',
            sexe='M',
        )
        self.other_patient = Patient.objects.create(
            user=self.other_patient_user,
            cin='CC123456',
            date_naissance='1998-07-10',
            sexe='F',
        )
        self.confirmed_rdv = RendezVous.objects.create(
            patient=self.patient,
            medecin=self.doctor,
            cree_par=self.receptionist,
            date_rdv='2026-04-24T10:00:00Z',
            statut='CONFIRME',
        )
        self.waiting_rdv = RendezVous.objects.create(
            patient=self.other_patient,
            medecin=self.doctor,
            cree_par=self.receptionist,
            date_rdv='2026-04-24T11:00:00Z',
            statut='ATTENTE',
        )

    def authenticate(self, user):
        token = Token.objects.create(user=user)
        self.client.credentials(HTTP_AUTHORIZATION=f'Token {token.key}')

    def test_patient_cannot_list_users(self):
        self.authenticate(self.patient_user)

        response = self.client.get(reverse('user-list'))

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_patient_cannot_create_staff_account(self):
        self.authenticate(self.patient_user)

        response = self.client.post(
            reverse('user-list'),
            {
                'username': 'doctor1',
                'password': 'StrongPass123',
                'first_name': 'Doc',
                'last_name': 'One',
                'email': 'doc@example.com',
                'telephone': '0600000099',
                'role': 'MEDECIN',
                'medecin_specialite': 'Cardiologie',
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_admin_can_create_staff_account(self):
        self.authenticate(self.admin)

        response = self.client.post(
            reverse('user-list'),
            {
                'username': 'doctor2',
                'password': 'StrongPass123',
                'first_name': 'Sara',
                'last_name': 'Doctor',
                'email': 'doctor2@example.com',
                'telephone': '0600000088',
                'role': 'MEDECIN',
                'medecin_specialite': 'Dermatologie',
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        user = Utilisateur.objects.get(username='doctor2')
        self.assertEqual(user.role, 'MEDECIN')
        self.assertTrue(Medecin.objects.filter(user=user, specialite='Dermatologie').exists())

    def test_patient_sees_only_own_patient_record(self):
        self.authenticate(self.patient_user)

        response = self.client.get(reverse('patient-list'))

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['user'], self.patient_user.id)

    def test_admin_can_list_all_patients(self):
        self.authenticate(self.admin)

        response = self.client.get(reverse('patient-list'))

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

    def test_receptionist_can_list_all_patients(self):
        self.authenticate(self.receptionist)

        response = self.client.get(reverse('patient-list'))

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

    def test_receptionist_can_list_doctors(self):
        self.authenticate(self.receptionist)

        response = self.client.get(reverse('medecin-list'))

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['user'], self.doctor_user.id)

    def test_doctor_can_list_patients(self):
        self.authenticate(self.doctor_user)

        response = self.client.get(reverse('patient-list'))

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)

    def test_doctor_cannot_create_consultation_for_unconfirmed_appointment(self):
        self.authenticate(self.doctor_user)

        response = self.client.post(
            reverse('consultation-list'),
            {
                'diagnostic': 'Routine check',
                'notes': 'Waiting patient should not be consultable yet.',
                'rdv': self.waiting_rdv.id,
                'medecin': self.doctor_user.id,
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('rdv', response.data)

    def test_receptionist_cannot_register_payment_before_completion(self):
        self.authenticate(self.receptionist)

        response = self.client.post(
            reverse('paiement-list'),
            {
                'rdv': self.confirmed_rdv.id,
                'montant': '200.00',
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('rdv', response.data)

    def test_receptionist_can_register_payment_after_completion(self):
        self.confirmed_rdv.statut = 'TERMINE'
        self.confirmed_rdv.save(update_fields=['statut'])
        self.authenticate(self.receptionist)

        response = self.client.post(
            reverse('paiement-list'),
            {
                'rdv': self.confirmed_rdv.id,
                'montant': '200.00',
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(Paiement.objects.filter(rdv=self.confirmed_rdv).exists())

    def test_patient_can_register_payment_for_own_completed_appointment(self):
        self.confirmed_rdv.statut = 'TERMINE'
        self.confirmed_rdv.save(update_fields=['statut'])
        self.authenticate(self.patient_user)

        response = self.client.post(
            reverse('paiement-list'),
            {
                'rdv': self.confirmed_rdv.id,
                'montant': '200.00',
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(Paiement.objects.filter(rdv=self.confirmed_rdv).exists())

    def test_patient_cannot_pay_other_patient_appointment(self):
        self.waiting_rdv.statut = 'TERMINE'
        self.waiting_rdv.save(update_fields=['statut'])
        self.authenticate(self.patient_user)

        response = self.client.post(
            reverse('paiement-list'),
            {
                'rdv': self.waiting_rdv.id,
                'montant': '200.00',
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('rdv', response.data)

    def test_doctor_can_only_create_prescription_for_own_consultation(self):
        consultation = Consultation.objects.create(
            diagnostic='Flu',
            notes='Rest',
            rdv=self.confirmed_rdv,
            medecin=self.doctor,
        )
        other_doctor_user = Utilisateur.objects.create_user(
            username='doctor4',
            password='StrongPass123',
            role='MEDECIN',
        )
        self.authenticate(other_doctor_user)

        response = self.client.post(
            reverse('ordonnance-list'),
            {
                'consultation': consultation.id,
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('consultation', response.data)

    def test_doctor_can_mark_own_appointment_as_completed(self):
        self.authenticate(self.doctor_user)

        response = self.client.patch(
            reverse('rendezvous-detail', args=[self.confirmed_rdv.id]),
            {'statut': 'TERMINE'},
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.confirmed_rdv.refresh_from_db()
        self.assertEqual(self.confirmed_rdv.statut, 'TERMINE')

    def test_doctor_cannot_edit_appointment_schedule(self):
        self.authenticate(self.doctor_user)

        response = self.client.patch(
            reverse('rendezvous-detail', args=[self.confirmed_rdv.id]),
            {'date_rdv': '2026-04-25T09:00:00Z'},
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_authenticated_user_can_change_password(self):
        self.authenticate(self.patient_user)

        response = self.client.post(
            reverse('change-password'),
            {
                'current_password': 'StrongPass123',
                'new_password': 'UpdatedPass123',
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.patient_user.refresh_from_db()
        self.assertTrue(self.patient_user.check_password('UpdatedPass123'))
