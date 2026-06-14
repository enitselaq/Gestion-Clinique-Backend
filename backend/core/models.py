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
        today = date.today()
        return today.year - self.date_naissance.year - (
            (today.month, today.day) < (self.date_naissance.month, self.date_naissance.day)
        )

    def __str__(self):
        return f"Patient: {self.user.last_name} ({self.cin})"

# 4. RECEPTIONNISTE PROXY
class Receptionniste(Utilisateur):
    class Meta:
        proxy = True
        verbose_name = "Réceptionniste"
        verbose_name_plural = "Réceptionnistes"

# 5. RENDEZ-VOUS MODEL (Updated with Motif and Emergency)
class RendezVous(models.Model):
    STATUS_CHOICES = (
        ('ATTENTE', 'En attente'),
        ('CONFIRME', 'Confirmé'),
        ('ANNULE', 'Annulé'),
        ('TERMINE', 'Terminé'),
    )
    date_rdv = models.DateTimeField(db_index=True)
    statut = models.CharField(max_length=10, choices=STATUS_CHOICES, default='ATTENTE')
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name='rendez_vous')
    medecin = models.ForeignKey(Medecin, on_delete=models.SET_NULL, null=True, blank=True, related_name='rendez_vous')
    cree_par = models.ForeignKey(Utilisateur, on_delete=models.SET_NULL, null=True, blank=True)
    motif = models.TextField(blank=True, null=True) # <--- Symptoms or reason
    is_emergency = models.BooleanField(default=False) # <--- Ambulance case

    class Meta:
        ordering = ['-is_emergency', 'date_rdv']

    def __str__(self):
        return f"{'EMERGENCY ' if self.is_emergency else ''}RDV {self.date_rdv.strftime('%d/%m/%Y %H:%M')}"

# ... (rest of the models remain same)
class Consultation(models.Model):
    diagnostic = models.TextField()
    notes = models.TextField(blank=True)
    date_consult = models.DateTimeField(auto_now_add=True)
    rdv = models.OneToOneField(RendezVous, on_delete=models.CASCADE, related_name='consultation')
    medecin = models.ForeignKey(Medecin, on_delete=models.CASCADE, related_name='consultations')

class Paiement(models.Model):
    montant = models.DecimalField(max_digits=10, decimal_places=2)
    date_paiement = models.DateTimeField(auto_now_add=True)
    rdv = models.OneToOneField(RendezVous, on_delete=models.CASCADE, related_name='paiement')

class Ordonnance(models.Model):
    consultation = models.OneToOneField(Consultation, on_delete=models.CASCADE, related_name='ordonnance')
    date_creation = models.DateTimeField(auto_now_add=True)

class Medicament(models.Model):
    ordonnance = models.ForeignKey(Ordonnance, on_delete=models.CASCADE, related_name='medicaments')
    nom_generique = models.CharField(max_length=100)
    dosage = models.CharField(max_length=100)
    instructions = models.TextField(blank=True)


class Notification(models.Model):
    """Simple notification model to record messages sent to users.

    Use a DB-backed notification so the frontends can poll or show history.
    """
    user = models.ForeignKey(Utilisateur, on_delete=models.CASCADE, related_name='notifications')
    message = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    read = models.BooleanField(default=False)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Notification to {self.user.username} at {self.created_at.isoformat()}"

@receiver(post_save, sender=Utilisateur)
def create_profile(sender, instance, created, **kwargs):
    if created:
        if instance.role == 'MEDECIN':
            Medecin.objects.get_or_create(user=instance)
