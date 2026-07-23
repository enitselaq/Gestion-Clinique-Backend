from rest_framework import permissions

class IsAdmin(permissions.BasePermission):
    def has_permission(self, request, view):
        return bool(request.user and request.user.is_authenticated and request.user.role == 'ADMIN')

class IsAdminOrReceptionistReadOnly(permissions.BasePermission):
    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated:
            return False
        if request.method in permissions.SAFE_METHODS:
            return user.role in {'ADMIN', 'REC'}
        return user.role == 'ADMIN'

class IsAdminReceptionistOrReadOwnPatientRecord(permissions.BasePermission):
    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated:
            return False
        if request.method in permissions.SAFE_METHODS:
            return user.role in {'ADMIN', 'REC', 'MEDECIN', 'PATIENT'}
        return user.role == 'ADMIN'

    def has_object_permission(self, request, view, obj):
        user = request.user
        if request.method in permissions.SAFE_METHODS:
            return user.role in {'ADMIN', 'REC', 'MEDECIN'} or obj.user_id == user.id
        return user.role == 'ADMIN'

class RendezVousPermission(permissions.BasePermission):
    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated:
            return False

        # 1. Anyone authenticated can READ (GET) or CREATE (POST)
        # We handle specific creation logic inside the ViewSet's create() method
        if request.method in permissions.SAFE_METHODS or request.method == 'POST':
            return True

        # 2. Admins and Receptionists can perform any action
        if user.role in {'ADMIN', 'REC'}:
            return True

        # 3. Medecins can only UPDATE (PATCH/PUT) existing appointments
        if user.role == 'MEDECIN' and request.method in {'PATCH', 'PUT'}:
            return True

        return False

    def has_object_permission(self, request, view, obj):
        user = request.user
        if request.method in permissions.SAFE_METHODS:
            if user.role == 'ADMIN': return True
            if user.role == 'PATIENT': return obj.patient.user_id == user.id
            if user.role == 'MEDECIN': return obj.medecin and obj.medecin.user_id == user.id
            return user.role == 'REC'

        # Only Admins, Receptionists, or the assigned Doctor can modify an appointment
        if user.role in {'ADMIN', 'REC'}: return True
        if user.role == 'MEDECIN': return obj.medecin and obj.medecin.user_id == user.id
        return False

class ConsultationPermission(permissions.BasePermission):
    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated: return False
        if request.method in permissions.SAFE_METHODS: return True
        return user.role in {'ADMIN', 'MEDECIN'}

    def has_object_permission(self, request, view, obj):
        user = request.user
        if request.method in permissions.SAFE_METHODS:
            if user.role == 'ADMIN': return True
            if user.role == 'PATIENT': return obj.rdv.patient.user_id == user.id
            if user.role == 'MEDECIN': return obj.medecin.user_id == user.id
            return False
        return user.role == 'ADMIN' or obj.medecin.user_id == user.id

class OrdonnancePermission(permissions.BasePermission):
    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated: return False
        if request.method in permissions.SAFE_METHODS: return True
        return user.role in {'ADMIN', 'MEDECIN'}

    def has_object_permission(self, request, view, obj):
        user = request.user
        if request.method in permissions.SAFE_METHODS:
            if user.role == 'ADMIN': return True
            if user.role == 'PATIENT': return obj.consultation.rdv.patient.user_id == user.id
            if user.role == 'MEDECIN': return obj.consultation.medecin.user_id == user.id
            return False
        return user.role == 'ADMIN' or obj.consultation.medecin.user_id == user.id

class MedicamentPermission(permissions.BasePermission):
    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated: return False
        if request.method in permissions.SAFE_METHODS: return True
        return user.role in {'ADMIN', 'MEDECIN'}

    def has_object_permission(self, request, view, obj):
        user = request.user
        if request.method in permissions.SAFE_METHODS:
            if user.role == 'ADMIN': return True
            if user.role == 'PATIENT': return obj.ordonnance.consultation.rdv.patient.user_id == user.id
            if user.role == 'MEDECIN': return obj.ordonnance.consultation.medecin.user_id == user.id
            return False
        return user.role == 'ADMIN' or obj.ordonnance.consultation.medecin.user_id == user.id

class PaiementPermission(permissions.BasePermission):
    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated: return False
        if request.method in permissions.SAFE_METHODS: return True
        return user.role in {'ADMIN', 'REC', 'PATIENT'}

    def has_object_permission(self, request, view, obj):
        user = request.user
        if request.method in permissions.SAFE_METHODS:
            return user.role == 'ADMIN' or obj.rdv.patient.user_id == user.id
        return user.role in {'ADMIN', 'REC'}
