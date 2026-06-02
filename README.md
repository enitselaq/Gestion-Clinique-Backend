# Système de Gestion de Clinique (PFE)

## Structure
- `backend` Django backend
- `clinic_app` Flutter frontend

## Backend setup (Windows)
The backend now runs with SQLite by default, so PostgreSQL is optional.

```powershell
cd .\backend
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r .\requirements.txt
.\.venv\Scripts\python.exe .\manage.py migrate
.\.venv\Scripts\python.exe .\manage.py runserver
```

## Optional PostgreSQL configuration
If you want PostgreSQL instead of SQLite, define these environment variables before running Django:

```powershell
$env:POSTGRES_DB="GestionCliniqueDB"
$env:POSTGRES_USER="postgres"
$env:POSTGRES_PASSWORD="admin"
$env:POSTGRES_HOST="localhost"
$env:POSTGRES_PORT="5432"
```

## Frontend (Flutter)
```powershell
cd .\clinic_app
flutter pub get
flutter run
```

To target a custom backend host, pass:

```powershell
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000/api/
```
