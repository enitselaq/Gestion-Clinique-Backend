from django.contrib.auth.models import AbstractUser
from django.db import models
from datetime import date
from django.db.models.signals import post_save
from django.dispatch import receiver

# 1. USER MODEL (Centralized Authentication)
class Utilisateur(AbstractUser):
    ROLE_CHOICES = (
        ('ADMIN', 'Administrateur'),
        ('MEDECIN', 'Medecin'),
        ('REC', 'Receptionniste'),
        ('PATIENT', 'Patient'),
    )
    role = models.CharField(max_length=10, choices=ROLE_CHOICES)
    telephone = models.CharField(max_length=20, blank=True)

    def __str__(self):
        return f"{self.get_full_name()} ({self.role})"

# 2. MEDECIN MODEL (Specialized User)
class Medecin(models.Model):
    user = models.OneToOneField(Utilisateur, on_delete=models.CASCADE, primary_key=True)
    specialite = models.CharField(max_length=100)

    def __str__(self):
        return f"Dr. {self.user.last_name}"

# 3. PATIENT MODEL (Medical Profile)
class Patient(models.Model):
    user = models.OneToOneField(Utilisateur, on_delete=models.CASCADE, primary_key=True)
    cin = models.CharField(max_length=20, unique=True)
    date_naissance = models.DateField()
    sexe = models.CharField(
        max_length=10,
        choices=(('M', 'Masculin'), ('F', 'Feminin'))
    )
    antecedents = models.TextField(blank=True)
    allergies = models.TextField(blank=True)

    @property
    def age(self):
        """Calculates age automatically based on current date"""
        today = date.today()
        return today.year - self.date_naissance.year - (
            (today.month, today.day) < (self.date_naissance.month, self.date_naissance.day)
        )

    def __str__(self):
        return f"Patient: {self.user.last_name} ({self.cin})"

# 4. RENDEZ-VOUS MODEL (Scheduling Logic)
class RendezVous(models.Model):
    STATUS_CHOICES = (
        ('CONFIRME', 'Confirme'),
        ('ANNULE', 'Annule'),
        ('TERMINE', 'Termine'),
        ('ATTENTE', 'En attente'),
    )
    date_rdv = models.DateTimeField(db_index=True) # Optimized for searching
    statut = models.CharField(max_length=10, choices=STATUS_CHOICES, default='ATTENTE')
    # related_name allows: patient.rendez_vous.all() in Flutter API
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name='rendez_vous')
    medecin = models.ForeignKey(Medecin, on_delete=models.SET_NULL, null=True, related_name='rendez_vous')
    cree_par = models.ForeignKey(Utilisateur, on_delete=models.SET_NULL, null=True)

    class Meta:
        ordering = ['-date_rdv'] # Shows newest appointments first

    def __str__(self):
        return f"RDV {self.date_rdv.strftime('%d/%m/%Y %H:%M')} - {self.patient.user.last_name}"

# 5. CONSULTATION MODEL (Medical Act)
class Consultation(models.Model):
    diagnostic = models.TextField()
    notes = models.TextField(blank=True)
    date_consult = models.DateTimeField(auto_now_add=True)
    rdv = models.OneToOneField(RendezVous, on_delete=models.CASCADE, related_name='consultation')
    medecin = models.ForeignKey(Medecin, on_delete=models.CASCADE, related_name='consultations')

    def __str__(self):
        return f"Consultation {self.id} - {self.medecin.user.last_name}"

# 6. PAIEMENT MODEL (Financial Tracking)
class Paiement(models.Model):
    montant = models.DecimalField(max_digits=10, decimal_places=2)
    date_paiement = models.DateTimeField(auto_now_add=True)
    rdv = models.OneToOneField(RendezVous, on_delete=models.CASCADE, related_name='paiement')

    def __str__(self):
        return f"Paiement {self.montant} DH - RDV #{self.rdv.id}"

# 7. ORDONNANCE MODEL (Prescription Header)
class Ordonnance(models.Model):
    consultation = models.OneToOneField(Consultation, on_delete=models.CASCADE, related_name='ordonnance')
    date_creation = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Ordonnance #{self.id} - {self.consultation.rdv.patient.user.last_name}"

# 8. MEDICAMENT MODEL (Prescription Details)
class Medicament(models.Model):
    ordonnance = models.ForeignKey(Ordonnance, on_delete=models.CASCADE, related_name='medicaments')
    nom_generique = models.CharField(max_length=100)
    dosage = models.CharField(max_length=100)
    instructions = models.TextField(blank=True)

    def __str__(self):
        return self.nom_generique
    

@receiver(post_save, sender=Utilisateur)
def create_profile(sender, instance, created, **kwargs):
    if created:
        if instance.role == 'MEDECIN':
            # We keep this because Admins usually create Doctors 
            # without extra profile info initially.
            Medecin.objects.get_or_create(user=instance)

