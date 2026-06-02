from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    ChangePasswordView,
    PublicSignupView,
    ForgotPasswordResetView,
    UserViewSet, MedecinViewSet, PatientViewSet, 
    RendezVousViewSet, ConsultationViewSet, 
    OrdonnanceViewSet, MedicamentViewSet, PaiementViewSet,
    CustomAuthToken # Make sure this is imported if you use it in urlpatterns
)

# The router automatically generates the URL patterns for us
router = DefaultRouter()

# We add 'basename' to routes where the ViewSet uses get_queryset() 
# instead of a static queryset variable.
router.register(r'users', UserViewSet, basename='user')
router.register(r'medecins', MedecinViewSet, basename='medecin')
router.register(r'patients', PatientViewSet, basename='patient')
router.register(r'rendezvous', RendezVousViewSet, basename='rendezvous')
router.register(r'consultations', ConsultationViewSet, basename='consultation')
router.register(r'ordonnances', OrdonnanceViewSet, basename='ordonnance')
router.register(r'medicaments', MedicamentViewSet, basename='medicament')
router.register(r'paiements', PaiementViewSet, basename='paiement')

urlpatterns = [
    path('', include(router.urls)),
    path('signup/', PublicSignupView.as_view(), name='public-signup'),
    path('change-password/', ChangePasswordView.as_view(), name='change-password'),
    path('forgot-password/', ForgotPasswordResetView.as_view(), name='forgot-password'),
    # This is the endpoint your Flutter app calls for login
    path('login/', CustomAuthToken.as_view(), name='api_token_auth'), 
]
