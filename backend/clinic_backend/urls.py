from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    # This line connects all your models (users, medecins, etc.)
    path('api/', include('core.urls')), 
]
