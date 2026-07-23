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

```
Systeme de Gestion de Clinique (PFE)
├─ .idea
│  ├─ caches
│  │  └─ deviceStreaming.xml
│  ├─ deviceManager.xml
│  ├─ libraries
│  │  ├─ Dart_Packages.xml
│  │  └─ Dart_SDK.xml
│  ├─ markdown.xml
│  ├─ misc.xml
│  ├─ modules.xml
│  ├─ Systeme de Gestion de Clinique (PFE).iml
│  ├─ vcs.xml
│  └─ workspace.xml
├─ backend
│  ├─ clinic_backend
│  │  ├─ asgi.py
│  │  ├─ settings.py
│  │  ├─ urls.py
│  │  ├─ wsgi.py
│  │  └─ __init__.py
│  ├─ core
│  │  ├─ admin.py
│  │  ├─ apps.py
│  │  ├─ migrations
│  │  │  ├─ 0001_initial.py
│  │  │  ├─ 0002_alter_patient_sexe.py
│  │  │  ├─ 0003_rendezvous_medecin_alter_patient_sexe_and_more.py
│  │  │  ├─ 0004_receptionniste_alter_rendezvous_options_and_more.py
│  │  │  ├─ 0005_notification.py
│  │  │  ├─ 0006_alter_rendezvous_statut.py
│  │  │  └─ __init__.py
│  │  ├─ models.py
│  │  ├─ permissions.py
│  │  ├─ serializers.py
│  │  ├─ tests.py
│  │  ├─ urls.py
│  │  ├─ views.py
│  │  └─ __init__.py
│  ├─ manage.py
│  ├─ manual_api_test.py
│  ├─ README.md
│  ├─ requirements.txt
│  └─ staticfiles
│     ├─ admin
│     │  ├─ css
│     │  │  ├─ autocomplete.css
│     │  │  ├─ base.css
│     │  │  ├─ changelists.css
│     │  │  ├─ dark_mode.css
│     │  │  ├─ dashboard.css
│     │  │  ├─ forms.css
│     │  │  ├─ login.css
│     │  │  ├─ nav_sidebar.css
│     │  │  ├─ responsive.css
│     │  │  ├─ responsive_rtl.css
│     │  │  ├─ rtl.css
│     │  │  ├─ unusable_password_field.css
│     │  │  ├─ vendor
│     │  │  │  └─ select2
│     │  │  │     ├─ LICENSE-SELECT2.md
│     │  │  │     ├─ select2.css
│     │  │  │     └─ select2.min.css
│     │  │  └─ widgets.css
│     │  ├─ img
│     │  │  ├─ calendar-icons.svg
│     │  │  ├─ icon-addlink.svg
│     │  │  ├─ icon-alert-dark.svg
│     │  │  ├─ icon-alert.svg
│     │  │  ├─ icon-calendar.svg
│     │  │  ├─ icon-changelink.svg
│     │  │  ├─ icon-clock.svg
│     │  │  ├─ icon-debug-dark.svg
│     │  │  ├─ icon-debug.svg
│     │  │  ├─ icon-deletelink.svg
│     │  │  ├─ icon-hidelink.svg
│     │  │  ├─ icon-info-dark.svg
│     │  │  ├─ icon-info.svg
│     │  │  ├─ icon-no-dark.svg
│     │  │  ├─ icon-no.svg
│     │  │  ├─ icon-unknown-alt.svg
│     │  │  ├─ icon-unknown.svg
│     │  │  ├─ icon-viewlink.svg
│     │  │  ├─ icon-yes-dark.svg
│     │  │  ├─ icon-yes.svg
│     │  │  ├─ inline-delete.svg
│     │  │  ├─ README.md
│     │  │  ├─ search.svg
│     │  │  ├─ selector-icons.svg
│     │  │  ├─ sorting-icons.svg
│     │  │  ├─ tooltag-add.svg
│     │  │  └─ tooltag-arrowright.svg
│     │  └─ js
│     │     ├─ actions.js
│     │     ├─ admin
│     │     │  ├─ DateTimeShortcuts.js
│     │     │  └─ RelatedObjectLookups.js
│     │     ├─ autocomplete.js
│     │     ├─ calendar.js
│     │     ├─ cancel.js
│     │     ├─ change_form.js
│     │     ├─ core.js
│     │     ├─ filters.js
│     │     ├─ inlines.js
│     │     ├─ jquery.init.js
│     │     ├─ nav_sidebar.js
│     │     ├─ popup_response.js
│     │     ├─ prepopulate.js
│     │     ├─ prepopulate_init.js
│     │     ├─ SelectBox.js
│     │     ├─ SelectFilter2.js
│     │     ├─ theme.js
│     │     ├─ urlify.js
│     │     └─ vendor
│     │        ├─ jquery
│     │        │  ├─ jquery.js
│     │        │  ├─ jquery.min.js
│     │        │  └─ LICENSE.txt
│     │        ├─ select2
│     │        │  ├─ i18n
│     │        │  │  ├─ af.js
│     │        │  │  ├─ ar.js
│     │        │  │  ├─ az.js
│     │        │  │  ├─ bg.js
│     │        │  │  ├─ bn.js
│     │        │  │  ├─ bs.js
│     │        │  │  ├─ ca.js
│     │        │  │  ├─ cs.js
│     │        │  │  ├─ da.js
│     │        │  │  ├─ de.js
│     │        │  │  ├─ dsb.js
│     │        │  │  ├─ el.js
│     │        │  │  ├─ en.js
│     │        │  │  ├─ es.js
│     │        │  │  ├─ et.js
│     │        │  │  ├─ eu.js
│     │        │  │  ├─ fa.js
│     │        │  │  ├─ fi.js
│     │        │  │  ├─ fr.js
│     │        │  │  ├─ gl.js
│     │        │  │  ├─ he.js
│     │        │  │  ├─ hi.js
│     │        │  │  ├─ hr.js
│     │        │  │  ├─ hsb.js
│     │        │  │  ├─ hu.js
│     │        │  │  ├─ hy.js
│     │        │  │  ├─ id.js
│     │        │  │  ├─ is.js
│     │        │  │  ├─ it.js
│     │        │  │  ├─ ja.js
│     │        │  │  ├─ ka.js
│     │        │  │  ├─ km.js
│     │        │  │  ├─ ko.js
│     │        │  │  ├─ lt.js
│     │        │  │  ├─ lv.js
│     │        │  │  ├─ mk.js
│     │        │  │  ├─ ms.js
│     │        │  │  ├─ nb.js
│     │        │  │  ├─ ne.js
│     │        │  │  ├─ nl.js
│     │        │  │  ├─ pl.js
│     │        │  │  ├─ ps.js
│     │        │  │  ├─ pt-BR.js
│     │        │  │  ├─ pt.js
│     │        │  │  ├─ ro.js
│     │        │  │  ├─ ru.js
│     │        │  │  ├─ sk.js
│     │        │  │  ├─ sl.js
│     │        │  │  ├─ sq.js
│     │        │  │  ├─ sr-Cyrl.js
│     │        │  │  ├─ sr.js
│     │        │  │  ├─ sv.js
│     │        │  │  ├─ th.js
│     │        │  │  ├─ tk.js
│     │        │  │  ├─ tr.js
│     │        │  │  ├─ uk.js
│     │        │  │  ├─ vi.js
│     │        │  │  ├─ zh-CN.js
│     │        │  │  └─ zh-TW.js
│     │        │  ├─ LICENSE.md
│     │        │  ├─ select2.full.js
│     │        │  └─ select2.full.min.js
│     │        └─ xregexp
│     │           ├─ LICENSE.txt
│     │           ├─ xregexp.js
│     │           └─ xregexp.min.js
│     ├─ jazzmin
│     │  ├─ css
│     │  │  ├─ main.css
│     │  │  └─ main.css.backup
│     │  ├─ img
│     │  │  ├─ calendar-icons.svg
│     │  │  ├─ default-log.svg
│     │  │  ├─ default.jpg
│     │  │  ├─ icon-calendar.svg
│     │  │  ├─ icon-changelink.svg
│     │  │  └─ selector-icons.svg
│     │  ├─ js
│     │  │  ├─ change_form.js
│     │  │  ├─ change_list.js
│     │  │  ├─ main.js
│     │  │  ├─ related-modal.js
│     │  │  └─ ui-builder.js
│     │  └─ plugins
│     │     └─ bootstrap-show-modal
│     │        └─ bootstrap-show-modal.min.js
│     ├─ rest_framework
│     │  ├─ css
│     │  │  ├─ bootstrap-theme.min.css
│     │  │  ├─ bootstrap-theme.min.css.map
│     │  │  ├─ bootstrap-tweaks.css
│     │  │  ├─ bootstrap.min.css
│     │  │  ├─ bootstrap.min.css.map
│     │  │  ├─ default.css
│     │  │  ├─ font-awesome-4.0.3.css
│     │  │  └─ prettify.css
│     │  ├─ docs
│     │  │  ├─ css
│     │  │  │  ├─ base.css
│     │  │  │  ├─ highlight.css
│     │  │  │  └─ jquery.json-view.min.css
│     │  │  ├─ img
│     │  │  │  ├─ favicon.ico
│     │  │  │  └─ grid.png
│     │  │  └─ js
│     │  │     ├─ api.js
│     │  │     ├─ highlight.pack.js
│     │  │     └─ jquery.json-view.min.js
│     │  ├─ fonts
│     │  │  ├─ fontawesome-webfont.eot
│     │  │  ├─ fontawesome-webfont.svg
│     │  │  ├─ fontawesome-webfont.ttf
│     │  │  ├─ fontawesome-webfont.woff
│     │  │  ├─ glyphicons-halflings-regular.eot
│     │  │  ├─ glyphicons-halflings-regular.svg
│     │  │  ├─ glyphicons-halflings-regular.ttf
│     │  │  ├─ glyphicons-halflings-regular.woff
│     │  │  └─ glyphicons-halflings-regular.woff2
│     │  ├─ img
│     │  │  ├─ glyphicons-halflings-white.png
│     │  │  ├─ glyphicons-halflings.png
│     │  │  └─ grid.png
│     │  └─ js
│     │     ├─ ajax-form.js
│     │     ├─ bootstrap.min.js
│     │     ├─ coreapi-0.1.1.js
│     │     ├─ csrf.js
│     │     ├─ default.js
│     │     ├─ jquery-3.7.1.min.js
│     │     ├─ load-ajax-form.js
│     │     └─ prettify-min.js
│     ├─ silk
│     │  ├─ css
│     │  │  ├─ components
│     │  │  │  ├─ cell.css
│     │  │  │  ├─ colors.css
│     │  │  │  ├─ fonts.css
│     │  │  │  ├─ heading.css
│     │  │  │  ├─ numeric.css
│     │  │  │  ├─ row.css
│     │  │  │  └─ summary.css
│     │  │  └─ pages
│     │  │     ├─ base.css
│     │  │     ├─ clear_db.css
│     │  │     ├─ cprofile.css
│     │  │     ├─ detail_base.css
│     │  │     ├─ profile_detail.css
│     │  │     ├─ profiling.css
│     │  │     ├─ raw.css
│     │  │     ├─ request.css
│     │  │     ├─ requests.css
│     │  │     ├─ root_base.css
│     │  │     ├─ sql.css
│     │  │     ├─ sql_detail.css
│     │  │     └─ summary.css
│     │  ├─ favicon-16x16.png
│     │  ├─ favicon-32x32.png
│     │  ├─ filter.png
│     │  ├─ filter2.png
│     │  ├─ fonts
│     │  │  ├─ fantasque
│     │  │  │  ├─ FantasqueSansMono-Bold.woff
│     │  │  │  ├─ FantasqueSansMono-BoldItalic.woff
│     │  │  │  ├─ FantasqueSansMono-RegItalic.woff
│     │  │  │  └─ FantasqueSansMono-Regular.woff
│     │  │  ├─ fira
│     │  │  │  ├─ FiraSans-Bold.woff
│     │  │  │  ├─ FiraSans-BoldItalic.woff
│     │  │  │  ├─ FiraSans-Light.woff
│     │  │  │  ├─ FiraSans-LightItalic.woff
│     │  │  │  ├─ FiraSans-Medium.woff
│     │  │  │  ├─ FiraSans-MediumItalic.woff
│     │  │  │  ├─ FiraSans-Regular.woff
│     │  │  │  └─ FiraSans-RegularItalic.woff
│     │  │  ├─ glyphicons-halflings-regular.eot
│     │  │  ├─ glyphicons-halflings-regular.svg
│     │  │  ├─ glyphicons-halflings-regular.ttf
│     │  │  ├─ glyphicons-halflings-regular.woff
│     │  │  └─ glyphicons-halflings-regular.woff2
│     │  ├─ js
│     │  │  ├─ components
│     │  │  │  ├─ cell.js
│     │  │  │  └─ filters.js
│     │  │  └─ pages
│     │  │     ├─ base.js
│     │  │     ├─ clear_db.js
│     │  │     ├─ detail_base.js
│     │  │     ├─ profile_detail.js
│     │  │     ├─ profiling.js
│     │  │     ├─ raw.js
│     │  │     ├─ request.js
│     │  │     ├─ requests.js
│     │  │     ├─ root_base.js
│     │  │     ├─ sql.js
│     │  │     ├─ sql_detail.js
│     │  │     └─ summary.js
│     │  └─ lib
│     │     ├─ bootstrap-datetimepicker.min.css
│     │     ├─ bootstrap-datetimepicker.min.js
│     │     ├─ bootstrap-theme.min.css
│     │     ├─ bootstrap.min.css
│     │     ├─ bootstrap.min.js
│     │     ├─ highlight
│     │     │  ├─ foundation.css
│     │     │  └─ highlight.pack.js
│     │     ├─ images
│     │     │  ├─ animated-overlay.gif
│     │     │  ├─ ui-bg_diagonals-thick_18_b81900_40x40.png
│     │     │  ├─ ui-bg_diagonals-thick_20_666666_40x40.png
│     │     │  ├─ ui-bg_flat_10_000000_40x100.png
│     │     │  ├─ ui-bg_glass_100_f6f6f6_1x400.png
│     │     │  ├─ ui-bg_glass_100_fdf5ce_1x400.png
│     │     │  ├─ ui-bg_glass_55_fbf9ee_1x400.png
│     │     │  ├─ ui-bg_glass_65_ffffff_1x400.png
│     │     │  ├─ ui-bg_glass_75_dadada_1x400.png
│     │     │  ├─ ui-bg_glass_75_e6e6e6_1x400.png
│     │     │  ├─ ui-bg_glass_95_fef1ec_1x400.png
│     │     │  ├─ ui-bg_gloss-wave_35_f6a828_500x100.png
│     │     │  ├─ ui-bg_highlight-soft_100_eeeeee_1x100.png
│     │     │  ├─ ui-bg_highlight-soft_75_cccccc_1x100.png
│     │     │  ├─ ui-bg_highlight-soft_75_ffe45c_1x100.png
│     │     │  ├─ ui-icons_222222_256x240.png
│     │     │  ├─ ui-icons_228ef1_256x240.png
│     │     │  ├─ ui-icons_2e83ff_256x240.png
│     │     │  ├─ ui-icons_444444_256x240.png
│     │     │  ├─ ui-icons_454545_256x240.png
│     │     │  ├─ ui-icons_555555_256x240.png
│     │     │  ├─ ui-icons_777620_256x240.png
│     │     │  ├─ ui-icons_777777_256x240.png
│     │     │  ├─ ui-icons_888888_256x240.png
│     │     │  ├─ ui-icons_cc0000_256x240.png
│     │     │  ├─ ui-icons_cd0a0a_256x240.png
│     │     │  ├─ ui-icons_ef8c08_256x240.png
│     │     │  ├─ ui-icons_ffd27a_256x240.png
│     │     │  └─ ui-icons_ffffff_256x240.png
│     │     ├─ jquery-3.6.0.min.js
│     │     ├─ jquery-ui-1.13.1.min.css
│     │     ├─ jquery-ui-1.13.1.min.js
│     │     ├─ jquery-ui-1.13.2.min.css
│     │     ├─ jquery-ui-1.13.2.min.js
│     │     ├─ jquery.datetimepicker.css
│     │     ├─ jquery.datetimepicker.js
│     │     ├─ sortable.js
│     │     ├─ svg-pan-zoom.min.js
│     │     └─ viz-lite.js
│     └─ vendor
│        ├─ adminlte
│        │  ├─ css
│        │  │  ├─ adminlte.min.css
│        │  │  └─ adminlte.min.css.map
│        │  ├─ img
│        │  │  ├─ AdminLTELogo.png
│        │  │  ├─ icons.png
│        │  │  └─ user2-160x160.jpg
│        │  └─ js
│        │     ├─ adminlte.min.js
│        │     └─ adminlte.min.js.map
│        ├─ bootstrap
│        │  └─ js
│        │     ├─ bootstrap.bundle.min.js
│        │     ├─ bootstrap.min.js
│        │     └─ bootstrap.min.js.map
│        ├─ bootswatch
│        │  ├─ brite
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ cerulean
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ cosmo
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ cyborg
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ darkly
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ default
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ flatly
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ journal
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ litera
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ lumen
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ lux
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ materia
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ minty
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ morph
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ pulse
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ quartz
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ sandstone
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ simplex
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ sketchy
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ slate
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ solar
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ spacelab
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ superhero
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ united
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ vapor
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  ├─ yeti
│        │  │  ├─ bootstrap.min.css
│        │  │  └─ bootstrap.min.css.map
│        │  └─ zephyr
│        │     ├─ bootstrap.min.css
│        │     └─ bootstrap.min.css.map
│        ├─ fontawesome-free
│        │  ├─ css
│        │  │  └─ all.min.css
│        │  └─ webfonts
│        │     ├─ fa-brands-400.ttf
│        │     ├─ fa-brands-400.woff2
│        │     ├─ fa-regular-400.ttf
│        │     ├─ fa-regular-400.woff2
│        │     ├─ fa-solid-900.ttf
│        │     ├─ fa-solid-900.woff2
│        │     ├─ fa-v4compatibility.ttf
│        │     └─ fa-v4compatibility.woff2
│        └─ select2
│           ├─ css
│           │  └─ select2.min.css
│           └─ js
│              └─ select2.min.js
├─ clinic_app
│  ├─ .dart_tool
│  │  ├─ dartpad
│  │  │  └─ web_plugin_registrant.dart
│  │  ├─ extension_discovery
│  │  │  └─ vs_code.json
│  │  ├─ flutter_build
│  │  │  ├─ 3dffb6c012edcc38d9dbe0280d3c8260
│  │  │  │  ├─ .filecache
│  │  │  │  ├─ app.dill
│  │  │  │  ├─ dart_build.d
│  │  │  │  ├─ dart_build.stamp
│  │  │  │  ├─ dart_build_result.json
│  │  │  │  ├─ debug_android_application.stamp
│  │  │  │  ├─ flutter_assets.d
│  │  │  │  ├─ gen_dart_plugin_registrant.stamp
│  │  │  │  ├─ gen_l10n_inputs_and_outputs.json
│  │  │  │  ├─ gen_localizations.d
│  │  │  │  ├─ gen_localizations.stamp
│  │  │  │  ├─ install_code_assets.d
│  │  │  │  ├─ install_code_assets.stamp
│  │  │  │  ├─ kernel_snapshot_program.d
│  │  │  │  ├─ kernel_snapshot_program.stamp
│  │  │  │  ├─ native_assets.json
│  │  │  │  └─ outputs.json
│  │  │  ├─ dart_plugin_registrant.dart
│  │  │  └─ f71ff148aae0cf4ee41c516542ed0431
│  │  │     ├─ .filecache
│  │  │     ├─ app.dill
│  │  │     ├─ dart_build.d
│  │  │     ├─ dart_build.stamp
│  │  │     ├─ dart_build_result.json
│  │  │     ├─ debug_android_application.stamp
│  │  │     ├─ flutter_assets.d
│  │  │     ├─ gen_dart_plugin_registrant.stamp
│  │  │     ├─ gen_l10n_inputs_and_outputs.json
│  │  │     ├─ gen_localizations.d
│  │  │     ├─ gen_localizations.stamp
│  │  │     ├─ install_code_assets.d
│  │  │     ├─ install_code_assets.stamp
│  │  │     ├─ kernel_snapshot_program.d
│  │  │     ├─ kernel_snapshot_program.stamp
│  │  │     ├─ native_assets.json
│  │  │     └─ outputs.json
│  │  ├─ hooks_runner
│  │  │  ├─ objective_c
│  │  │  │  ├─ 102ed48957
│  │  │  │  │  ├─ .lock
│  │  │  │  │  ├─ dependencies.dependencies_hash_file.json
│  │  │  │  │  ├─ hook.dependencies_hash_file.json
│  │  │  │  │  ├─ hook.dill
│  │  │  │  │  ├─ hook.dill.d
│  │  │  │  │  ├─ input.json
│  │  │  │  │  ├─ out
│  │  │  │  │  ├─ output.json
│  │  │  │  │  ├─ stderr.txt
│  │  │  │  │  └─ stdout.txt
│  │  │  │  ├─ 337ce265dc
│  │  │  │  │  ├─ .lock
│  │  │  │  │  ├─ dependencies.dependencies_hash_file.json
│  │  │  │  │  ├─ hook.dependencies_hash_file.json
│  │  │  │  │  ├─ hook.dill
│  │  │  │  │  ├─ hook.dill.d
│  │  │  │  │  ├─ input.json
│  │  │  │  │  ├─ out
│  │  │  │  │  ├─ output.json
│  │  │  │  │  ├─ stderr.txt
│  │  │  │  │  └─ stdout.txt
│  │  │  │  └─ 3c81eb0ac6
│  │  │  │     ├─ .lock
│  │  │  │     ├─ dependencies.dependencies_hash_file.json
│  │  │  │     ├─ hook.dependencies_hash_file.json
│  │  │  │     ├─ hook.dill
│  │  │  │     ├─ hook.dill.d
│  │  │  │     ├─ input.json
│  │  │  │     ├─ out
│  │  │  │     ├─ output.json
│  │  │  │     ├─ stderr.txt
│  │  │  │     └─ stdout.txt
│  │  │  └─ shared
│  │  │     └─ objective_c
│  │  │        ├─ .lock
│  │  │        └─ build
│  │  │           ├─ 102ed48957
│  │  │           ├─ 337ce265dc
│  │  │           └─ 3c81eb0ac6
│  │  ├─ package_config.json
│  │  ├─ package_graph.json
│  │  └─ version
│  ├─ .flutter-plugins-dependencies
│  ├─ .idea
│  │  ├─ caches
│  │  │  └─ deviceStreaming.xml
│  │  ├─ clinic_app.iml
│  │  ├─ deviceManager.xml
│  │  ├─ libraries
│  │  │  ├─ Dart_Packages.xml
│  │  │  ├─ Dart_SDK.xml
│  │  │  └─ KotlinJavaRuntime.xml
│  │  ├─ markdown.xml
│  │  ├─ misc.xml
│  │  ├─ modules.xml
│  │  ├─ runConfigurations
│  │  │  └─ main_dart.xml
│  │  ├─ vcs.xml
│  │  └─ workspace.xml
│  ├─ .metadata
│  ├─ analysis_options.yaml
│  ├─ android
│  │  ├─ .gradle
│  │  │  ├─ 8.13
│  │  │  │  ├─ checksums
│  │  │  │  │  ├─ checksums.lock
│  │  │  │  │  ├─ md5-checksums.bin
│  │  │  │  │  └─ sha1-checksums.bin
│  │  │  │  ├─ executionHistory
│  │  │  │  │  ├─ executionHistory.bin
│  │  │  │  │  └─ executionHistory.lock
│  │  │  │  ├─ expanded
│  │  │  │  │  └─ expanded.lock
│  │  │  │  ├─ fileChanges
│  │  │  │  │  └─ last-build.bin
│  │  │  │  ├─ fileHashes
│  │  │  │  │  ├─ fileHashes.bin
│  │  │  │  │  ├─ fileHashes.lock
│  │  │  │  │  └─ resourceHashesCache.bin
│  │  │  │  ├─ gc.properties
│  │  │  │  └─ vcsMetadata
│  │  │  ├─ 8.14
│  │  │  │  ├─ checksums
│  │  │  │  │  ├─ checksums.lock
│  │  │  │  │  ├─ md5-checksums.bin
│  │  │  │  │  └─ sha1-checksums.bin
│  │  │  │  ├─ executionHistory
│  │  │  │  │  ├─ executionHistory.bin
│  │  │  │  │  └─ executionHistory.lock
│  │  │  │  ├─ expanded
│  │  │  │  ├─ fileChanges
│  │  │  │  │  └─ last-build.bin
│  │  │  │  ├─ fileHashes
│  │  │  │  │  ├─ fileHashes.bin
│  │  │  │  │  ├─ fileHashes.lock
│  │  │  │  │  └─ resourceHashesCache.bin
│  │  │  │  ├─ gc.properties
│  │  │  │  └─ vcsMetadata
│  │  │  ├─ buildOutputCleanup
│  │  │  │  ├─ buildOutputCleanup.lock
│  │  │  │  ├─ cache.properties
│  │  │  │  └─ outputFiles.bin
│  │  │  ├─ file-system.probe
│  │  │  ├─ kotlin
│  │  │  │  └─ errors
│  │  │  │     └─ errors-1769631203874.log
│  │  │  ├─ nb-cache
│  │  │  │  ├─ android-830330287
│  │  │  │  │  └─ project-info.ser
│  │  │  │  ├─ app-296177036
│  │  │  │  │  └─ project-info.ser
│  │  │  │  ├─ subprojects.ser
│  │  │  │  └─ trust
│  │  │  │     ├─ 4FF44BAA35907A121727EB556969424F17C004D01DC18F8B6075456845DB5624
│  │  │  │     ├─ C5CF713308172EBE103B32D9A7F06D9D902D603A71FC968E7215466D6FC31DC5
│  │  │  │     └─ D2E70ECC5AFC2D183944168816499D4CDFFD9F23E873F45A1A3A7A22D75F1204
│  │  │  ├─ noVersion
│  │  │  │  └─ buildLogic.lock
│  │  │  └─ vcs-1
│  │  │     └─ gc.properties
│  │  ├─ .kotlin
│  │  │  ├─ errors
│  │  │  │  └─ errors-1769631203874.log
│  │  │  └─ sessions
│  │  ├─ android.iml
│  │  ├─ app
│  │  │  ├─ build.gradle.kts
│  │  │  └─ src
│  │  │     ├─ debug
│  │  │     │  └─ AndroidManifest.xml
│  │  │     ├─ main
│  │  │     │  ├─ AndroidManifest.xml
│  │  │     │  ├─ java
│  │  │     │  │  └─ io
│  │  │     │  │     └─ flutter
│  │  │     │  │        └─ plugins
│  │  │     │  │           └─ GeneratedPluginRegistrant.java
│  │  │     │  ├─ kotlin
│  │  │     │  │  └─ com
│  │  │     │  │     └─ example
│  │  │     │  │        └─ clinic_app
│  │  │     │  │           └─ MainActivity.kt
│  │  │     │  └─ res
│  │  │     │     ├─ drawable
│  │  │     │     │  ├─ background.png
│  │  │     │     │  └─ launch_background.xml
│  │  │     │     ├─ drawable-hdpi
│  │  │     │     │  ├─ android12splash.png
│  │  │     │     │  ├─ branding.png
│  │  │     │     │  └─ splash.png
│  │  │     │     ├─ drawable-hdpi-v31
│  │  │     │     │  └─ android12branding.png
│  │  │     │     ├─ drawable-mdpi
│  │  │     │     │  ├─ android12splash.png
│  │  │     │     │  ├─ branding.png
│  │  │     │     │  └─ splash.png
│  │  │     │     ├─ drawable-mdpi-v31
│  │  │     │     │  └─ android12branding.png
│  │  │     │     ├─ drawable-night-hdpi
│  │  │     │     │  └─ android12splash.png
│  │  │     │     ├─ drawable-night-hdpi-v31
│  │  │     │     │  └─ android12branding.png
│  │  │     │     ├─ drawable-night-mdpi
│  │  │     │     │  └─ android12splash.png
│  │  │     │     ├─ drawable-night-mdpi-v31
│  │  │     │     │  └─ android12branding.png
│  │  │     │     ├─ drawable-night-xhdpi
│  │  │     │     │  └─ android12splash.png
│  │  │     │     ├─ drawable-night-xhdpi-v31
│  │  │     │     │  └─ android12branding.png
│  │  │     │     ├─ drawable-night-xxhdpi
│  │  │     │     │  └─ android12splash.png
│  │  │     │     ├─ drawable-night-xxhdpi-v31
│  │  │     │     │  └─ android12branding.png
│  │  │     │     ├─ drawable-night-xxxhdpi
│  │  │     │     │  └─ android12splash.png
│  │  │     │     ├─ drawable-night-xxxhdpi-v31
│  │  │     │     │  └─ android12branding.png
│  │  │     │     ├─ drawable-v21
│  │  │     │     │  ├─ background.png
│  │  │     │     │  └─ launch_background.xml
│  │  │     │     ├─ drawable-xhdpi
│  │  │     │     │  ├─ android12splash.png
│  │  │     │     │  ├─ branding.png
│  │  │     │     │  └─ splash.png
│  │  │     │     ├─ drawable-xhdpi-v31
│  │  │     │     │  └─ android12branding.png
│  │  │     │     ├─ drawable-xxhdpi
│  │  │     │     │  ├─ android12splash.png
│  │  │     │     │  ├─ branding.png
│  │  │     │     │  └─ splash.png
│  │  │     │     ├─ drawable-xxhdpi-v31
│  │  │     │     │  └─ android12branding.png
│  │  │     │     ├─ drawable-xxxhdpi
│  │  │     │     │  ├─ android12splash.png
│  │  │     │     │  ├─ branding.png
│  │  │     │     │  └─ splash.png
│  │  │     │     ├─ drawable-xxxhdpi-v31
│  │  │     │     │  └─ android12branding.png
│  │  │     │     ├─ mipmap-hdpi
│  │  │     │     │  └─ ic_launcher.png
│  │  │     │     ├─ mipmap-mdpi
│  │  │     │     │  └─ ic_launcher.png
│  │  │     │     ├─ mipmap-xhdpi
│  │  │     │     │  └─ ic_launcher.png
│  │  │     │     ├─ mipmap-xxhdpi
│  │  │     │     │  └─ ic_launcher.png
│  │  │     │     ├─ mipmap-xxxhdpi
│  │  │     │     │  └─ ic_launcher.png
│  │  │     │     ├─ values
│  │  │     │     │  └─ styles.xml
│  │  │     │     ├─ values-night
│  │  │     │     │  └─ styles.xml
│  │  │     │     ├─ values-night-v31
│  │  │     │     │  └─ styles.xml
│  │  │     │     └─ values-v31
│  │  │     │        └─ styles.xml
│  │  │     └─ profile
│  │  │        └─ AndroidManifest.xml
│  │  ├─ build.gradle.kts
│  │  ├─ clinic_app_android.iml
│  │  ├─ gradle
│  │  │  └─ wrapper
│  │  │     ├─ gradle-wrapper.jar
│  │  │     └─ gradle-wrapper.properties
│  │  ├─ gradle.properties
│  │  ├─ gradlew
│  │  ├─ gradlew.bat
│  │  ├─ hs_err_pid10420.log
│  │  ├─ local.properties
│  │  ├─ replay_pid10420.log
│  │  └─ settings.gradle.kts
│  ├─ assets
│  │  ├─ argana_bg.png
│  │  ├─ argana_c_logo.png
│  │  ├─ argana_title.png
│  │  └─ pdf_logo_argana.png
│  ├─ assets.zip
│  ├─ build
│  │  ├─ .cxx
│  │  │  └─ debug
│  │  │     └─ 1b5d5f40
│  │  │        ├─ arm64-v8a
│  │  │        │  ├─ .cmake
│  │  │        │  │  └─ api
│  │  │        │  │     └─ v1
│  │  │        │  │        ├─ query
│  │  │        │  │        │  └─ client-agp
│  │  │        │  │        │     ├─ cache-v2
│  │  │        │  │        │     ├─ cmakeFiles-v1
│  │  │        │  │        │     └─ codemodel-v2
│  │  │        │  │        └─ reply
│  │  │        │  │           ├─ cache-v2-425f72563ab892aa6f91.json
│  │  │        │  │           ├─ cmakeFiles-v1-81d2c8eedd47af10d10a.json
│  │  │        │  │           ├─ codemodel-v2-df53db58e9a2e3dd41fb.json
│  │  │        │  │           ├─ directory-.-debug-d0094a50bb2071803777.json
│  │  │        │  │           └─ index-2026-06-13T21-57-28-0310.json
│  │  │        │  ├─ additional_project_files.txt
│  │  │        │  ├─ android_gradle_build.json
│  │  │        │  ├─ android_gradle_build_mini.json
│  │  │        │  ├─ build.ninja
│  │  │        │  ├─ build_file_index.txt
│  │  │        │  ├─ CMakeCache.txt
│  │  │        │  ├─ CMakeFiles
│  │  │        │  │  ├─ 3.22.1-g37088a8-dirty
│  │  │        │  │  │  ├─ CMakeCCompiler.cmake
│  │  │        │  │  │  ├─ CMakeCXXCompiler.cmake
│  │  │        │  │  │  ├─ CMakeDetermineCompilerABI_C.bin
│  │  │        │  │  │  ├─ CMakeDetermineCompilerABI_CXX.bin
│  │  │        │  │  │  ├─ CMakeSystem.cmake
│  │  │        │  │  │  ├─ CompilerIdC
│  │  │        │  │  │  │  ├─ CMakeCCompilerId.c
│  │  │        │  │  │  │  ├─ CMakeCCompilerId.o
│  │  │        │  │  │  │  └─ tmp
│  │  │        │  │  │  └─ CompilerIdCXX
│  │  │        │  │  │     ├─ CMakeCXXCompilerId.cpp
│  │  │        │  │  │     ├─ CMakeCXXCompilerId.o
│  │  │        │  │  │     └─ tmp
│  │  │        │  │  ├─ cmake.check_cache
│  │  │        │  │  ├─ CMakeOutput.log
│  │  │        │  │  ├─ CMakeTmp
│  │  │        │  │  ├─ rules.ninja
│  │  │        │  │  └─ TargetDirectories.txt
│  │  │        │  ├─ cmake_install.cmake
│  │  │        │  ├─ configure_fingerprint.bin
│  │  │        │  ├─ metadata_generation_command.txt
│  │  │        │  ├─ prefab_config.json
│  │  │        │  └─ symbol_folder_index.txt
│  │  │        ├─ armeabi-v7a
│  │  │        │  ├─ .cmake
│  │  │        │  │  └─ api
│  │  │        │  │     └─ v1
│  │  │        │  │        ├─ query
│  │  │        │  │        │  └─ client-agp
│  │  │        │  │        │     ├─ cache-v2
│  │  │        │  │        │     ├─ cmakeFiles-v1
│  │  │        │  │        │     └─ codemodel-v2
│  │  │        │  │        └─ reply
│  │  │        │  │           ├─ cache-v2-71decf2d722ec58074b1.json
│  │  │        │  │           ├─ cmakeFiles-v1-d381d18066b0ec7a4b45.json
│  │  │        │  │           ├─ codemodel-v2-03724963069816517217.json
│  │  │        │  │           ├─ directory-.-debug-d0094a50bb2071803777.json
│  │  │        │  │           └─ index-2026-06-13T21-57-33-0783.json
│  │  │        │  ├─ additional_project_files.txt
│  │  │        │  ├─ android_gradle_build.json
│  │  │        │  ├─ android_gradle_build_mini.json
│  │  │        │  ├─ build.ninja
│  │  │        │  ├─ build_file_index.txt
│  │  │        │  ├─ CMakeCache.txt
│  │  │        │  ├─ CMakeFiles
│  │  │        │  │  ├─ 3.22.1-g37088a8-dirty
│  │  │        │  │  │  ├─ CMakeCCompiler.cmake
│  │  │        │  │  │  ├─ CMakeCXXCompiler.cmake
│  │  │        │  │  │  ├─ CMakeDetermineCompilerABI_C.bin
│  │  │        │  │  │  ├─ CMakeDetermineCompilerABI_CXX.bin
│  │  │        │  │  │  ├─ CMakeSystem.cmake
│  │  │        │  │  │  ├─ CompilerIdC
│  │  │        │  │  │  │  ├─ CMakeCCompilerId.c
│  │  │        │  │  │  │  ├─ CMakeCCompilerId.o
│  │  │        │  │  │  │  └─ tmp
│  │  │        │  │  │  └─ CompilerIdCXX
│  │  │        │  │  │     ├─ CMakeCXXCompilerId.cpp
│  │  │        │  │  │     ├─ CMakeCXXCompilerId.o
│  │  │        │  │  │     └─ tmp
│  │  │        │  │  ├─ cmake.check_cache
│  │  │        │  │  ├─ CMakeOutput.log
│  │  │        │  │  ├─ CMakeTmp
│  │  │        │  │  ├─ rules.ninja
│  │  │        │  │  └─ TargetDirectories.txt
│  │  │        │  ├─ cmake_install.cmake
│  │  │        │  ├─ configure_fingerprint.bin
│  │  │        │  ├─ metadata_generation_command.txt
│  │  │        │  ├─ prefab_config.json
│  │  │        │  └─ symbol_folder_index.txt
│  │  │        ├─ hash_key.txt
│  │  │        └─ x86_64
│  │  │           ├─ .cmake
│  │  │           │  └─ api
│  │  │           │     └─ v1
│  │  │           │        ├─ query
│  │  │           │        │  └─ client-agp
│  │  │           │        │     ├─ cache-v2
│  │  │           │        │     ├─ cmakeFiles-v1
│  │  │           │        │     └─ codemodel-v2
│  │  │           │        └─ reply
│  │  │           │           ├─ cache-v2-95dd2a2032eee825157f.json
│  │  │           │           ├─ cmakeFiles-v1-d1754f377b3aa78a2775.json
│  │  │           │           ├─ codemodel-v2-7101cd1e98fc21987f00.json
│  │  │           │           ├─ directory-.-debug-d0094a50bb2071803777.json
│  │  │           │           └─ index-2026-06-13T21-57-37-0872.json
│  │  │           ├─ additional_project_files.txt
│  │  │           ├─ android_gradle_build.json
│  │  │           ├─ android_gradle_build_mini.json
│  │  │           ├─ build.ninja
│  │  │           ├─ build_file_index.txt
│  │  │           ├─ CMakeCache.txt
│  │  │           ├─ CMakeFiles
│  │  │           │  ├─ 3.22.1-g37088a8-dirty
│  │  │           │  │  ├─ CMakeCCompiler.cmake
│  │  │           │  │  ├─ CMakeCXXCompiler.cmake
│  │  │           │  │  ├─ CMakeDetermineCompilerABI_C.bin
│  │  │           │  │  ├─ CMakeDetermineCompilerABI_CXX.bin
│  │  │           │  │  ├─ CMakeSystem.cmake
│  │  │           │  │  ├─ CompilerIdC
│  │  │           │  │  │  ├─ CMakeCCompilerId.c
│  │  │           │  │  │  ├─ CMakeCCompilerId.o
│  │  │           │  │  │  └─ tmp
│  │  │           │  │  └─ CompilerIdCXX
│  │  │           │  │     ├─ CMakeCXXCompilerId.cpp
│  │  │           │  │     ├─ CMakeCXXCompilerId.o
│  │  │           │  │     └─ tmp
│  │  │           │  ├─ cmake.check_cache
│  │  │           │  ├─ CMakeOutput.log
│  │  │           │  ├─ CMakeTmp
│  │  │           │  ├─ rules.ninja
│  │  │           │  └─ TargetDirectories.txt
│  │  │           ├─ cmake_install.cmake
│  │  │           ├─ configure_fingerprint.bin
│  │  │           ├─ metadata_generation_command.txt
│  │  │           ├─ prefab_config.json
│  │  │           └─ symbol_folder_index.txt
│  │  ├─ .last_build_id
│  │  ├─ 0ea6338a9744699c4765127c07d5f7ae.cache.dill.track.dill
│  │  ├─ 31f1d96a335ae06fab09c8eaf8e812e4
│  │  │  ├─ .filecache
│  │  │  ├─ gen_l10n_inputs_and_outputs.json
│  │  │  ├─ gen_localizations.d
│  │  │  ├─ gen_localizations.stamp
│  │  │  └─ outputs.json
│  │  ├─ app
│  │  │  ├─ deeplink.json
│  │  │  ├─ generated
│  │  │  │  ├─ ap_generated_sources
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ out
│  │  │  │  └─ res
│  │  │  │     ├─ pngs
│  │  │  │     │  └─ debug
│  │  │  │     └─ resValues
│  │  │  │        └─ debug
│  │  │  ├─ intermediates
│  │  │  │  ├─ aar_metadata_check
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ checkDebugAarMetadata
│  │  │  │  ├─ annotation_processor_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ javaPreCompileDebug
│  │  │  │  │        └─ annotationProcessors.json
│  │  │  │  ├─ apk_ide_redirect_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ createDebugApkListingFileRedirect
│  │  │  │  │        └─ redirect.txt
│  │  │  │  ├─ app_metadata
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ writeDebugAppMetadata
│  │  │  │  │        └─ app-metadata.properties
│  │  │  │  ├─ assets
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugAssets
│  │  │  │  │        └─ flutter_assets
│  │  │  │  │           ├─ AssetManifest.bin
│  │  │  │  │           ├─ assets
│  │  │  │  │           │  ├─ argana_bg.png
│  │  │  │  │           │  ├─ argana_c_logo.png
│  │  │  │  │           │  ├─ argana_title.png
│  │  │  │  │           │  └─ pdf_logo_argana.png
│  │  │  │  │           ├─ FontManifest.json
│  │  │  │  │           ├─ fonts
│  │  │  │  │           │  └─ MaterialIcons-Regular.otf
│  │  │  │  │           ├─ isolate_snapshot_data
│  │  │  │  │           ├─ kernel_blob.bin
│  │  │  │  │           ├─ NativeAssetsManifest.json
│  │  │  │  │           ├─ NOTICES.Z
│  │  │  │  │           ├─ packages
│  │  │  │  │           │  └─ cupertino_icons
│  │  │  │  │           │     └─ assets
│  │  │  │  │           │        └─ CupertinoIcons.ttf
│  │  │  │  │           ├─ shaders
│  │  │  │  │           │  ├─ ink_sparkle.frag
│  │  │  │  │           │  └─ stretch_effect.frag
│  │  │  │  │           └─ vm_snapshot_data
│  │  │  │  ├─ compatible_screen_manifest
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ createDebugCompatibleScreenManifests
│  │  │  │  │        └─ output-metadata.json
│  │  │  │  ├─ compile_and_runtime_not_namespaced_r_class_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugResources
│  │  │  │  │        └─ R.jar
│  │  │  │  ├─ compressed_assets
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ compressDebugAssets
│  │  │  │  │        └─ out
│  │  │  │  │           └─ assets
│  │  │  │  │              └─ flutter_assets
│  │  │  │  │                 ├─ AssetManifest.bin.jar
│  │  │  │  │                 ├─ assets
│  │  │  │  │                 │  ├─ argana_bg.png.jar
│  │  │  │  │                 │  ├─ argana_c_logo.png.jar
│  │  │  │  │                 │  ├─ argana_title.png.jar
│  │  │  │  │                 │  └─ pdf_logo_argana.png.jar
│  │  │  │  │                 ├─ FontManifest.json.jar
│  │  │  │  │                 ├─ fonts
│  │  │  │  │                 │  └─ MaterialIcons-Regular.otf.jar
│  │  │  │  │                 ├─ isolate_snapshot_data.jar
│  │  │  │  │                 ├─ kernel_blob.bin.jar
│  │  │  │  │                 ├─ NativeAssetsManifest.json.jar
│  │  │  │  │                 ├─ NOTICES.Z.jar
│  │  │  │  │                 ├─ packages
│  │  │  │  │                 │  └─ cupertino_icons
│  │  │  │  │                 │     └─ assets
│  │  │  │  │                 │        └─ CupertinoIcons.ttf.jar
│  │  │  │  │                 ├─ shaders
│  │  │  │  │                 │  ├─ ink_sparkle.frag.jar
│  │  │  │  │                 │  └─ stretch_effect.frag.jar
│  │  │  │  │                 └─ vm_snapshot_data.jar
│  │  │  │  ├─ cxx
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ 1b5d5f40
│  │  │  │  │        ├─ logs
│  │  │  │  │        │  ├─ arm64-v8a
│  │  │  │  │        │  │  ├─ build_model.json
│  │  │  │  │        │  │  ├─ configure_command.bat
│  │  │  │  │        │  │  ├─ configure_stderr.txt
│  │  │  │  │        │  │  ├─ configure_stdout.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1066_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1106_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1193_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1226_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_210_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_301_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_318_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_429_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_445_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_536_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_567_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_570_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_690_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_697_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_733_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_78_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_80_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_822_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_860_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_937_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_975_timing.txt
│  │  │  │  │        │  │  └─ metadata_generation_record.json
│  │  │  │  │        │  ├─ armeabi-v7a
│  │  │  │  │        │  │  ├─ build_model.json
│  │  │  │  │        │  │  ├─ configure_command.bat
│  │  │  │  │        │  │  ├─ configure_stderr.txt
│  │  │  │  │        │  │  ├─ configure_stdout.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1066_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1103_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1193_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1231_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_210_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_301_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_318_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_425_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_445_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_535_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_567_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_570_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_693_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_733_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_78_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_80_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_822_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_858_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_937_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_975_timing.txt
│  │  │  │  │        │  │  └─ metadata_generation_record.json
│  │  │  │  │        │  └─ x86_64
│  │  │  │  │        │     ├─ build_model.json
│  │  │  │  │        │     ├─ configure_command.bat
│  │  │  │  │        │     ├─ configure_stderr.txt
│  │  │  │  │        │     ├─ configure_stdout.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_1063_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_1106_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_1193_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_1231_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_207_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_301_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_318_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_431_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_445_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_536_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_567_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_570_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_692_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_693_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_730_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_78_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_80_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_822_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_858_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_937_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_975_timing.txt
│  │  │  │  │        │     └─ metadata_generation_record.json
│  │  │  │  │        └─ obj
│  │  │  │  │           ├─ arm64-v8a
│  │  │  │  │           ├─ armeabi-v7a
│  │  │  │  │           └─ x86_64
│  │  │  │  ├─ data_binding_layout_info_type_merge
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugResources
│  │  │  │  │        └─ out
│  │  │  │  ├─ data_binding_layout_info_type_package
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  │        └─ out
│  │  │  │  ├─ desugar_graph
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  │           ├─ currentProject
│  │  │  │  │           │  ├─ dirs_bucket_0
│  │  │  │  │           │  │  └─ graph.bin
│  │  │  │  │           │  ├─ dirs_bucket_1
│  │  │  │  │           │  │  └─ graph.bin
│  │  │  │  │           │  ├─ dirs_bucket_2
│  │  │  │  │           │  │  └─ graph.bin
│  │  │  │  │           │  ├─ dirs_bucket_3
│  │  │  │  │           │  │  └─ graph.bin
│  │  │  │  │           │  ├─ jar_353f6681014d6cf710313ddc63f143bc14b05fd2d2e7d7df7b2e176508edc53c_bucket_0
│  │  │  │  │           │  │  └─ graph.bin
│  │  │  │  │           │  ├─ jar_353f6681014d6cf710313ddc63f143bc14b05fd2d2e7d7df7b2e176508edc53c_bucket_1
│  │  │  │  │           │  │  └─ graph.bin
│  │  │  │  │           │  ├─ jar_353f6681014d6cf710313ddc63f143bc14b05fd2d2e7d7df7b2e176508edc53c_bucket_2
│  │  │  │  │           │  │  └─ graph.bin
│  │  │  │  │           │  └─ jar_353f6681014d6cf710313ddc63f143bc14b05fd2d2e7d7df7b2e176508edc53c_bucket_3
│  │  │  │  │           │     └─ graph.bin
│  │  │  │  │           ├─ externalLibs
│  │  │  │  │           ├─ mixedScopes
│  │  │  │  │           └─ otherProjects
│  │  │  │  ├─ dex
│  │  │  │  │  └─ debug
│  │  │  │  │     ├─ mergeExtDexDebug
│  │  │  │  │     │  └─ classes.dex
│  │  │  │  │     ├─ mergeLibDexDebug
│  │  │  │  │     │  ├─ 0
│  │  │  │  │     │  ├─ 1
│  │  │  │  │     │  │  └─ classes.dex
│  │  │  │  │     │  ├─ 10
│  │  │  │  │     │  ├─ 11
│  │  │  │  │     │  ├─ 12
│  │  │  │  │     │  ├─ 13
│  │  │  │  │     │  ├─ 14
│  │  │  │  │     │  ├─ 15
│  │  │  │  │     │  ├─ 2
│  │  │  │  │     │  │  └─ classes.dex
│  │  │  │  │     │  ├─ 3
│  │  │  │  │     │  ├─ 4
│  │  │  │  │     │  │  └─ classes.dex
│  │  │  │  │     │  ├─ 5
│  │  │  │  │     │  ├─ 6
│  │  │  │  │     │  │  └─ classes.dex
│  │  │  │  │     │  ├─ 7
│  │  │  │  │     │  ├─ 8
│  │  │  │  │     │  └─ 9
│  │  │  │  │     │     └─ classes.dex
│  │  │  │  │     └─ mergeProjectDexDebug
│  │  │  │  │        ├─ 0
│  │  │  │  │        │  └─ classes.dex
│  │  │  │  │        ├─ 1
│  │  │  │  │        │  └─ classes.dex
│  │  │  │  │        ├─ 10
│  │  │  │  │        ├─ 11
│  │  │  │  │        ├─ 12
│  │  │  │  │        ├─ 13
│  │  │  │  │        ├─ 14
│  │  │  │  │        ├─ 15
│  │  │  │  │        │  └─ classes.dex
│  │  │  │  │        ├─ 2
│  │  │  │  │        ├─ 3
│  │  │  │  │        ├─ 4
│  │  │  │  │        ├─ 5
│  │  │  │  │        ├─ 6
│  │  │  │  │        ├─ 7
│  │  │  │  │        ├─ 8
│  │  │  │  │        └─ 9
│  │  │  │  ├─ dex_archive_input_jar_hashes
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  ├─ dex_number_of_buckets_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  ├─ duplicate_classes_check
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ checkDebugDuplicateClasses
│  │  │  │  ├─ external_file_lib_dex_archives
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ desugarDebugFileDependencies
│  │  │  │  ├─ external_libs_dex_archive
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  ├─ external_libs_dex_archive_with_artifact_transforms
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  ├─ flutter
│  │  │  │  │  └─ debug
│  │  │  │  │     ├─ .last_build_id
│  │  │  │  │     ├─ flutter_assets
│  │  │  │  │     │  ├─ AssetManifest.bin
│  │  │  │  │     │  ├─ assets
│  │  │  │  │     │  │  ├─ argana_bg.png
│  │  │  │  │     │  │  ├─ argana_c_logo.png
│  │  │  │  │     │  │  ├─ argana_title.png
│  │  │  │  │     │  │  └─ pdf_logo_argana.png
│  │  │  │  │     │  ├─ FontManifest.json
│  │  │  │  │     │  ├─ fonts
│  │  │  │  │     │  │  └─ MaterialIcons-Regular.otf
│  │  │  │  │     │  ├─ isolate_snapshot_data
│  │  │  │  │     │  ├─ kernel_blob.bin
│  │  │  │  │     │  ├─ NativeAssetsManifest.json
│  │  │  │  │     │  ├─ NOTICES.Z
│  │  │  │  │     │  ├─ packages
│  │  │  │  │     │  │  └─ cupertino_icons
│  │  │  │  │     │  │     └─ assets
│  │  │  │  │     │  │        └─ CupertinoIcons.ttf
│  │  │  │  │     │  ├─ shaders
│  │  │  │  │     │  │  ├─ ink_sparkle.frag
│  │  │  │  │     │  │  └─ stretch_effect.frag
│  │  │  │  │     │  └─ vm_snapshot_data
│  │  │  │  │     ├─ flutter_build.d
│  │  │  │  │     └─ native_assets
│  │  │  │  ├─ global_synthetics_dex
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugGlobalSynthetics
│  │  │  │  ├─ global_synthetics_external_lib
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  ├─ global_synthetics_external_libs_artifact_transform
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  ├─ global_synthetics_file_lib
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ desugarDebugFileDependencies
│  │  │  │  ├─ global_synthetics_mixed_scope
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  ├─ global_synthetics_project
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  ├─ global_synthetics_subproject
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  ├─ incremental
│  │  │  │  │  ├─ debug
│  │  │  │  │  │  ├─ mergeDebugResources
│  │  │  │  │  │  │  ├─ compile-file-map.properties
│  │  │  │  │  │  │  ├─ merged.dir
│  │  │  │  │  │  │  │  ├─ values
│  │  │  │  │  │  │  │  │  └─ values.xml
│  │  │  │  │  │  │  │  ├─ values-af
│  │  │  │  │  │  │  │  │  └─ values-af.xml
│  │  │  │  │  │  │  │  ├─ values-am
│  │  │  │  │  │  │  │  │  └─ values-am.xml
│  │  │  │  │  │  │  │  ├─ values-ar
│  │  │  │  │  │  │  │  │  └─ values-ar.xml
│  │  │  │  │  │  │  │  ├─ values-as
│  │  │  │  │  │  │  │  │  └─ values-as.xml
│  │  │  │  │  │  │  │  ├─ values-az
│  │  │  │  │  │  │  │  │  └─ values-az.xml
│  │  │  │  │  │  │  │  ├─ values-b+sr+Latn
│  │  │  │  │  │  │  │  │  └─ values-b+sr+Latn.xml
│  │  │  │  │  │  │  │  ├─ values-be
│  │  │  │  │  │  │  │  │  └─ values-be.xml
│  │  │  │  │  │  │  │  ├─ values-bg
│  │  │  │  │  │  │  │  │  └─ values-bg.xml
│  │  │  │  │  │  │  │  ├─ values-bn
│  │  │  │  │  │  │  │  │  └─ values-bn.xml
│  │  │  │  │  │  │  │  ├─ values-bs
│  │  │  │  │  │  │  │  │  └─ values-bs.xml
│  │  │  │  │  │  │  │  ├─ values-ca
│  │  │  │  │  │  │  │  │  └─ values-ca.xml
│  │  │  │  │  │  │  │  ├─ values-cs
│  │  │  │  │  │  │  │  │  └─ values-cs.xml
│  │  │  │  │  │  │  │  ├─ values-da
│  │  │  │  │  │  │  │  │  └─ values-da.xml
│  │  │  │  │  │  │  │  ├─ values-de
│  │  │  │  │  │  │  │  │  └─ values-de.xml
│  │  │  │  │  │  │  │  ├─ values-el
│  │  │  │  │  │  │  │  │  └─ values-el.xml
│  │  │  │  │  │  │  │  ├─ values-en-rAU
│  │  │  │  │  │  │  │  │  └─ values-en-rAU.xml
│  │  │  │  │  │  │  │  ├─ values-en-rCA
│  │  │  │  │  │  │  │  │  └─ values-en-rCA.xml
│  │  │  │  │  │  │  │  ├─ values-en-rGB
│  │  │  │  │  │  │  │  │  └─ values-en-rGB.xml
│  │  │  │  │  │  │  │  ├─ values-en-rIN
│  │  │  │  │  │  │  │  │  └─ values-en-rIN.xml
│  │  │  │  │  │  │  │  ├─ values-en-rXC
│  │  │  │  │  │  │  │  │  └─ values-en-rXC.xml
│  │  │  │  │  │  │  │  ├─ values-es
│  │  │  │  │  │  │  │  │  └─ values-es.xml
│  │  │  │  │  │  │  │  ├─ values-es-rUS
│  │  │  │  │  │  │  │  │  └─ values-es-rUS.xml
│  │  │  │  │  │  │  │  ├─ values-et
│  │  │  │  │  │  │  │  │  └─ values-et.xml
│  │  │  │  │  │  │  │  ├─ values-eu
│  │  │  │  │  │  │  │  │  └─ values-eu.xml
│  │  │  │  │  │  │  │  ├─ values-fa
│  │  │  │  │  │  │  │  │  └─ values-fa.xml
│  │  │  │  │  │  │  │  ├─ values-fi
│  │  │  │  │  │  │  │  │  └─ values-fi.xml
│  │  │  │  │  │  │  │  ├─ values-fr
│  │  │  │  │  │  │  │  │  └─ values-fr.xml
│  │  │  │  │  │  │  │  ├─ values-fr-rCA
│  │  │  │  │  │  │  │  │  └─ values-fr-rCA.xml
│  │  │  │  │  │  │  │  ├─ values-gl
│  │  │  │  │  │  │  │  │  └─ values-gl.xml
│  │  │  │  │  │  │  │  ├─ values-gu
│  │  │  │  │  │  │  │  │  └─ values-gu.xml
│  │  │  │  │  │  │  │  ├─ values-hi
│  │  │  │  │  │  │  │  │  └─ values-hi.xml
│  │  │  │  │  │  │  │  ├─ values-hr
│  │  │  │  │  │  │  │  │  └─ values-hr.xml
│  │  │  │  │  │  │  │  ├─ values-hu
│  │  │  │  │  │  │  │  │  └─ values-hu.xml
│  │  │  │  │  │  │  │  ├─ values-hy
│  │  │  │  │  │  │  │  │  └─ values-hy.xml
│  │  │  │  │  │  │  │  ├─ values-in
│  │  │  │  │  │  │  │  │  └─ values-in.xml
│  │  │  │  │  │  │  │  ├─ values-is
│  │  │  │  │  │  │  │  │  └─ values-is.xml
│  │  │  │  │  │  │  │  ├─ values-it
│  │  │  │  │  │  │  │  │  └─ values-it.xml
│  │  │  │  │  │  │  │  ├─ values-iw
│  │  │  │  │  │  │  │  │  └─ values-iw.xml
│  │  │  │  │  │  │  │  ├─ values-ja
│  │  │  │  │  │  │  │  │  └─ values-ja.xml
│  │  │  │  │  │  │  │  ├─ values-ka
│  │  │  │  │  │  │  │  │  └─ values-ka.xml
│  │  │  │  │  │  │  │  ├─ values-kk
│  │  │  │  │  │  │  │  │  └─ values-kk.xml
│  │  │  │  │  │  │  │  ├─ values-km
│  │  │  │  │  │  │  │  │  └─ values-km.xml
│  │  │  │  │  │  │  │  ├─ values-kn
│  │  │  │  │  │  │  │  │  └─ values-kn.xml
│  │  │  │  │  │  │  │  ├─ values-ko
│  │  │  │  │  │  │  │  │  └─ values-ko.xml
│  │  │  │  │  │  │  │  ├─ values-ky
│  │  │  │  │  │  │  │  │  └─ values-ky.xml
│  │  │  │  │  │  │  │  ├─ values-lo
│  │  │  │  │  │  │  │  │  └─ values-lo.xml
│  │  │  │  │  │  │  │  ├─ values-lt
│  │  │  │  │  │  │  │  │  └─ values-lt.xml
│  │  │  │  │  │  │  │  ├─ values-lv
│  │  │  │  │  │  │  │  │  └─ values-lv.xml
│  │  │  │  │  │  │  │  ├─ values-mk
│  │  │  │  │  │  │  │  │  └─ values-mk.xml
│  │  │  │  │  │  │  │  ├─ values-ml
│  │  │  │  │  │  │  │  │  └─ values-ml.xml
│  │  │  │  │  │  │  │  ├─ values-mn
│  │  │  │  │  │  │  │  │  └─ values-mn.xml
│  │  │  │  │  │  │  │  ├─ values-mr
│  │  │  │  │  │  │  │  │  └─ values-mr.xml
│  │  │  │  │  │  │  │  ├─ values-ms
│  │  │  │  │  │  │  │  │  └─ values-ms.xml
│  │  │  │  │  │  │  │  ├─ values-my
│  │  │  │  │  │  │  │  │  └─ values-my.xml
│  │  │  │  │  │  │  │  ├─ values-nb
│  │  │  │  │  │  │  │  │  └─ values-nb.xml
│  │  │  │  │  │  │  │  ├─ values-ne
│  │  │  │  │  │  │  │  │  └─ values-ne.xml
│  │  │  │  │  │  │  │  ├─ values-night-v31
│  │  │  │  │  │  │  │  │  └─ values-night-v31.xml
│  │  │  │  │  │  │  │  ├─ values-night-v8
│  │  │  │  │  │  │  │  │  └─ values-night-v8.xml
│  │  │  │  │  │  │  │  ├─ values-nl
│  │  │  │  │  │  │  │  │  └─ values-nl.xml
│  │  │  │  │  │  │  │  ├─ values-or
│  │  │  │  │  │  │  │  │  └─ values-or.xml
│  │  │  │  │  │  │  │  ├─ values-pa
│  │  │  │  │  │  │  │  │  └─ values-pa.xml
│  │  │  │  │  │  │  │  ├─ values-pl
│  │  │  │  │  │  │  │  │  └─ values-pl.xml
│  │  │  │  │  │  │  │  ├─ values-pt
│  │  │  │  │  │  │  │  │  └─ values-pt.xml
│  │  │  │  │  │  │  │  ├─ values-pt-rBR
│  │  │  │  │  │  │  │  │  └─ values-pt-rBR.xml
│  │  │  │  │  │  │  │  ├─ values-pt-rPT
│  │  │  │  │  │  │  │  │  └─ values-pt-rPT.xml
│  │  │  │  │  │  │  │  ├─ values-ro
│  │  │  │  │  │  │  │  │  └─ values-ro.xml
│  │  │  │  │  │  │  │  ├─ values-ru
│  │  │  │  │  │  │  │  │  └─ values-ru.xml
│  │  │  │  │  │  │  │  ├─ values-si
│  │  │  │  │  │  │  │  │  └─ values-si.xml
│  │  │  │  │  │  │  │  ├─ values-sk
│  │  │  │  │  │  │  │  │  └─ values-sk.xml
│  │  │  │  │  │  │  │  ├─ values-sl
│  │  │  │  │  │  │  │  │  └─ values-sl.xml
│  │  │  │  │  │  │  │  ├─ values-sq
│  │  │  │  │  │  │  │  │  └─ values-sq.xml
│  │  │  │  │  │  │  │  ├─ values-sr
│  │  │  │  │  │  │  │  │  └─ values-sr.xml
│  │  │  │  │  │  │  │  ├─ values-sv
│  │  │  │  │  │  │  │  │  └─ values-sv.xml
│  │  │  │  │  │  │  │  ├─ values-sw
│  │  │  │  │  │  │  │  │  └─ values-sw.xml
│  │  │  │  │  │  │  │  ├─ values-ta
│  │  │  │  │  │  │  │  │  └─ values-ta.xml
│  │  │  │  │  │  │  │  ├─ values-te
│  │  │  │  │  │  │  │  │  └─ values-te.xml
│  │  │  │  │  │  │  │  ├─ values-th
│  │  │  │  │  │  │  │  │  └─ values-th.xml
│  │  │  │  │  │  │  │  ├─ values-tl
│  │  │  │  │  │  │  │  │  └─ values-tl.xml
│  │  │  │  │  │  │  │  ├─ values-tr
│  │  │  │  │  │  │  │  │  └─ values-tr.xml
│  │  │  │  │  │  │  │  ├─ values-uk
│  │  │  │  │  │  │  │  │  └─ values-uk.xml
│  │  │  │  │  │  │  │  ├─ values-ur
│  │  │  │  │  │  │  │  │  └─ values-ur.xml
│  │  │  │  │  │  │  │  ├─ values-uz
│  │  │  │  │  │  │  │  │  └─ values-uz.xml
│  │  │  │  │  │  │  │  ├─ values-v21
│  │  │  │  │  │  │  │  │  └─ values-v21.xml
│  │  │  │  │  │  │  │  ├─ values-v31
│  │  │  │  │  │  │  │  │  └─ values-v31.xml
│  │  │  │  │  │  │  │  ├─ values-vi
│  │  │  │  │  │  │  │  │  └─ values-vi.xml
│  │  │  │  │  │  │  │  ├─ values-zh-rCN
│  │  │  │  │  │  │  │  │  └─ values-zh-rCN.xml
│  │  │  │  │  │  │  │  ├─ values-zh-rHK
│  │  │  │  │  │  │  │  │  └─ values-zh-rHK.xml
│  │  │  │  │  │  │  │  ├─ values-zh-rTW
│  │  │  │  │  │  │  │  │  └─ values-zh-rTW.xml
│  │  │  │  │  │  │  │  └─ values-zu
│  │  │  │  │  │  │  │     └─ values-zu.xml
│  │  │  │  │  │  │  ├─ merger.xml
│  │  │  │  │  │  │  └─ stripped.dir
│  │  │  │  │  │  └─ packageDebugResources
│  │  │  │  │  │     ├─ compile-file-map.properties
│  │  │  │  │  │     ├─ merged.dir
│  │  │  │  │  │     │  ├─ values
│  │  │  │  │  │     │  │  └─ values.xml
│  │  │  │  │  │     │  ├─ values-night-v31
│  │  │  │  │  │     │  │  └─ values-night-v31.xml
│  │  │  │  │  │     │  ├─ values-night-v8
│  │  │  │  │  │     │  │  └─ values-night-v8.xml
│  │  │  │  │  │     │  └─ values-v31
│  │  │  │  │  │     │     └─ values-v31.xml
│  │  │  │  │  │     ├─ merger.xml
│  │  │  │  │  │     └─ stripped.dir
│  │  │  │  │  ├─ debug-mergeJavaRes
│  │  │  │  │  │  ├─ merge-state
│  │  │  │  │  │  └─ zip-cache
│  │  │  │  │  │     ├─ +ftLUi0wEOMmpBnXkAaLuxNo4vE=
│  │  │  │  │  │     ├─ +PlaNogYUcTQ9mWHIOcP5XywOZQ=
│  │  │  │  │  │     ├─ 1YVuWL8usahiHHoZeWQAYNshloY=
│  │  │  │  │  │     ├─ 3E4nK7blHQOKEBa5vUOh_P1UX0M=
│  │  │  │  │  │     ├─ 3szpJqVFUedbHCQQWJvs9CVfDgk=
│  │  │  │  │  │     ├─ 40HcD0hgSTFbmuZgJk+7VKf9XfM=
│  │  │  │  │  │     ├─ 4JnjT0jsz6E+OkXhHGjEgnZ6_jg=
│  │  │  │  │  │     ├─ 4U+a9Vd6yR9XsZ7QpL1iSaGFU6w=
│  │  │  │  │  │     ├─ 4XZ0Nm77U0Z_XEBPUh9yecrA6_M=
│  │  │  │  │  │     ├─ 6aVVopYj8I8GOPo211P8rBKITXk=
│  │  │  │  │  │     ├─ 6J+8PeEc4jvwCTKfV3fmYMP4MjU=
│  │  │  │  │  │     ├─ 7E+Yh8y0XJ1v+BwPy5CkfdZNxR4=
│  │  │  │  │  │     ├─ 8QqzPOf+FdE7_aapHN28jov+Hsk=
│  │  │  │  │  │     ├─ BryoXcIlZ7wfH4L7bg2GUQXvMWo=
│  │  │  │  │  │     ├─ Ci9OrpzDiZxP1GP0nvgW3ZatpfU=
│  │  │  │  │  │     ├─ co+WppPoEoRO98b9OGXjjjRWbi8=
│  │  │  │  │  │     ├─ CrnTiB3IC4zgyCgAbmW8TvfXYII=
│  │  │  │  │  │     ├─ dEIqlyqLpsDN8DanazJINAhcSSk=
│  │  │  │  │  │     ├─ dPKvdvQ7h7oFg_tDp_Dt3h7QVDo=
│  │  │  │  │  │     ├─ e4PECXJ4Kk95hweBRXuFY_j8oI8=
│  │  │  │  │  │     ├─ E8PNFthBg2bgAbIuLUqa7NY6b_M=
│  │  │  │  │  │     ├─ GCxWknzdwEKCUX0Biyd3LG9rf04=
│  │  │  │  │  │     ├─ GnzyjDs7zjFPzhkOZNh9ugiP6Xs=
│  │  │  │  │  │     ├─ GtbL4S0MmlOsp6b_IBCmylQLhUM=
│  │  │  │  │  │     ├─ k2BysKLUNGhvX3t0+Ti85S8jdCA=
│  │  │  │  │  │     ├─ lAQM1paz3Ngd_UZoveGIJIHFN9E=
│  │  │  │  │  │     ├─ Lmaj5KwAC+Es83VTWlBTbzY3z0s=
│  │  │  │  │  │     ├─ oNxwcSTF8TcFk9Fe3kfILz2hjyw=
│  │  │  │  │  │     ├─ OyfVoVBAjUYFS23FdL3fPYv9sB8=
│  │  │  │  │  │     ├─ qfv1V9vk0KWP8+mktcz+aR7pDP0=
│  │  │  │  │  │     ├─ QNa8BF0mA0ogj7b51EBH3jVeIe4=
│  │  │  │  │  │     ├─ qphIZviqX52hpUcuM0LbNIiSxR4=
│  │  │  │  │  │     ├─ rhPJalMYHjFigAS3OSOn+2BCYLM=
│  │  │  │  │  │     ├─ riilZ8UgHBVDXbHsC4VvypNgte0=
│  │  │  │  │  │     ├─ rReGSfM9BLkj62A11qF09s_sFz0=
│  │  │  │  │  │     ├─ SeUuVhcncSsQFviwx9lm8I6BKXM=
│  │  │  │  │  │     ├─ TN11zREY79VMTxHm20MFbfVh1N4=
│  │  │  │  │  │     ├─ u5Xnds+GSBNOYy8Zc2_5B22vznw=
│  │  │  │  │  │     ├─ uKVDISeYW+NfhkAK49zs0t_0tUk=
│  │  │  │  │  │     ├─ uur_ZRUkTAt5ovMlJq69cbYi6NE=
│  │  │  │  │  │     ├─ vGvmFii5_uk5tJFl9ikdOyy7qls=
│  │  │  │  │  │     ├─ vNjsjKWVqq2u5eRUNl2gYlvSi3Q=
│  │  │  │  │  │     ├─ w9c5EzUAqfKxa0xHZsjdBVcL9hQ=
│  │  │  │  │  │     ├─ wjvm3fWN1OjQ91lUbdG8PqYlfmw=
│  │  │  │  │  │     ├─ W_6CXqteek2DOePW4xJZwRTjOaE=
│  │  │  │  │  │     ├─ X6P5ZGhLevXLIyKnZdPTdnarqTA=
│  │  │  │  │  │     ├─ XxEr6KkpFvFcv3YesPr3p_8T6N8=
│  │  │  │  │  │     ├─ zHnSuPAXPiPIYoX+sgmDKLUMo94=
│  │  │  │  │  │     └─ _GksM6kMbCYdjdybtM8i_RMLSL0=
│  │  │  │  │  ├─ mergeDebugAssets
│  │  │  │  │  │  └─ merger.xml
│  │  │  │  │  ├─ mergeDebugJniLibFolders
│  │  │  │  │  │  └─ merger.xml
│  │  │  │  │  ├─ mergeDebugShaders
│  │  │  │  │  │  └─ merger.xml
│  │  │  │  │  └─ packageDebug
│  │  │  │  │     └─ tmp
│  │  │  │  │        └─ debug
│  │  │  │  │           ├─ dex-renamer-state.txt
│  │  │  │  │           └─ zip-cache
│  │  │  │  │              ├─ androidResources
│  │  │  │  │              └─ javaResources0
│  │  │  │  ├─ javac
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ compileDebugJavaWithJavac
│  │  │  │  │        └─ classes
│  │  │  │  │           └─ io
│  │  │  │  │              └─ flutter
│  │  │  │  │                 └─ plugins
│  │  │  │  │                    └─ GeneratedPluginRegistrant.class
│  │  │  │  ├─ java_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugJavaRes
│  │  │  │  │        └─ out
│  │  │  │  │           ├─ com
│  │  │  │  │           │  └─ example
│  │  │  │  │           │     └─ clinic_app
│  │  │  │  │           └─ META-INF
│  │  │  │  │              └─ app_debug.kotlin_module
│  │  │  │  ├─ linked_resources_binary_format
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugResources
│  │  │  │  │        ├─ linked-resources-binary-format-debug.ap_
│  │  │  │  │        └─ output-metadata.json
│  │  │  │  ├─ local_only_symbol_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ parseDebugLocalResources
│  │  │  │  │        └─ R-def.txt
│  │  │  │  ├─ manifest_merge_blame_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugMainManifest
│  │  │  │  │        └─ manifest-merger-blame-debug-report.txt
│  │  │  │  ├─ merged_java_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugJavaResource
│  │  │  │  │        └─ base.jar
│  │  │  │  ├─ merged_jni_libs
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugJniLibFolders
│  │  │  │  │        └─ out
│  │  │  │  ├─ merged_manifest
│  │  │  │  │  └─ debug
│  │  │  │  │     ├─ outputDebugAppLinkSettings
│  │  │  │  │     │  └─ AndroidManifest.xml
│  │  │  │  │     └─ processDebugMainManifest
│  │  │  │  │        └─ AndroidManifest.xml
│  │  │  │  ├─ merged_manifests
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        ├─ AndroidManifest.xml
│  │  │  │  │        └─ output-metadata.json
│  │  │  │  ├─ merged_native_libs
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugNativeLibs
│  │  │  │  │        └─ out
│  │  │  │  │           └─ lib
│  │  │  │  │              ├─ arm64-v8a
│  │  │  │  │              │  ├─ libdartjni.so
│  │  │  │  │              │  ├─ libflutter.so
│  │  │  │  │              │  └─ libVkLayer_khronos_validation.so
│  │  │  │  │              ├─ armeabi-v7a
│  │  │  │  │              │  └─ libdartjni.so
│  │  │  │  │              ├─ x86
│  │  │  │  │              │  └─ libdartjni.so
│  │  │  │  │              └─ x86_64
│  │  │  │  │                 └─ libdartjni.so
│  │  │  │  ├─ merged_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugResources
│  │  │  │  │        ├─ drawable-hdpi-v31_android12branding.png.flat
│  │  │  │  │        ├─ drawable-hdpi_android12splash.png.flat
│  │  │  │  │        ├─ drawable-hdpi_branding.png.flat
│  │  │  │  │        ├─ drawable-hdpi_splash.png.flat
│  │  │  │  │        ├─ drawable-mdpi-v31_android12branding.png.flat
│  │  │  │  │        ├─ drawable-mdpi_android12splash.png.flat
│  │  │  │  │        ├─ drawable-mdpi_branding.png.flat
│  │  │  │  │        ├─ drawable-mdpi_splash.png.flat
│  │  │  │  │        ├─ drawable-night-hdpi-v31_android12branding.png.flat
│  │  │  │  │        ├─ drawable-night-hdpi_android12splash.png.flat
│  │  │  │  │        ├─ drawable-night-mdpi-v31_android12branding.png.flat
│  │  │  │  │        ├─ drawable-night-mdpi_android12splash.png.flat
│  │  │  │  │        ├─ drawable-night-xhdpi-v31_android12branding.png.flat
│  │  │  │  │        ├─ drawable-night-xhdpi_android12splash.png.flat
│  │  │  │  │        ├─ drawable-night-xxhdpi-v31_android12branding.png.flat
│  │  │  │  │        ├─ drawable-night-xxhdpi_android12splash.png.flat
│  │  │  │  │        ├─ drawable-night-xxxhdpi-v31_android12branding.png.flat
│  │  │  │  │        ├─ drawable-night-xxxhdpi_android12splash.png.flat
│  │  │  │  │        ├─ drawable-v21_background.png.flat
│  │  │  │  │        ├─ drawable-v21_launch_background.xml.flat
│  │  │  │  │        ├─ drawable-xhdpi-v31_android12branding.png.flat
│  │  │  │  │        ├─ drawable-xhdpi_android12splash.png.flat
│  │  │  │  │        ├─ drawable-xhdpi_branding.png.flat
│  │  │  │  │        ├─ drawable-xhdpi_splash.png.flat
│  │  │  │  │        ├─ drawable-xxhdpi-v31_android12branding.png.flat
│  │  │  │  │        ├─ drawable-xxhdpi_android12splash.png.flat
│  │  │  │  │        ├─ drawable-xxhdpi_branding.png.flat
│  │  │  │  │        ├─ drawable-xxhdpi_splash.png.flat
│  │  │  │  │        ├─ drawable-xxxhdpi-v31_android12branding.png.flat
│  │  │  │  │        ├─ drawable-xxxhdpi_android12splash.png.flat
│  │  │  │  │        ├─ drawable-xxxhdpi_branding.png.flat
│  │  │  │  │        ├─ drawable-xxxhdpi_splash.png.flat
│  │  │  │  │        ├─ mipmap-hdpi_ic_launcher.png.flat
│  │  │  │  │        ├─ mipmap-mdpi_ic_launcher.png.flat
│  │  │  │  │        ├─ mipmap-xhdpi_ic_launcher.png.flat
│  │  │  │  │        ├─ mipmap-xxhdpi_ic_launcher.png.flat
│  │  │  │  │        ├─ mipmap-xxxhdpi_ic_launcher.png.flat
│  │  │  │  │        ├─ values-af_values-af.arsc.flat
│  │  │  │  │        ├─ values-am_values-am.arsc.flat
│  │  │  │  │        ├─ values-ar_values-ar.arsc.flat
│  │  │  │  │        ├─ values-as_values-as.arsc.flat
│  │  │  │  │        ├─ values-az_values-az.arsc.flat
│  │  │  │  │        ├─ values-b+sr+Latn_values-b+sr+Latn.arsc.flat
│  │  │  │  │        ├─ values-be_values-be.arsc.flat
│  │  │  │  │        ├─ values-bg_values-bg.arsc.flat
│  │  │  │  │        ├─ values-bn_values-bn.arsc.flat
│  │  │  │  │        ├─ values-bs_values-bs.arsc.flat
│  │  │  │  │        ├─ values-ca_values-ca.arsc.flat
│  │  │  │  │        ├─ values-cs_values-cs.arsc.flat
│  │  │  │  │        ├─ values-da_values-da.arsc.flat
│  │  │  │  │        ├─ values-de_values-de.arsc.flat
│  │  │  │  │        ├─ values-el_values-el.arsc.flat
│  │  │  │  │        ├─ values-en-rAU_values-en-rAU.arsc.flat
│  │  │  │  │        ├─ values-en-rCA_values-en-rCA.arsc.flat
│  │  │  │  │        ├─ values-en-rGB_values-en-rGB.arsc.flat
│  │  │  │  │        ├─ values-en-rIN_values-en-rIN.arsc.flat
│  │  │  │  │        ├─ values-en-rXC_values-en-rXC.arsc.flat
│  │  │  │  │        ├─ values-es-rUS_values-es-rUS.arsc.flat
│  │  │  │  │        ├─ values-es_values-es.arsc.flat
│  │  │  │  │        ├─ values-et_values-et.arsc.flat
│  │  │  │  │        ├─ values-eu_values-eu.arsc.flat
│  │  │  │  │        ├─ values-fa_values-fa.arsc.flat
│  │  │  │  │        ├─ values-fi_values-fi.arsc.flat
│  │  │  │  │        ├─ values-fr-rCA_values-fr-rCA.arsc.flat
│  │  │  │  │        ├─ values-fr_values-fr.arsc.flat
│  │  │  │  │        ├─ values-gl_values-gl.arsc.flat
│  │  │  │  │        ├─ values-gu_values-gu.arsc.flat
│  │  │  │  │        ├─ values-hi_values-hi.arsc.flat
│  │  │  │  │        ├─ values-hr_values-hr.arsc.flat
│  │  │  │  │        ├─ values-hu_values-hu.arsc.flat
│  │  │  │  │        ├─ values-hy_values-hy.arsc.flat
│  │  │  │  │        ├─ values-in_values-in.arsc.flat
│  │  │  │  │        ├─ values-is_values-is.arsc.flat
│  │  │  │  │        ├─ values-it_values-it.arsc.flat
│  │  │  │  │        ├─ values-iw_values-iw.arsc.flat
│  │  │  │  │        ├─ values-ja_values-ja.arsc.flat
│  │  │  │  │        ├─ values-ka_values-ka.arsc.flat
│  │  │  │  │        ├─ values-kk_values-kk.arsc.flat
│  │  │  │  │        ├─ values-km_values-km.arsc.flat
│  │  │  │  │        ├─ values-kn_values-kn.arsc.flat
│  │  │  │  │        ├─ values-ko_values-ko.arsc.flat
│  │  │  │  │        ├─ values-ky_values-ky.arsc.flat
│  │  │  │  │        ├─ values-lo_values-lo.arsc.flat
│  │  │  │  │        ├─ values-lt_values-lt.arsc.flat
│  │  │  │  │        ├─ values-lv_values-lv.arsc.flat
│  │  │  │  │        ├─ values-mk_values-mk.arsc.flat
│  │  │  │  │        ├─ values-ml_values-ml.arsc.flat
│  │  │  │  │        ├─ values-mn_values-mn.arsc.flat
│  │  │  │  │        ├─ values-mr_values-mr.arsc.flat
│  │  │  │  │        ├─ values-ms_values-ms.arsc.flat
│  │  │  │  │        ├─ values-my_values-my.arsc.flat
│  │  │  │  │        ├─ values-nb_values-nb.arsc.flat
│  │  │  │  │        ├─ values-ne_values-ne.arsc.flat
│  │  │  │  │        ├─ values-night-v31_values-night-v31.arsc.flat
│  │  │  │  │        ├─ values-night-v8_values-night-v8.arsc.flat
│  │  │  │  │        ├─ values-nl_values-nl.arsc.flat
│  │  │  │  │        ├─ values-or_values-or.arsc.flat
│  │  │  │  │        ├─ values-pa_values-pa.arsc.flat
│  │  │  │  │        ├─ values-pl_values-pl.arsc.flat
│  │  │  │  │        ├─ values-pt-rBR_values-pt-rBR.arsc.flat
│  │  │  │  │        ├─ values-pt-rPT_values-pt-rPT.arsc.flat
│  │  │  │  │        ├─ values-pt_values-pt.arsc.flat
│  │  │  │  │        ├─ values-ro_values-ro.arsc.flat
│  │  │  │  │        ├─ values-ru_values-ru.arsc.flat
│  │  │  │  │        ├─ values-si_values-si.arsc.flat
│  │  │  │  │        ├─ values-sk_values-sk.arsc.flat
│  │  │  │  │        ├─ values-sl_values-sl.arsc.flat
│  │  │  │  │        ├─ values-sq_values-sq.arsc.flat
│  │  │  │  │        ├─ values-sr_values-sr.arsc.flat
│  │  │  │  │        ├─ values-sv_values-sv.arsc.flat
│  │  │  │  │        ├─ values-sw_values-sw.arsc.flat
│  │  │  │  │        ├─ values-ta_values-ta.arsc.flat
│  │  │  │  │        ├─ values-te_values-te.arsc.flat
│  │  │  │  │        ├─ values-th_values-th.arsc.flat
│  │  │  │  │        ├─ values-tl_values-tl.arsc.flat
│  │  │  │  │        ├─ values-tr_values-tr.arsc.flat
│  │  │  │  │        ├─ values-uk_values-uk.arsc.flat
│  │  │  │  │        ├─ values-ur_values-ur.arsc.flat
│  │  │  │  │        ├─ values-uz_values-uz.arsc.flat
│  │  │  │  │        ├─ values-v21_values-v21.arsc.flat
│  │  │  │  │        ├─ values-v31_values-v31.arsc.flat
│  │  │  │  │        ├─ values-vi_values-vi.arsc.flat
│  │  │  │  │        ├─ values-zh-rCN_values-zh-rCN.arsc.flat
│  │  │  │  │        ├─ values-zh-rHK_values-zh-rHK.arsc.flat
│  │  │  │  │        ├─ values-zh-rTW_values-zh-rTW.arsc.flat
│  │  │  │  │        ├─ values-zu_values-zu.arsc.flat
│  │  │  │  │        └─ values_values.arsc.flat
│  │  │  │  ├─ merged_res_blame_folder
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugResources
│  │  │  │  │        └─ out
│  │  │  │  │           ├─ multi-v2
│  │  │  │  │           │  ├─ mergeDebugResources.json
│  │  │  │  │           │  ├─ values-af.json
│  │  │  │  │           │  ├─ values-am.json
│  │  │  │  │           │  ├─ values-ar.json
│  │  │  │  │           │  ├─ values-as.json
│  │  │  │  │           │  ├─ values-az.json
│  │  │  │  │           │  ├─ values-b+sr+Latn.json
│  │  │  │  │           │  ├─ values-be.json
│  │  │  │  │           │  ├─ values-bg.json
│  │  │  │  │           │  ├─ values-bn.json
│  │  │  │  │           │  ├─ values-bs.json
│  │  │  │  │           │  ├─ values-ca.json
│  │  │  │  │           │  ├─ values-cs.json
│  │  │  │  │           │  ├─ values-da.json
│  │  │  │  │           │  ├─ values-de.json
│  │  │  │  │           │  ├─ values-el.json
│  │  │  │  │           │  ├─ values-en-rAU.json
│  │  │  │  │           │  ├─ values-en-rCA.json
│  │  │  │  │           │  ├─ values-en-rGB.json
│  │  │  │  │           │  ├─ values-en-rIN.json
│  │  │  │  │           │  ├─ values-en-rXC.json
│  │  │  │  │           │  ├─ values-es-rUS.json
│  │  │  │  │           │  ├─ values-es.json
│  │  │  │  │           │  ├─ values-et.json
│  │  │  │  │           │  ├─ values-eu.json
│  │  │  │  │           │  ├─ values-fa.json
│  │  │  │  │           │  ├─ values-fi.json
│  │  │  │  │           │  ├─ values-fr-rCA.json
│  │  │  │  │           │  ├─ values-fr.json
│  │  │  │  │           │  ├─ values-gl.json
│  │  │  │  │           │  ├─ values-gu.json
│  │  │  │  │           │  ├─ values-hi.json
│  │  │  │  │           │  ├─ values-hr.json
│  │  │  │  │           │  ├─ values-hu.json
│  │  │  │  │           │  ├─ values-hy.json
│  │  │  │  │           │  ├─ values-in.json
│  │  │  │  │           │  ├─ values-is.json
│  │  │  │  │           │  ├─ values-it.json
│  │  │  │  │           │  ├─ values-iw.json
│  │  │  │  │           │  ├─ values-ja.json
│  │  │  │  │           │  ├─ values-ka.json
│  │  │  │  │           │  ├─ values-kk.json
│  │  │  │  │           │  ├─ values-km.json
│  │  │  │  │           │  ├─ values-kn.json
│  │  │  │  │           │  ├─ values-ko.json
│  │  │  │  │           │  ├─ values-ky.json
│  │  │  │  │           │  ├─ values-lo.json
│  │  │  │  │           │  ├─ values-lt.json
│  │  │  │  │           │  ├─ values-lv.json
│  │  │  │  │           │  ├─ values-mk.json
│  │  │  │  │           │  ├─ values-ml.json
│  │  │  │  │           │  ├─ values-mn.json
│  │  │  │  │           │  ├─ values-mr.json
│  │  │  │  │           │  ├─ values-ms.json
│  │  │  │  │           │  ├─ values-my.json
│  │  │  │  │           │  ├─ values-nb.json
│  │  │  │  │           │  ├─ values-ne.json
│  │  │  │  │           │  ├─ values-night-v31.json
│  │  │  │  │           │  ├─ values-night-v8.json
│  │  │  │  │           │  ├─ values-nl.json
│  │  │  │  │           │  ├─ values-or.json
│  │  │  │  │           │  ├─ values-pa.json
│  │  │  │  │           │  ├─ values-pl.json
│  │  │  │  │           │  ├─ values-pt-rBR.json
│  │  │  │  │           │  ├─ values-pt-rPT.json
│  │  │  │  │           │  ├─ values-pt.json
│  │  │  │  │           │  ├─ values-ro.json
│  │  │  │  │           │  ├─ values-ru.json
│  │  │  │  │           │  ├─ values-si.json
│  │  │  │  │           │  ├─ values-sk.json
│  │  │  │  │           │  ├─ values-sl.json
│  │  │  │  │           │  ├─ values-sq.json
│  │  │  │  │           │  ├─ values-sr.json
│  │  │  │  │           │  ├─ values-sv.json
│  │  │  │  │           │  ├─ values-sw.json
│  │  │  │  │           │  ├─ values-ta.json
│  │  │  │  │           │  ├─ values-te.json
│  │  │  │  │           │  ├─ values-th.json
│  │  │  │  │           │  ├─ values-tl.json
│  │  │  │  │           │  ├─ values-tr.json
│  │  │  │  │           │  ├─ values-uk.json
│  │  │  │  │           │  ├─ values-ur.json
│  │  │  │  │           │  ├─ values-uz.json
│  │  │  │  │           │  ├─ values-v21.json
│  │  │  │  │           │  ├─ values-v31.json
│  │  │  │  │           │  ├─ values-vi.json
│  │  │  │  │           │  ├─ values-zh-rCN.json
│  │  │  │  │           │  ├─ values-zh-rHK.json
│  │  │  │  │           │  ├─ values-zh-rTW.json
│  │  │  │  │           │  ├─ values-zu.json
│  │  │  │  │           │  └─ values.json
│  │  │  │  │           └─ single
│  │  │  │  │              └─ mergeDebugResources.json
│  │  │  │  ├─ merged_shaders
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugShaders
│  │  │  │  │        └─ out
│  │  │  │  ├─ merged_test_only_native_libs
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugNativeLibs
│  │  │  │  │        └─ out
│  │  │  │  ├─ mixed_scope_dex_archive
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  ├─ navigation_json
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDeepLinksDebug
│  │  │  │  │        └─ navigation.json
│  │  │  │  ├─ nested_resources_validation_report
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugResources
│  │  │  │  │        └─ nestedResourcesValidationReport.txt
│  │  │  │  ├─ packaged_manifests
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifestForPackage
│  │  │  │  │        ├─ AndroidManifest.xml
│  │  │  │  │        └─ output-metadata.json
│  │  │  │  ├─ packaged_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  │        ├─ drawable-hdpi-v31
│  │  │  │  │        │  └─ android12branding.png
│  │  │  │  │        ├─ drawable-hdpi-v4
│  │  │  │  │        │  ├─ android12splash.png
│  │  │  │  │        │  ├─ branding.png
│  │  │  │  │        │  └─ splash.png
│  │  │  │  │        ├─ drawable-mdpi-v31
│  │  │  │  │        │  └─ android12branding.png
│  │  │  │  │        ├─ drawable-mdpi-v4
│  │  │  │  │        │  ├─ android12splash.png
│  │  │  │  │        │  ├─ branding.png
│  │  │  │  │        │  └─ splash.png
│  │  │  │  │        ├─ drawable-night-hdpi-v31
│  │  │  │  │        │  └─ android12branding.png
│  │  │  │  │        ├─ drawable-night-hdpi-v8
│  │  │  │  │        │  └─ android12splash.png
│  │  │  │  │        ├─ drawable-night-mdpi-v31
│  │  │  │  │        │  └─ android12branding.png
│  │  │  │  │        ├─ drawable-night-mdpi-v8
│  │  │  │  │        │  └─ android12splash.png
│  │  │  │  │        ├─ drawable-night-xhdpi-v31
│  │  │  │  │        │  └─ android12branding.png
│  │  │  │  │        ├─ drawable-night-xhdpi-v8
│  │  │  │  │        │  └─ android12splash.png
│  │  │  │  │        ├─ drawable-night-xxhdpi-v31
│  │  │  │  │        │  └─ android12branding.png
│  │  │  │  │        ├─ drawable-night-xxhdpi-v8
│  │  │  │  │        │  └─ android12splash.png
│  │  │  │  │        ├─ drawable-night-xxxhdpi-v31
│  │  │  │  │        │  └─ android12branding.png
│  │  │  │  │        ├─ drawable-night-xxxhdpi-v8
│  │  │  │  │        │  └─ android12splash.png
│  │  │  │  │        ├─ drawable-v21
│  │  │  │  │        │  ├─ background.png
│  │  │  │  │        │  └─ launch_background.xml
│  │  │  │  │        ├─ drawable-xhdpi-v31
│  │  │  │  │        │  └─ android12branding.png
│  │  │  │  │        ├─ drawable-xhdpi-v4
│  │  │  │  │        │  ├─ android12splash.png
│  │  │  │  │        │  ├─ branding.png
│  │  │  │  │        │  └─ splash.png
│  │  │  │  │        ├─ drawable-xxhdpi-v31
│  │  │  │  │        │  └─ android12branding.png
│  │  │  │  │        ├─ drawable-xxhdpi-v4
│  │  │  │  │        │  ├─ android12splash.png
│  │  │  │  │        │  ├─ branding.png
│  │  │  │  │        │  └─ splash.png
│  │  │  │  │        ├─ drawable-xxxhdpi-v31
│  │  │  │  │        │  └─ android12branding.png
│  │  │  │  │        ├─ drawable-xxxhdpi-v4
│  │  │  │  │        │  ├─ android12splash.png
│  │  │  │  │        │  ├─ branding.png
│  │  │  │  │        │  └─ splash.png
│  │  │  │  │        ├─ mipmap-hdpi-v4
│  │  │  │  │        │  └─ ic_launcher.png
│  │  │  │  │        ├─ mipmap-mdpi-v4
│  │  │  │  │        │  └─ ic_launcher.png
│  │  │  │  │        ├─ mipmap-xhdpi-v4
│  │  │  │  │        │  └─ ic_launcher.png
│  │  │  │  │        ├─ mipmap-xxhdpi-v4
│  │  │  │  │        │  └─ ic_launcher.png
│  │  │  │  │        ├─ mipmap-xxxhdpi-v4
│  │  │  │  │        │  └─ ic_launcher.png
│  │  │  │  │        ├─ values
│  │  │  │  │        │  └─ values.xml
│  │  │  │  │        ├─ values-night-v31
│  │  │  │  │        │  └─ values-night-v31.xml
│  │  │  │  │        ├─ values-night-v8
│  │  │  │  │        │  └─ values-night-v8.xml
│  │  │  │  │        └─ values-v31
│  │  │  │  │           └─ values-v31.xml
│  │  │  │  ├─ project_dex_archive
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  │           ├─ 44dc382b93a96054578563f2644f11752d4222a8432f9669f94770167a966f29_0.jar
│  │  │  │  │           ├─ 44dc382b93a96054578563f2644f11752d4222a8432f9669f94770167a966f29_1.jar
│  │  │  │  │           ├─ 44dc382b93a96054578563f2644f11752d4222a8432f9669f94770167a966f29_2.jar
│  │  │  │  │           ├─ 44dc382b93a96054578563f2644f11752d4222a8432f9669f94770167a966f29_3.jar
│  │  │  │  │           ├─ com
│  │  │  │  │           │  └─ example
│  │  │  │  │           │     └─ clinic_app
│  │  │  │  │           │        └─ MainActivity.dex
│  │  │  │  │           └─ io
│  │  │  │  │              └─ flutter
│  │  │  │  │                 └─ plugins
│  │  │  │  │                    └─ GeneratedPluginRegistrant.dex
│  │  │  │  ├─ runtime_symbol_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugResources
│  │  │  │  │        └─ R.txt
│  │  │  │  ├─ signing_config_versions
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ writeDebugSigningConfigVersions
│  │  │  │  │        └─ signing-config-versions.json
│  │  │  │  ├─ source_set_path_map
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mapDebugSourceSetPaths
│  │  │  │  │        └─ file-map.txt
│  │  │  │  ├─ stable_resource_ids_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugResources
│  │  │  │  │        └─ stableIds.txt
│  │  │  │  ├─ stripped_native_libs
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ stripDebugDebugSymbols
│  │  │  │  │        └─ out
│  │  │  │  │           └─ lib
│  │  │  │  │              ├─ arm64-v8a
│  │  │  │  │              │  ├─ libdartjni.so
│  │  │  │  │              │  ├─ libflutter.so
│  │  │  │  │              │  └─ libVkLayer_khronos_validation.so
│  │  │  │  │              ├─ armeabi-v7a
│  │  │  │  │              │  └─ libdartjni.so
│  │  │  │  │              ├─ x86
│  │  │  │  │              │  └─ libdartjni.so
│  │  │  │  │              └─ x86_64
│  │  │  │  │                 └─ libdartjni.so
│  │  │  │  ├─ sub_project_dex_archive
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ dexBuilderDebug
│  │  │  │  │        └─ out
│  │  │  │  ├─ symbol_list_with_package_name
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugResources
│  │  │  │  │        └─ package-aware-r.txt
│  │  │  │  └─ validate_signing_config
│  │  │  │     └─ debug
│  │  │  │        └─ validateSigningDebug
│  │  │  ├─ kotlin
│  │  │  │  └─ compileDebugKotlin
│  │  │  │     ├─ cacheable
│  │  │  │     │  ├─ caches-jvm
│  │  │  │     │  │  ├─ inputs
│  │  │  │     │  │  │  ├─ source-to-output.tab
│  │  │  │     │  │  │  ├─ source-to-output.tab.keystream
│  │  │  │     │  │  │  ├─ source-to-output.tab.keystream.len
│  │  │  │     │  │  │  ├─ source-to-output.tab.len
│  │  │  │     │  │  │  ├─ source-to-output.tab.values.at
│  │  │  │     │  │  │  ├─ source-to-output.tab_i
│  │  │  │     │  │  │  └─ source-to-output.tab_i.len
│  │  │  │     │  │  ├─ jvm
│  │  │  │     │  │  │  └─ kotlin
│  │  │  │     │  │  │     ├─ class-attributes.tab
│  │  │  │     │  │  │     ├─ class-attributes.tab.keystream
│  │  │  │     │  │  │     ├─ class-attributes.tab.keystream.len
│  │  │  │     │  │  │     ├─ class-attributes.tab.len
│  │  │  │     │  │  │     ├─ class-attributes.tab.values.at
│  │  │  │     │  │  │     ├─ class-attributes.tab_i
│  │  │  │     │  │  │     ├─ class-attributes.tab_i.len
│  │  │  │     │  │  │     ├─ class-fq-name-to-source.tab
│  │  │  │     │  │  │     ├─ class-fq-name-to-source.tab.keystream
│  │  │  │     │  │  │     ├─ class-fq-name-to-source.tab.keystream.len
│  │  │  │     │  │  │     ├─ class-fq-name-to-source.tab.len
│  │  │  │     │  │  │     ├─ class-fq-name-to-source.tab.values.at
│  │  │  │     │  │  │     ├─ class-fq-name-to-source.tab_i
│  │  │  │     │  │  │     ├─ class-fq-name-to-source.tab_i.len
│  │  │  │     │  │  │     ├─ internal-name-to-source.tab
│  │  │  │     │  │  │     ├─ internal-name-to-source.tab.keystream
│  │  │  │     │  │  │     ├─ internal-name-to-source.tab.keystream.len
│  │  │  │     │  │  │     ├─ internal-name-to-source.tab.len
│  │  │  │     │  │  │     ├─ internal-name-to-source.tab.values.at
│  │  │  │     │  │  │     ├─ internal-name-to-source.tab_i
│  │  │  │     │  │  │     ├─ internal-name-to-source.tab_i.len
│  │  │  │     │  │  │     ├─ proto.tab
│  │  │  │     │  │  │     ├─ proto.tab.keystream
│  │  │  │     │  │  │     ├─ proto.tab.keystream.len
│  │  │  │     │  │  │     ├─ proto.tab.len
│  │  │  │     │  │  │     ├─ proto.tab.values.at
│  │  │  │     │  │  │     ├─ proto.tab_i
│  │  │  │     │  │  │     ├─ proto.tab_i.len
│  │  │  │     │  │  │     ├─ source-to-classes.tab
│  │  │  │     │  │  │     ├─ source-to-classes.tab.keystream
│  │  │  │     │  │  │     ├─ source-to-classes.tab.keystream.len
│  │  │  │     │  │  │     ├─ source-to-classes.tab.len
│  │  │  │     │  │  │     ├─ source-to-classes.tab.values.at
│  │  │  │     │  │  │     ├─ source-to-classes.tab_i
│  │  │  │     │  │  │     ├─ source-to-classes.tab_i.len
│  │  │  │     │  │  │     ├─ subtypes.tab
│  │  │  │     │  │  │     ├─ subtypes.tab.keystream
│  │  │  │     │  │  │     ├─ subtypes.tab.keystream.len
│  │  │  │     │  │  │     ├─ subtypes.tab.len
│  │  │  │     │  │  │     ├─ subtypes.tab.values.at
│  │  │  │     │  │  │     ├─ subtypes.tab_i
│  │  │  │     │  │  │     ├─ subtypes.tab_i.len
│  │  │  │     │  │  │     ├─ supertypes.tab
│  │  │  │     │  │  │     ├─ supertypes.tab.keystream
│  │  │  │     │  │  │     ├─ supertypes.tab.keystream.len
│  │  │  │     │  │  │     ├─ supertypes.tab.len
│  │  │  │     │  │  │     ├─ supertypes.tab.values.at
│  │  │  │     │  │  │     ├─ supertypes.tab_i
│  │  │  │     │  │  │     └─ supertypes.tab_i.len
│  │  │  │     │  │  └─ lookups
│  │  │  │     │  │     ├─ counters.tab
│  │  │  │     │  │     ├─ file-to-id.tab
│  │  │  │     │  │     ├─ file-to-id.tab.keystream
│  │  │  │     │  │     ├─ file-to-id.tab.keystream.len
│  │  │  │     │  │     ├─ file-to-id.tab.len
│  │  │  │     │  │     ├─ file-to-id.tab.values.at
│  │  │  │     │  │     ├─ file-to-id.tab_i
│  │  │  │     │  │     ├─ file-to-id.tab_i.len
│  │  │  │     │  │     ├─ id-to-file.tab
│  │  │  │     │  │     ├─ id-to-file.tab.keystream
│  │  │  │     │  │     ├─ id-to-file.tab.keystream.len
│  │  │  │     │  │     ├─ id-to-file.tab.len
│  │  │  │     │  │     ├─ id-to-file.tab.values.at
│  │  │  │     │  │     ├─ id-to-file.tab_i.len
│  │  │  │     │  │     ├─ lookups.tab
│  │  │  │     │  │     ├─ lookups.tab.keystream
│  │  │  │     │  │     ├─ lookups.tab.keystream.len
│  │  │  │     │  │     ├─ lookups.tab.len
│  │  │  │     │  │     ├─ lookups.tab.values.at
│  │  │  │     │  │     ├─ lookups.tab_i
│  │  │  │     │  │     └─ lookups.tab_i.len
│  │  │  │     │  └─ last-build.bin
│  │  │  │     ├─ classpath-snapshot
│  │  │  │     │  └─ shrunk-classpath-snapshot.bin
│  │  │  │     └─ local-state
│  │  │  ├─ outputs
│  │  │  │  ├─ apk
│  │  │  │  │  └─ debug
│  │  │  │  │     ├─ app-debug.apk
│  │  │  │  │     └─ output-metadata.json
│  │  │  │  ├─ flutter-apk
│  │  │  │  │  ├─ app-debug.apk
│  │  │  │  │  └─ app-debug.apk.sha1
│  │  │  │  └─ logs
│  │  │  │     └─ manifest-merger-debug-report.txt
│  │  │  └─ tmp
│  │  │     ├─ compileDebugJavaWithJavac
│  │  │     │  └─ previous-compilation-data.bin
│  │  │     └─ kotlin-classes
│  │  │        └─ debug
│  │  │           ├─ com
│  │  │           │  └─ example
│  │  │           │     └─ clinic_app
│  │  │           │        └─ MainActivity.class
│  │  │           └─ META-INF
│  │  │              └─ app_debug.kotlin_module
│  │  ├─ f14b93b0ae77892963cdb91113993314
│  │  │  ├─ gen_dart_plugin_registrant.stamp
│  │  │  ├─ gen_l10n_inputs_and_outputs.json
│  │  │  ├─ gen_localizations.d
│  │  │  ├─ gen_localizations.stamp
│  │  │  └─ _composite.stamp
│  │  ├─ flutter_assets
│  │  │  ├─ AssetManifest.bin
│  │  │  ├─ AssetManifest.bin.json
│  │  │  ├─ assets
│  │  │  │  ├─ argana_bg.png
│  │  │  │  ├─ argana_c_logo.png
│  │  │  │  ├─ argana_title.png
│  │  │  │  └─ pdf_logo_argana.png
│  │  │  ├─ FontManifest.json
│  │  │  ├─ fonts
│  │  │  │  └─ MaterialIcons-Regular.otf
│  │  │  ├─ NOTICES
│  │  │  ├─ packages
│  │  │  │  └─ cupertino_icons
│  │  │  │     └─ assets
│  │  │  │        └─ CupertinoIcons.ttf
│  │  │  └─ shaders
│  │  │     ├─ ink_sparkle.frag
│  │  │     └─ stretch_effect.frag
│  │  ├─ flutter_secure_storage
│  │  │  ├─ .transforms
│  │  │  │  ├─ 80cd7f5fd410631e0e8580dbcd693833
│  │  │  │  │  ├─ results.bin
│  │  │  │  │  └─ transformed
│  │  │  │  │     └─ bundleLibRuntimeToDirDebug
│  │  │  │  │        ├─ bundleLibRuntimeToDirDebug_dex
│  │  │  │  │        │  └─ com
│  │  │  │  │        │     └─ it_nomads
│  │  │  │  │        │        └─ fluttersecurestorage
│  │  │  │  │        │           ├─ BuildConfig.dex
│  │  │  │  │        │           ├─ ciphers
│  │  │  │  │        │           │  ├─ KeyCipher.dex
│  │  │  │  │        │           │  ├─ KeyCipherAlgorithm.dex
│  │  │  │  │        │           │  ├─ KeyCipherFunction.dex
│  │  │  │  │        │           │  ├─ RSACipher18Implementation.dex
│  │  │  │  │        │           │  ├─ RSACipherOAEPImplementation.dex
│  │  │  │  │        │           │  ├─ StorageCipher.dex
│  │  │  │  │        │           │  ├─ StorageCipher18Implementation.dex
│  │  │  │  │        │           │  ├─ StorageCipherAlgorithm.dex
│  │  │  │  │        │           │  ├─ StorageCipherFactory.dex
│  │  │  │  │        │           │  ├─ StorageCipherFunction.dex
│  │  │  │  │        │           │  └─ StorageCipherGCMImplementation.dex
│  │  │  │  │        │           ├─ FlutterSecureStorage.dex
│  │  │  │  │        │           ├─ FlutterSecureStoragePlugin$MethodResultWrapper.dex
│  │  │  │  │        │           ├─ FlutterSecureStoragePlugin$MethodRunner.dex
│  │  │  │  │        │           └─ FlutterSecureStoragePlugin.dex
│  │  │  │  │        ├─ bundleLibRuntimeToDirDebug_global-synthetics
│  │  │  │  │        └─ desugar_graph.bin
│  │  │  │  └─ e2b8e3304311b9f8e56c192c002743d2
│  │  │  │     ├─ results.bin
│  │  │  │     └─ transformed
│  │  │  │        └─ classes
│  │  │  │           ├─ classes_dex
│  │  │  │           │  └─ classes.dex
│  │  │  │           └─ classes_global-synthetics
│  │  │  ├─ generated
│  │  │  │  ├─ ap_generated_sources
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ out
│  │  │  │  ├─ res
│  │  │  │  │  ├─ pngs
│  │  │  │  │  │  └─ debug
│  │  │  │  │  └─ resValues
│  │  │  │  │     └─ debug
│  │  │  │  └─ source
│  │  │  │     └─ buildConfig
│  │  │  │        └─ debug
│  │  │  │           └─ com
│  │  │  │              └─ it_nomads
│  │  │  │                 └─ fluttersecurestorage
│  │  │  │                    └─ BuildConfig.java
│  │  │  ├─ intermediates
│  │  │  │  ├─ aapt_friendly_merged_manifests
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        └─ aapt
│  │  │  │  │           ├─ AndroidManifest.xml
│  │  │  │  │           └─ output-metadata.json
│  │  │  │  ├─ aar_libs_directory
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ syncDebugLibJars
│  │  │  │  │        └─ libs
│  │  │  │  ├─ aar_main_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ syncDebugLibJars
│  │  │  │  │        └─ classes.jar
│  │  │  │  ├─ aar_metadata
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ writeDebugAarMetadata
│  │  │  │  │        └─ aar-metadata.properties
│  │  │  │  ├─ annotations_typedef_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDebugAnnotations
│  │  │  │  │        └─ typedefs.txt
│  │  │  │  ├─ annotations_zip
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDebugAnnotations
│  │  │  │  ├─ annotation_processor_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ javaPreCompileDebug
│  │  │  │  │        └─ annotationProcessors.json
│  │  │  │  ├─ assets
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugAssets
│  │  │  │  ├─ compiled_local_resources
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ compileDebugLibraryResources
│  │  │  │  │        └─ out
│  │  │  │  ├─ compile_library_classes_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ bundleLibCompileToJarDebug
│  │  │  │  │        └─ classes.jar
│  │  │  │  ├─ compile_r_class_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugRFile
│  │  │  │  │        └─ R.jar
│  │  │  │  ├─ compile_symbol_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugRFile
│  │  │  │  │        └─ R.txt
│  │  │  │  ├─ data_binding_layout_info_type_package
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  │        └─ out
│  │  │  │  ├─ incremental
│  │  │  │  │  ├─ debug
│  │  │  │  │  │  └─ packageDebugResources
│  │  │  │  │  │     ├─ compile-file-map.properties
│  │  │  │  │  │     ├─ merged.dir
│  │  │  │  │  │     ├─ merger.xml
│  │  │  │  │  │     └─ stripped.dir
│  │  │  │  │  ├─ debug-mergeJavaRes
│  │  │  │  │  │  ├─ merge-state
│  │  │  │  │  │  └─ zip-cache
│  │  │  │  │  ├─ mergeDebugAssets
│  │  │  │  │  │  └─ merger.xml
│  │  │  │  │  ├─ mergeDebugJniLibFolders
│  │  │  │  │  │  └─ merger.xml
│  │  │  │  │  └─ mergeDebugShaders
│  │  │  │  │     └─ merger.xml
│  │  │  │  ├─ javac
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ compileDebugJavaWithJavac
│  │  │  │  │        └─ classes
│  │  │  │  │           └─ com
│  │  │  │  │              └─ it_nomads
│  │  │  │  │                 └─ fluttersecurestorage
│  │  │  │  │                    ├─ BuildConfig.class
│  │  │  │  │                    ├─ ciphers
│  │  │  │  │                    │  ├─ KeyCipher.class
│  │  │  │  │                    │  ├─ KeyCipherAlgorithm.class
│  │  │  │  │                    │  ├─ KeyCipherFunction.class
│  │  │  │  │                    │  ├─ RSACipher18Implementation.class
│  │  │  │  │                    │  ├─ RSACipherOAEPImplementation.class
│  │  │  │  │                    │  ├─ StorageCipher.class
│  │  │  │  │                    │  ├─ StorageCipher18Implementation.class
│  │  │  │  │                    │  ├─ StorageCipherAlgorithm.class
│  │  │  │  │                    │  ├─ StorageCipherFactory.class
│  │  │  │  │                    │  ├─ StorageCipherFunction.class
│  │  │  │  │                    │  └─ StorageCipherGCMImplementation.class
│  │  │  │  │                    ├─ FlutterSecureStorage.class
│  │  │  │  │                    ├─ FlutterSecureStoragePlugin$MethodResultWrapper.class
│  │  │  │  │                    ├─ FlutterSecureStoragePlugin$MethodRunner.class
│  │  │  │  │                    └─ FlutterSecureStoragePlugin.class
│  │  │  │  ├─ library_and_local_jars_jni
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ copyDebugJniLibsProjectAndLocalJars
│  │  │  │  │        └─ jni
│  │  │  │  ├─ library_jni
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ copyDebugJniLibsProjectOnly
│  │  │  │  │        └─ jni
│  │  │  │  ├─ local_only_symbol_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ parseDebugLocalResources
│  │  │  │  │        └─ R-def.txt
│  │  │  │  ├─ manifest_merge_blame_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        └─ manifest-merger-blame-debug-report.txt
│  │  │  │  ├─ merged_java_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugJavaResource
│  │  │  │  │        └─ feature-flutter_secure_storage.jar
│  │  │  │  ├─ merged_jni_libs
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugJniLibFolders
│  │  │  │  │        └─ out
│  │  │  │  ├─ merged_manifest
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        └─ AndroidManifest.xml
│  │  │  │  ├─ merged_shaders
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugShaders
│  │  │  │  │        └─ out
│  │  │  │  ├─ navigation_json
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDeepLinksDebug
│  │  │  │  │        └─ navigation.json
│  │  │  │  ├─ nested_resources_validation_report
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugResources
│  │  │  │  │        └─ nestedResourcesValidationReport.txt
│  │  │  │  ├─ packaged_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  ├─ public_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  ├─ runtime_library_classes_dir
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ bundleLibRuntimeToDirDebug
│  │  │  │  │        └─ com
│  │  │  │  │           └─ it_nomads
│  │  │  │  │              └─ fluttersecurestorage
│  │  │  │  │                 ├─ BuildConfig.class
│  │  │  │  │                 ├─ ciphers
│  │  │  │  │                 │  ├─ KeyCipher.class
│  │  │  │  │                 │  ├─ KeyCipherAlgorithm.class
│  │  │  │  │                 │  ├─ KeyCipherFunction.class
│  │  │  │  │                 │  ├─ RSACipher18Implementation.class
│  │  │  │  │                 │  ├─ RSACipherOAEPImplementation.class
│  │  │  │  │                 │  ├─ StorageCipher.class
│  │  │  │  │                 │  ├─ StorageCipher18Implementation.class
│  │  │  │  │                 │  ├─ StorageCipherAlgorithm.class
│  │  │  │  │                 │  ├─ StorageCipherFactory.class
│  │  │  │  │                 │  ├─ StorageCipherFunction.class
│  │  │  │  │                 │  └─ StorageCipherGCMImplementation.class
│  │  │  │  │                 ├─ FlutterSecureStorage.class
│  │  │  │  │                 ├─ FlutterSecureStoragePlugin$MethodResultWrapper.class
│  │  │  │  │                 ├─ FlutterSecureStoragePlugin$MethodRunner.class
│  │  │  │  │                 └─ FlutterSecureStoragePlugin.class
│  │  │  │  ├─ runtime_library_classes_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ bundleLibRuntimeToJarDebug
│  │  │  │  │        └─ classes.jar
│  │  │  │  └─ symbol_list_with_package_name
│  │  │  │     └─ debug
│  │  │  │        └─ generateDebugRFile
│  │  │  │           └─ package-aware-r.txt
│  │  │  ├─ outputs
│  │  │  │  ├─ aar
│  │  │  │  │  └─ flutter_secure_storage-debug.aar
│  │  │  │  └─ logs
│  │  │  │     └─ manifest-merger-debug-report.txt
│  │  │  └─ tmp
│  │  │     └─ compileDebugJavaWithJavac
│  │  │        └─ previous-compilation-data.bin
│  │  ├─ jni
│  │  │  ├─ .transforms
│  │  │  │  ├─ 761ec71183b35525ae58522fc40e19f8
│  │  │  │  │  ├─ results.bin
│  │  │  │  │  └─ transformed
│  │  │  │  │     └─ classes
│  │  │  │  │        ├─ classes_dex
│  │  │  │  │        │  └─ classes.dex
│  │  │  │  │        └─ classes_global-synthetics
│  │  │  │  └─ e3490c33a4d008762cc6b37536faf7aa
│  │  │  │     ├─ results.bin
│  │  │  │     └─ transformed
│  │  │  │        └─ bundleLibRuntimeToDirDebug
│  │  │  │           ├─ bundleLibRuntimeToDirDebug_dex
│  │  │  │           │  └─ com
│  │  │  │           │     └─ github
│  │  │  │           │        └─ dart_lang
│  │  │  │           │           └─ jni
│  │  │  │           │              ├─ JniPlugin.dex
│  │  │  │           │              ├─ JniUtils.dex
│  │  │  │           │              ├─ PortCleaner$PortPhantom.dex
│  │  │  │           │              ├─ PortCleaner.dex
│  │  │  │           │              ├─ PortContinuation.dex
│  │  │  │           │              ├─ PortProxyBuilder$DartException.dex
│  │  │  │           │              ├─ PortProxyBuilder$DartImplementation.dex
│  │  │  │           │              └─ PortProxyBuilder.dex
│  │  │  │           ├─ bundleLibRuntimeToDirDebug_global-synthetics
│  │  │  │           └─ desugar_graph.bin
│  │  │  ├─ generated
│  │  │  │  ├─ ap_generated_sources
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ out
│  │  │  │  └─ res
│  │  │  │     ├─ pngs
│  │  │  │     │  └─ debug
│  │  │  │     └─ resValues
│  │  │  │        └─ debug
│  │  │  ├─ intermediates
│  │  │  │  ├─ aapt_friendly_merged_manifests
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        └─ aapt
│  │  │  │  │           ├─ AndroidManifest.xml
│  │  │  │  │           └─ output-metadata.json
│  │  │  │  ├─ aar_libs_directory
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ syncDebugLibJars
│  │  │  │  │        └─ libs
│  │  │  │  ├─ aar_main_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ syncDebugLibJars
│  │  │  │  │        └─ classes.jar
│  │  │  │  ├─ aar_metadata
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ writeDebugAarMetadata
│  │  │  │  │        └─ aar-metadata.properties
│  │  │  │  ├─ annotations_typedef_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDebugAnnotations
│  │  │  │  │        └─ typedefs.txt
│  │  │  │  ├─ annotations_zip
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDebugAnnotations
│  │  │  │  ├─ annotation_processor_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ javaPreCompileDebug
│  │  │  │  │        └─ annotationProcessors.json
│  │  │  │  ├─ assets
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugAssets
│  │  │  │  ├─ compiled_local_resources
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ compileDebugLibraryResources
│  │  │  │  │        └─ out
│  │  │  │  ├─ compile_library_classes_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ bundleLibCompileToJarDebug
│  │  │  │  │        └─ classes.jar
│  │  │  │  ├─ compile_r_class_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugRFile
│  │  │  │  │        └─ R.jar
│  │  │  │  ├─ compile_symbol_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugRFile
│  │  │  │  │        └─ R.txt
│  │  │  │  ├─ cxx
│  │  │  │  │  └─ Debug
│  │  │  │  │     └─ 3135x4o6
│  │  │  │  │        ├─ logs
│  │  │  │  │        │  ├─ arm64-v8a
│  │  │  │  │        │  │  ├─ build_command_jni.bat
│  │  │  │  │        │  │  ├─ build_model.json
│  │  │  │  │        │  │  ├─ build_stderr_jni.txt
│  │  │  │  │        │  │  ├─ build_stdout_jni.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1068_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1100_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1189_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1233_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_207_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_303_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_318_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_426_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_448_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_533_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_561_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_573_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_692_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_733_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_79_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_80_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_825_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_857_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_936_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_980_timing.txt
│  │  │  │  │        │  │  └─ metadata_generation_record.json
│  │  │  │  │        │  ├─ armeabi-v7a
│  │  │  │  │        │  │  ├─ build_command_jni.bat
│  │  │  │  │        │  │  ├─ build_model.json
│  │  │  │  │        │  │  ├─ build_stderr_jni.txt
│  │  │  │  │        │  │  ├─ build_stdout_jni.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1068_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1106_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1189_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1233_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_207_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_303_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_318_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_426_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_448_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_533_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_561_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_573_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_692_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_693_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_733_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_79_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_80_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_819_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_857_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_936_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_980_timing.txt
│  │  │  │  │        │  │  └─ metadata_generation_record.json
│  │  │  │  │        │  ├─ x86
│  │  │  │  │        │  │  ├─ build_command_jni.bat
│  │  │  │  │        │  │  ├─ build_model.json
│  │  │  │  │        │  │  ├─ build_stderr_jni.txt
│  │  │  │  │        │  │  ├─ build_stdout_jni.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1062_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1106_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1189_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_1233_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_207_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_299_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_318_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_430_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_448_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_533_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_568_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_570_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_692_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_732_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_80_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_819_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_83_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_857_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_936_timing.txt
│  │  │  │  │        │  │  ├─ generate_cxx_metadata_980_timing.txt
│  │  │  │  │        │  │  └─ metadata_generation_record.json
│  │  │  │  │        │  └─ x86_64
│  │  │  │  │        │     ├─ build_command_jni.bat
│  │  │  │  │        │     ├─ build_model.json
│  │  │  │  │        │     ├─ build_stderr_jni.txt
│  │  │  │  │        │     ├─ build_stdout_jni.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_1062_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_1106_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_1189_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_1233_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_207_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_299_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_318_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_426_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_448_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_533_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_568_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_571_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_690_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_693_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_732_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_80_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_819_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_83_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_857_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_936_timing.txt
│  │  │  │  │        │     ├─ generate_cxx_metadata_980_timing.txt
│  │  │  │  │        │     └─ metadata_generation_record.json
│  │  │  │  │        └─ obj
│  │  │  │  │           ├─ arm64-v8a
│  │  │  │  │           │  └─ libdartjni.so
│  │  │  │  │           ├─ armeabi-v7a
│  │  │  │  │           │  └─ libdartjni.so
│  │  │  │  │           ├─ x86
│  │  │  │  │           │  └─ libdartjni.so
│  │  │  │  │           └─ x86_64
│  │  │  │  │              └─ libdartjni.so
│  │  │  │  ├─ data_binding_layout_info_type_package
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  │        └─ out
│  │  │  │  ├─ incremental
│  │  │  │  │  ├─ debug
│  │  │  │  │  │  └─ packageDebugResources
│  │  │  │  │  │     ├─ compile-file-map.properties
│  │  │  │  │  │     ├─ merged.dir
│  │  │  │  │  │     ├─ merger.xml
│  │  │  │  │  │     └─ stripped.dir
│  │  │  │  │  ├─ debug-mergeJavaRes
│  │  │  │  │  │  ├─ merge-state
│  │  │  │  │  │  └─ zip-cache
│  │  │  │  │  ├─ mergeDebugAssets
│  │  │  │  │  │  └─ merger.xml
│  │  │  │  │  ├─ mergeDebugJniLibFolders
│  │  │  │  │  │  └─ merger.xml
│  │  │  │  │  └─ mergeDebugShaders
│  │  │  │  │     └─ merger.xml
│  │  │  │  ├─ javac
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ compileDebugJavaWithJavac
│  │  │  │  │        └─ classes
│  │  │  │  │           └─ com
│  │  │  │  │              └─ github
│  │  │  │  │                 └─ dart_lang
│  │  │  │  │                    └─ jni
│  │  │  │  │                       ├─ JniPlugin.class
│  │  │  │  │                       ├─ JniUtils.class
│  │  │  │  │                       ├─ PortCleaner$PortPhantom.class
│  │  │  │  │                       ├─ PortCleaner.class
│  │  │  │  │                       ├─ PortContinuation.class
│  │  │  │  │                       ├─ PortProxyBuilder$DartException.class
│  │  │  │  │                       ├─ PortProxyBuilder$DartImplementation.class
│  │  │  │  │                       └─ PortProxyBuilder.class
│  │  │  │  ├─ library_and_local_jars_jni
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ copyDebugJniLibsProjectAndLocalJars
│  │  │  │  │        └─ jni
│  │  │  │  │           ├─ arm64-v8a
│  │  │  │  │           │  └─ libdartjni.so
│  │  │  │  │           ├─ armeabi-v7a
│  │  │  │  │           │  └─ libdartjni.so
│  │  │  │  │           ├─ x86
│  │  │  │  │           │  └─ libdartjni.so
│  │  │  │  │           └─ x86_64
│  │  │  │  │              └─ libdartjni.so
│  │  │  │  ├─ library_jni
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ copyDebugJniLibsProjectOnly
│  │  │  │  │        └─ jni
│  │  │  │  │           ├─ arm64-v8a
│  │  │  │  │           │  └─ libdartjni.so
│  │  │  │  │           ├─ armeabi-v7a
│  │  │  │  │           │  └─ libdartjni.so
│  │  │  │  │           ├─ x86
│  │  │  │  │           │  └─ libdartjni.so
│  │  │  │  │           └─ x86_64
│  │  │  │  │              └─ libdartjni.so
│  │  │  │  ├─ local_only_symbol_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ parseDebugLocalResources
│  │  │  │  │        └─ R-def.txt
│  │  │  │  ├─ manifest_merge_blame_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        └─ manifest-merger-blame-debug-report.txt
│  │  │  │  ├─ merged_consumer_proguard_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugConsumerProguardFiles
│  │  │  │  │        └─ proguard.txt
│  │  │  │  ├─ merged_java_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugJavaResource
│  │  │  │  │        └─ feature-jni.jar
│  │  │  │  ├─ merged_jni_libs
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugJniLibFolders
│  │  │  │  │        └─ out
│  │  │  │  ├─ merged_manifest
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        └─ AndroidManifest.xml
│  │  │  │  ├─ merged_native_libs
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugNativeLibs
│  │  │  │  │        └─ out
│  │  │  │  │           └─ lib
│  │  │  │  │              ├─ arm64-v8a
│  │  │  │  │              │  └─ libdartjni.so
│  │  │  │  │              ├─ armeabi-v7a
│  │  │  │  │              │  └─ libdartjni.so
│  │  │  │  │              ├─ x86
│  │  │  │  │              │  └─ libdartjni.so
│  │  │  │  │              └─ x86_64
│  │  │  │  │                 └─ libdartjni.so
│  │  │  │  ├─ merged_shaders
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugShaders
│  │  │  │  │        └─ out
│  │  │  │  ├─ merged_test_only_native_libs
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugNativeLibs
│  │  │  │  │        └─ out
│  │  │  │  ├─ navigation_json
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDeepLinksDebug
│  │  │  │  │        └─ navigation.json
│  │  │  │  ├─ nested_resources_validation_report
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugResources
│  │  │  │  │        └─ nestedResourcesValidationReport.txt
│  │  │  │  ├─ packaged_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  ├─ public_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  ├─ runtime_library_classes_dir
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ bundleLibRuntimeToDirDebug
│  │  │  │  │        └─ com
│  │  │  │  │           └─ github
│  │  │  │  │              └─ dart_lang
│  │  │  │  │                 └─ jni
│  │  │  │  │                    ├─ JniPlugin.class
│  │  │  │  │                    ├─ JniUtils.class
│  │  │  │  │                    ├─ PortCleaner$PortPhantom.class
│  │  │  │  │                    ├─ PortCleaner.class
│  │  │  │  │                    ├─ PortContinuation.class
│  │  │  │  │                    ├─ PortProxyBuilder$DartException.class
│  │  │  │  │                    ├─ PortProxyBuilder$DartImplementation.class
│  │  │  │  │                    └─ PortProxyBuilder.class
│  │  │  │  ├─ runtime_library_classes_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ bundleLibRuntimeToJarDebug
│  │  │  │  │        └─ classes.jar
│  │  │  │  ├─ stripped_native_libs
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ stripDebugDebugSymbols
│  │  │  │  │        └─ out
│  │  │  │  │           └─ lib
│  │  │  │  │              ├─ arm64-v8a
│  │  │  │  │              │  └─ libdartjni.so
│  │  │  │  │              ├─ armeabi-v7a
│  │  │  │  │              │  └─ libdartjni.so
│  │  │  │  │              ├─ x86
│  │  │  │  │              │  └─ libdartjni.so
│  │  │  │  │              └─ x86_64
│  │  │  │  │                 └─ libdartjni.so
│  │  │  │  └─ symbol_list_with_package_name
│  │  │  │     └─ debug
│  │  │  │        └─ generateDebugRFile
│  │  │  │           └─ package-aware-r.txt
│  │  │  ├─ outputs
│  │  │  │  ├─ aar
│  │  │  │  │  └─ jni-debug.aar
│  │  │  │  └─ logs
│  │  │  │     └─ manifest-merger-debug-report.txt
│  │  │  └─ tmp
│  │  │     └─ compileDebugJavaWithJavac
│  │  │        └─ previous-compilation-data.bin
│  │  ├─ jni_flutter
│  │  │  ├─ .transforms
│  │  │  │  ├─ 881b4877ca31b83454869587d603e28e
│  │  │  │  │  ├─ results.bin
│  │  │  │  │  └─ transformed
│  │  │  │  │     └─ classes
│  │  │  │  │        ├─ classes_dex
│  │  │  │  │        │  └─ classes.dex
│  │  │  │  │        └─ classes_global-synthetics
│  │  │  │  └─ 9672183f8c9926613ef8cf3ead24b416
│  │  │  │     ├─ results.bin
│  │  │  │     └─ transformed
│  │  │  │        └─ bundleLibRuntimeToDirDebug
│  │  │  │           ├─ bundleLibRuntimeToDirDebug_dex
│  │  │  │           │  └─ com
│  │  │  │           │     └─ github
│  │  │  │           │        └─ dart_lang
│  │  │  │           │           └─ jni_flutter
│  │  │  │           │              └─ JniFlutterPlugin.dex
│  │  │  │           ├─ bundleLibRuntimeToDirDebug_global-synthetics
│  │  │  │           └─ desugar_graph.bin
│  │  │  ├─ generated
│  │  │  │  ├─ ap_generated_sources
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ out
│  │  │  │  └─ res
│  │  │  │     ├─ pngs
│  │  │  │     │  └─ debug
│  │  │  │     └─ resValues
│  │  │  │        └─ debug
│  │  │  ├─ intermediates
│  │  │  │  ├─ aapt_friendly_merged_manifests
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        └─ aapt
│  │  │  │  │           ├─ AndroidManifest.xml
│  │  │  │  │           └─ output-metadata.json
│  │  │  │  ├─ aar_libs_directory
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ syncDebugLibJars
│  │  │  │  │        └─ libs
│  │  │  │  ├─ aar_main_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ syncDebugLibJars
│  │  │  │  │        └─ classes.jar
│  │  │  │  ├─ aar_metadata
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ writeDebugAarMetadata
│  │  │  │  │        └─ aar-metadata.properties
│  │  │  │  ├─ annotations_typedef_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDebugAnnotations
│  │  │  │  │        └─ typedefs.txt
│  │  │  │  ├─ annotations_zip
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDebugAnnotations
│  │  │  │  ├─ annotation_processor_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ javaPreCompileDebug
│  │  │  │  │        └─ annotationProcessors.json
│  │  │  │  ├─ assets
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugAssets
│  │  │  │  ├─ compiled_local_resources
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ compileDebugLibraryResources
│  │  │  │  │        └─ out
│  │  │  │  ├─ compile_library_classes_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ bundleLibCompileToJarDebug
│  │  │  │  │        └─ classes.jar
│  │  │  │  ├─ compile_r_class_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugRFile
│  │  │  │  │        └─ R.jar
│  │  │  │  ├─ compile_symbol_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugRFile
│  │  │  │  │        └─ R.txt
│  │  │  │  ├─ data_binding_layout_info_type_package
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  │        └─ out
│  │  │  │  ├─ incremental
│  │  │  │  │  ├─ debug
│  │  │  │  │  │  └─ packageDebugResources
│  │  │  │  │  │     ├─ compile-file-map.properties
│  │  │  │  │  │     ├─ merged.dir
│  │  │  │  │  │     ├─ merger.xml
│  │  │  │  │  │     └─ stripped.dir
│  │  │  │  │  ├─ debug-mergeJavaRes
│  │  │  │  │  │  ├─ merge-state
│  │  │  │  │  │  └─ zip-cache
│  │  │  │  │  ├─ mergeDebugAssets
│  │  │  │  │  │  └─ merger.xml
│  │  │  │  │  ├─ mergeDebugJniLibFolders
│  │  │  │  │  │  └─ merger.xml
│  │  │  │  │  └─ mergeDebugShaders
│  │  │  │  │     └─ merger.xml
│  │  │  │  ├─ javac
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ compileDebugJavaWithJavac
│  │  │  │  │        └─ classes
│  │  │  │  │           └─ com
│  │  │  │  │              └─ github
│  │  │  │  │                 └─ dart_lang
│  │  │  │  │                    └─ jni_flutter
│  │  │  │  │                       └─ JniFlutterPlugin.class
│  │  │  │  ├─ library_and_local_jars_jni
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ copyDebugJniLibsProjectAndLocalJars
│  │  │  │  │        └─ jni
│  │  │  │  ├─ library_jni
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ copyDebugJniLibsProjectOnly
│  │  │  │  │        └─ jni
│  │  │  │  ├─ local_only_symbol_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ parseDebugLocalResources
│  │  │  │  │        └─ R-def.txt
│  │  │  │  ├─ manifest_merge_blame_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        └─ manifest-merger-blame-debug-report.txt
│  │  │  │  ├─ merged_consumer_proguard_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugConsumerProguardFiles
│  │  │  │  │        └─ proguard.txt
│  │  │  │  ├─ merged_java_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugJavaResource
│  │  │  │  │        └─ feature-jni_flutter.jar
│  │  │  │  ├─ merged_jni_libs
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugJniLibFolders
│  │  │  │  │        └─ out
│  │  │  │  ├─ merged_manifest
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        └─ AndroidManifest.xml
│  │  │  │  ├─ merged_shaders
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugShaders
│  │  │  │  │        └─ out
│  │  │  │  ├─ navigation_json
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDeepLinksDebug
│  │  │  │  │        └─ navigation.json
│  │  │  │  ├─ nested_resources_validation_report
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugResources
│  │  │  │  │        └─ nestedResourcesValidationReport.txt
│  │  │  │  ├─ packaged_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  ├─ public_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  ├─ runtime_library_classes_dir
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ bundleLibRuntimeToDirDebug
│  │  │  │  │        └─ com
│  │  │  │  │           └─ github
│  │  │  │  │              └─ dart_lang
│  │  │  │  │                 └─ jni_flutter
│  │  │  │  │                    └─ JniFlutterPlugin.class
│  │  │  │  ├─ runtime_library_classes_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ bundleLibRuntimeToJarDebug
│  │  │  │  │        └─ classes.jar
│  │  │  │  └─ symbol_list_with_package_name
│  │  │  │     └─ debug
│  │  │  │        └─ generateDebugRFile
│  │  │  │           └─ package-aware-r.txt
│  │  │  ├─ outputs
│  │  │  │  ├─ aar
│  │  │  │  │  └─ jni_flutter-debug.aar
│  │  │  │  └─ logs
│  │  │  │     └─ manifest-merger-debug-report.txt
│  │  │  └─ tmp
│  │  │     └─ compileDebugJavaWithJavac
│  │  │        └─ previous-compilation-data.bin
│  │  ├─ printing
│  │  │  ├─ .transforms
│  │  │  │  ├─ 666b32839099a67f6b80a88a3acdd158
│  │  │  │  │  ├─ results.bin
│  │  │  │  │  └─ transformed
│  │  │  │  │     └─ classes
│  │  │  │  │        ├─ classes_dex
│  │  │  │  │        │  └─ classes.dex
│  │  │  │  │        └─ classes_global-synthetics
│  │  │  │  └─ e12ba10b767bcb4812a5d9fd26d49975
│  │  │  │     ├─ results.bin
│  │  │  │     └─ transformed
│  │  │  │        └─ bundleLibRuntimeToDirDebug
│  │  │  │           ├─ bundleLibRuntimeToDirDebug_dex
│  │  │  │           │  ├─ android
│  │  │  │           │  │  └─ print
│  │  │  │           │  │     ├─ PdfConvert$1$1.dex
│  │  │  │           │  │     ├─ PdfConvert$1.dex
│  │  │  │           │  │     ├─ PdfConvert$Result.dex
│  │  │  │           │  │     └─ PdfConvert.dex
│  │  │  │           │  └─ net
│  │  │  │           │     └─ nfet
│  │  │  │           │        └─ flutter
│  │  │  │           │           └─ printing
│  │  │  │           │              ├─ PrintFileProvider.dex
│  │  │  │           │              ├─ PrintingHandler$1.dex
│  │  │  │           │              ├─ PrintingHandler.dex
│  │  │  │           │              ├─ PrintingJob$1$1.dex
│  │  │  │           │              ├─ PrintingJob$1.dex
│  │  │  │           │              ├─ PrintingJob.dex
│  │  │  │           │              └─ PrintingPlugin.dex
│  │  │  │           ├─ bundleLibRuntimeToDirDebug_global-synthetics
│  │  │  │           └─ desugar_graph.bin
│  │  │  ├─ generated
│  │  │  │  ├─ ap_generated_sources
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ out
│  │  │  │  └─ res
│  │  │  │     ├─ pngs
│  │  │  │     │  └─ debug
│  │  │  │     └─ resValues
│  │  │  │        └─ debug
│  │  │  ├─ intermediates
│  │  │  │  ├─ aapt_friendly_merged_manifests
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        └─ aapt
│  │  │  │  │           ├─ AndroidManifest.xml
│  │  │  │  │           └─ output-metadata.json
│  │  │  │  ├─ aar_libs_directory
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ syncDebugLibJars
│  │  │  │  │        └─ libs
│  │  │  │  ├─ aar_main_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ syncDebugLibJars
│  │  │  │  │        └─ classes.jar
│  │  │  │  ├─ aar_metadata
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ writeDebugAarMetadata
│  │  │  │  │        └─ aar-metadata.properties
│  │  │  │  ├─ annotations_typedef_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDebugAnnotations
│  │  │  │  │        └─ typedefs.txt
│  │  │  │  ├─ annotations_zip
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDebugAnnotations
│  │  │  │  ├─ annotation_processor_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ javaPreCompileDebug
│  │  │  │  │        └─ annotationProcessors.json
│  │  │  │  ├─ assets
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugAssets
│  │  │  │  ├─ compiled_local_resources
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ compileDebugLibraryResources
│  │  │  │  │        └─ out
│  │  │  │  │           └─ xml_flutter_printing_file_paths.xml.flat
│  │  │  │  ├─ compile_library_classes_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ bundleLibCompileToJarDebug
│  │  │  │  │        └─ classes.jar
│  │  │  │  ├─ compile_r_class_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugRFile
│  │  │  │  │        └─ R.jar
│  │  │  │  ├─ compile_symbol_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugRFile
│  │  │  │  │        └─ R.txt
│  │  │  │  ├─ data_binding_layout_info_type_package
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  │        └─ out
│  │  │  │  ├─ incremental
│  │  │  │  │  ├─ debug
│  │  │  │  │  │  └─ packageDebugResources
│  │  │  │  │  │     ├─ compile-file-map.properties
│  │  │  │  │  │     ├─ merged.dir
│  │  │  │  │  │     ├─ merger.xml
│  │  │  │  │  │     └─ stripped.dir
│  │  │  │  │  ├─ debug-mergeJavaRes
│  │  │  │  │  │  ├─ merge-state
│  │  │  │  │  │  └─ zip-cache
│  │  │  │  │  ├─ mergeDebugAssets
│  │  │  │  │  │  └─ merger.xml
│  │  │  │  │  ├─ mergeDebugJniLibFolders
│  │  │  │  │  │  └─ merger.xml
│  │  │  │  │  └─ mergeDebugShaders
│  │  │  │  │     └─ merger.xml
│  │  │  │  ├─ javac
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ compileDebugJavaWithJavac
│  │  │  │  │        └─ classes
│  │  │  │  │           ├─ android
│  │  │  │  │           │  └─ print
│  │  │  │  │           │     ├─ PdfConvert$1$1.class
│  │  │  │  │           │     ├─ PdfConvert$1.class
│  │  │  │  │           │     ├─ PdfConvert$Result.class
│  │  │  │  │           │     └─ PdfConvert.class
│  │  │  │  │           └─ net
│  │  │  │  │              └─ nfet
│  │  │  │  │                 └─ flutter
│  │  │  │  │                    └─ printing
│  │  │  │  │                       ├─ PrintFileProvider.class
│  │  │  │  │                       ├─ PrintingHandler$1.class
│  │  │  │  │                       ├─ PrintingHandler.class
│  │  │  │  │                       ├─ PrintingJob$1$1.class
│  │  │  │  │                       ├─ PrintingJob$1.class
│  │  │  │  │                       ├─ PrintingJob.class
│  │  │  │  │                       └─ PrintingPlugin.class
│  │  │  │  ├─ library_and_local_jars_jni
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ copyDebugJniLibsProjectAndLocalJars
│  │  │  │  │        └─ jni
│  │  │  │  ├─ library_jni
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ copyDebugJniLibsProjectOnly
│  │  │  │  │        └─ jni
│  │  │  │  ├─ local_only_symbol_list
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ parseDebugLocalResources
│  │  │  │  │        └─ R-def.txt
│  │  │  │  ├─ manifest_merge_blame_file
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        └─ manifest-merger-blame-debug-report.txt
│  │  │  │  ├─ merged_java_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugJavaResource
│  │  │  │  │        └─ feature-printing.jar
│  │  │  │  ├─ merged_jni_libs
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugJniLibFolders
│  │  │  │  │        └─ out
│  │  │  │  ├─ merged_manifest
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ processDebugManifest
│  │  │  │  │        └─ AndroidManifest.xml
│  │  │  │  ├─ merged_shaders
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ mergeDebugShaders
│  │  │  │  │        └─ out
│  │  │  │  ├─ navigation_json
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ extractDeepLinksDebug
│  │  │  │  │        └─ navigation.json
│  │  │  │  ├─ nested_resources_validation_report
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ generateDebugResources
│  │  │  │  │        └─ nestedResourcesValidationReport.txt
│  │  │  │  ├─ packaged_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  │        └─ xml
│  │  │  │  │           └─ flutter_printing_file_paths.xml
│  │  │  │  ├─ public_res
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ packageDebugResources
│  │  │  │  ├─ runtime_library_classes_dir
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ bundleLibRuntimeToDirDebug
│  │  │  │  │        ├─ android
│  │  │  │  │        │  └─ print
│  │  │  │  │        │     ├─ PdfConvert$1$1.class
│  │  │  │  │        │     ├─ PdfConvert$1.class
│  │  │  │  │        │     ├─ PdfConvert$Result.class
│  │  │  │  │        │     └─ PdfConvert.class
│  │  │  │  │        └─ net
│  │  │  │  │           └─ nfet
│  │  │  │  │              └─ flutter
│  │  │  │  │                 └─ printing
│  │  │  │  │                    ├─ PrintFileProvider.class
│  │  │  │  │                    ├─ PrintingHandler$1.class
│  │  │  │  │                    ├─ PrintingHandler.class
│  │  │  │  │                    ├─ PrintingJob$1$1.class
│  │  │  │  │                    ├─ PrintingJob$1.class
│  │  │  │  │                    ├─ PrintingJob.class
│  │  │  │  │                    └─ PrintingPlugin.class
│  │  │  │  ├─ runtime_library_classes_jar
│  │  │  │  │  └─ debug
│  │  │  │  │     └─ bundleLibRuntimeToJarDebug
│  │  │  │  │        └─ classes.jar
│  │  │  │  └─ symbol_list_with_package_name
│  │  │  │     └─ debug
│  │  │  │        └─ generateDebugRFile
│  │  │  │           └─ package-aware-r.txt
│  │  │  ├─ outputs
│  │  │  │  ├─ aar
│  │  │  │  │  └─ printing-debug.aar
│  │  │  │  └─ logs
│  │  │  │     └─ manifest-merger-debug-report.txt
│  │  │  └─ tmp
│  │  │     └─ compileDebugJavaWithJavac
│  │  │        └─ previous-compilation-data.bin
│  │  └─ reports
│  │     └─ problems
│  │        └─ problems-report.html
│  ├─ clinic_app.iml
│  ├─ flutter_01.png
│  ├─ flutter_02.png
│  ├─ ios
│  │  ├─ Flutter
│  │  │  ├─ AppFrameworkInfo.plist
│  │  │  ├─ Debug.xcconfig
│  │  │  ├─ ephemeral
│  │  │  │  ├─ flutter_lldbinit
│  │  │  │  ├─ flutter_lldb_helper.py
│  │  │  │  └─ flutter_native_integration.env
│  │  │  ├─ flutter_export_environment.sh
│  │  │  ├─ Generated.xcconfig
│  │  │  └─ Release.xcconfig
│  │  ├─ Runner
│  │  │  ├─ AppDelegate.swift
│  │  │  ├─ Assets.xcassets
│  │  │  │  ├─ AppIcon.appiconset
│  │  │  │  │  ├─ Contents.json
│  │  │  │  │  ├─ Icon-App-1024x1024@1x.png
│  │  │  │  │  ├─ Icon-App-20x20@1x.png
│  │  │  │  │  ├─ Icon-App-20x20@2x.png
│  │  │  │  │  ├─ Icon-App-20x20@3x.png
│  │  │  │  │  ├─ Icon-App-29x29@1x.png
│  │  │  │  │  ├─ Icon-App-29x29@2x.png
│  │  │  │  │  ├─ Icon-App-29x29@3x.png
│  │  │  │  │  ├─ Icon-App-40x40@1x.png
│  │  │  │  │  ├─ Icon-App-40x40@2x.png
│  │  │  │  │  ├─ Icon-App-40x40@3x.png
│  │  │  │  │  ├─ Icon-App-60x60@2x.png
│  │  │  │  │  ├─ Icon-App-60x60@3x.png
│  │  │  │  │  ├─ Icon-App-76x76@1x.png
│  │  │  │  │  ├─ Icon-App-76x76@2x.png
│  │  │  │  │  └─ Icon-App-83.5x83.5@2x.png
│  │  │  │  ├─ BrandingImage.imageset
│  │  │  │  │  ├─ BrandingImage.png
│  │  │  │  │  ├─ BrandingImage@2x.png
│  │  │  │  │  ├─ BrandingImage@3x.png
│  │  │  │  │  └─ Contents.json
│  │  │  │  ├─ LaunchBackground.imageset
│  │  │  │  │  ├─ background.png
│  │  │  │  │  └─ Contents.json
│  │  │  │  └─ LaunchImage.imageset
│  │  │  │     ├─ Contents.json
│  │  │  │     ├─ LaunchImage.png
│  │  │  │     ├─ LaunchImage@2x.png
│  │  │  │     ├─ LaunchImage@3x.png
│  │  │  │     └─ README.md
│  │  │  ├─ Base.lproj
│  │  │  │  ├─ LaunchScreen.storyboard
│  │  │  │  └─ Main.storyboard
│  │  │  ├─ GeneratedPluginRegistrant.h
│  │  │  ├─ GeneratedPluginRegistrant.m
│  │  │  ├─ Info.plist
│  │  │  └─ Runner-Bridging-Header.h
│  │  ├─ Runner.xcodeproj
│  │  │  ├─ project.pbxproj
│  │  │  ├─ project.xcworkspace
│  │  │  │  ├─ contents.xcworkspacedata
│  │  │  │  └─ xcshareddata
│  │  │  │     ├─ IDEWorkspaceChecks.plist
│  │  │  │     └─ WorkspaceSettings.xcsettings
│  │  │  └─ xcshareddata
│  │  │     └─ xcschemes
│  │  │        └─ Runner.xcscheme
│  │  ├─ Runner.xcworkspace
│  │  │  ├─ contents.xcworkspacedata
│  │  │  └─ xcshareddata
│  │  │     ├─ IDEWorkspaceChecks.plist
│  │  │     └─ WorkspaceSettings.xcsettings
│  │  └─ RunnerTests
│  │     └─ RunnerTests.swift
│  ├─ l10n.yaml
│  ├─ lib
│  │  ├─ core
│  │  │  ├─ app_theme.dart
│  │  │  └─ constants.dart
│  │  ├─ l10n
│  │  │  ├─ app_ar.arb
│  │  │  ├─ app_en.arb
│  │  │  ├─ app_fr.arb
│  │  │  ├─ app_localizations.dart
│  │  │  ├─ app_localizations_ar.dart
│  │  │  ├─ app_localizations_en.dart
│  │  │  └─ app_localizations_fr.dart
│  │  ├─ main.dart
│  │  ├─ models
│  │  │  ├─ appointment_model.dart
│  │  │  ├─ consultation_model.dart
│  │  │  ├─ doctor_model.dart
│  │  │  ├─ medicament_model.dart
│  │  │  ├─ notification_model.dart
│  │  │  ├─ paiement_model.dart
│  │  │  ├─ patient_model.dart
│  │  │  ├─ prescription_model.dart
│  │  │  └─ user_model.dart
│  │  ├─ providers
│  │  │  ├─ auth_provider.dart
│  │  │  └─ locale_provider.dart
│  │  ├─ screens
│  │  │  ├─ auth_screen.dart
│  │  │  ├─ dashboards
│  │  │  │  ├─ admin_dashboard.dart
│  │  │  │  ├─ doctor_dashboard.dart
│  │  │  │  ├─ patient_dashboard.dart
│  │  │  │  └─ receptionist_dashboard.dart
│  │  │  ├─ home_screen.dart
│  │  │  ├─ notifications_screen.dart
│  │  │  ├─ payment_screen.dart
│  │  │  └─ role_router.dart
│  │  ├─ services
│  │  │  ├─ api_client.dart
│  │  │  ├─ appointment_service.dart
│  │  │  ├─ auth_service.dart
│  │  │  ├─ consultation_service.dart
│  │  │  ├─ medicine_service.dart
│  │  │  ├─ notification_service.dart
│  │  │  ├─ payment_service.dart
│  │  │  ├─ pdf_service.dart
│  │  │  ├─ pdf_share_helper.dart
│  │  │  ├─ pdf_share_helper_stub.dart
│  │  │  ├─ pdf_share_helper_web.dart
│  │  │  ├─ prescription_service.dart
│  │  │  └─ user_service.dart
│  │  └─ widgets
│  │     └─ password_dialogs.dart
│  ├─ lib.zip
│  ├─ linux
│  │  ├─ CMakeLists.txt
│  │  ├─ flutter
│  │  │  ├─ CMakeLists.txt
│  │  │  ├─ ephemeral
│  │  │  │  └─ .plugin_symlinks
│  │  │  │     ├─ flutter_secure_storage_linux
│  │  │  │     │  ├─ CHANGELOG.md
│  │  │  │     │  ├─ LICENSE
│  │  │  │     │  ├─ linux
│  │  │  │     │  │  ├─ CMakeLists.txt
│  │  │  │     │  │  ├─ flutter_secure_storage_linux_plugin.cc
│  │  │  │     │  │  └─ include
│  │  │  │     │  │     ├─ FHashTable.hpp
│  │  │  │     │  │     ├─ flutter_secure_storage_linux
│  │  │  │     │  │     │  └─ flutter_secure_storage_linux_plugin.h
│  │  │  │     │  │     ├─ json.hpp
│  │  │  │     │  │     └─ Secret.hpp
│  │  │  │     │  ├─ pubspec.yaml
│  │  │  │     │  └─ README.md
│  │  │  │     ├─ jni
│  │  │  │     │  ├─ analysis_options.yaml
│  │  │  │     │  ├─ android
│  │  │  │     │  │  ├─ .cxx
│  │  │  │     │  │  │  ├─ Debug
│  │  │  │     │  │  │  │  └─ 3135x4o6
│  │  │  │     │  │  │  │     ├─ arm64-v8a
│  │  │  │     │  │  │  │     │  ├─ .cmake
│  │  │  │     │  │  │  │     │  │  └─ api
│  │  │  │     │  │  │  │     │  │     └─ v1
│  │  │  │     │  │  │  │     │  │        ├─ query
│  │  │  │     │  │  │  │     │  │        │  └─ client-agp
│  │  │  │     │  │  │  │     │  │        │     ├─ cache-v2
│  │  │  │     │  │  │  │     │  │        │     ├─ cmakeFiles-v1
│  │  │  │     │  │  │  │     │  │        │     └─ codemodel-v2
│  │  │  │     │  │  │  │     │  │        └─ reply
│  │  │  │     │  │  │  │     │  │           ├─ cache-v2-fc23e3053225a90105ea.json
│  │  │  │     │  │  │  │     │  │           ├─ cmakeFiles-v1-1ebd7ff04cf255fcc58d.json
│  │  │  │     │  │  │  │     │  │           ├─ codemodel-v2-dc1730778b21755a5f42.json
│  │  │  │     │  │  │  │     │  │           ├─ directory-.-Debug-d0094a50bb2071803777.json
│  │  │  │     │  │  │  │     │  │           ├─ index-2026-06-13T18-49-55-0568.json
│  │  │  │     │  │  │  │     │  │           └─ target-jni-Debug-377ebb35884cf67554d8.json
│  │  │  │     │  │  │  │     │  ├─ .ninja_deps
│  │  │  │     │  │  │  │     │  ├─ .ninja_log
│  │  │  │     │  │  │  │     │  ├─ additional_project_files.txt
│  │  │  │     │  │  │  │     │  ├─ android_gradle_build.json
│  │  │  │     │  │  │  │     │  ├─ android_gradle_build_mini.json
│  │  │  │     │  │  │  │     │  ├─ build.ninja
│  │  │  │     │  │  │  │     │  ├─ build_file_index.txt
│  │  │  │     │  │  │  │     │  ├─ CMakeCache.txt
│  │  │  │     │  │  │  │     │  ├─ CMakeFiles
│  │  │  │     │  │  │  │     │  │  ├─ 3.22.1-g37088a8-dirty
│  │  │  │     │  │  │  │     │  │  │  ├─ CMakeCCompiler.cmake
│  │  │  │     │  │  │  │     │  │  │  ├─ CMakeDetermineCompilerABI_C.bin
│  │  │  │     │  │  │  │     │  │  │  ├─ CMakeSystem.cmake
│  │  │  │     │  │  │  │     │  │  │  └─ CompilerIdC
│  │  │  │     │  │  │  │     │  │  │     ├─ CMakeCCompilerId.c
│  │  │  │     │  │  │  │     │  │  │     ├─ CMakeCCompilerId.o
│  │  │  │     │  │  │  │     │  │  │     └─ tmp
│  │  │  │     │  │  │  │     │  │  ├─ cmake.check_cache
│  │  │  │     │  │  │  │     │  │  ├─ CMakeOutput.log
│  │  │  │     │  │  │  │     │  │  ├─ CMakeTmp
│  │  │  │     │  │  │  │     │  │  ├─ jni.dir
│  │  │  │     │  │  │  │     │  │  │  ├─ dartjni.c.o
│  │  │  │     │  │  │  │     │  │  │  ├─ include
│  │  │  │     │  │  │  │     │  │  │  │  └─ dart_api_dl.c.o
│  │  │  │     │  │  │  │     │  │  │  └─ third_party
│  │  │  │     │  │  │  │     │  │  │     └─ global_jni_env.c.o
│  │  │  │     │  │  │  │     │  │  ├─ rules.ninja
│  │  │  │     │  │  │  │     │  │  └─ TargetDirectories.txt
│  │  │  │     │  │  │  │     │  ├─ cmake_install.cmake
│  │  │  │     │  │  │  │     │  ├─ compile_commands.json
│  │  │  │     │  │  │  │     │  ├─ compile_commands.json.bin
│  │  │  │     │  │  │  │     │  ├─ configure_fingerprint.bin
│  │  │  │     │  │  │  │     │  ├─ metadata_generation_command.txt
│  │  │  │     │  │  │  │     │  ├─ prefab_config.json
│  │  │  │     │  │  │  │     │  └─ symbol_folder_index.txt
│  │  │  │     │  │  │  │     ├─ armeabi-v7a
│  │  │  │     │  │  │  │     │  ├─ .cmake
│  │  │  │     │  │  │  │     │  │  └─ api
│  │  │  │     │  │  │  │     │  │     └─ v1
│  │  │  │     │  │  │  │     │  │        ├─ query
│  │  │  │     │  │  │  │     │  │        │  └─ client-agp
│  │  │  │     │  │  │  │     │  │        │     ├─ cache-v2
│  │  │  │     │  │  │  │     │  │        │     ├─ cmakeFiles-v1
│  │  │  │     │  │  │  │     │  │        │     └─ codemodel-v2
│  │  │  │     │  │  │  │     │  │        └─ reply
│  │  │  │     │  │  │  │     │  │           ├─ cache-v2-ff030fa67a2d1fd18794.json
│  │  │  │     │  │  │  │     │  │           ├─ cmakeFiles-v1-bf5182b93410b271d235.json
│  │  │  │     │  │  │  │     │  │           ├─ codemodel-v2-30bed738429f6f971ab4.json
│  │  │  │     │  │  │  │     │  │           ├─ directory-.-Debug-d0094a50bb2071803777.json
│  │  │  │     │  │  │  │     │  │           ├─ index-2026-06-13T18-49-57-0288.json
│  │  │  │     │  │  │  │     │  │           └─ target-jni-Debug-7e5a151faa09354dc644.json
│  │  │  │     │  │  │  │     │  ├─ .ninja_deps
│  │  │  │     │  │  │  │     │  ├─ .ninja_log
│  │  │  │     │  │  │  │     │  ├─ additional_project_files.txt
│  │  │  │     │  │  │  │     │  ├─ android_gradle_build.json
│  │  │  │     │  │  │  │     │  ├─ android_gradle_build_mini.json
│  │  │  │     │  │  │  │     │  ├─ build.ninja
│  │  │  │     │  │  │  │     │  ├─ build_file_index.txt
│  │  │  │     │  │  │  │     │  ├─ CMakeCache.txt
│  │  │  │     │  │  │  │     │  ├─ CMakeFiles
│  │  │  │     │  │  │  │     │  │  ├─ 3.22.1-g37088a8-dirty
│  │  │  │     │  │  │  │     │  │  │  ├─ CMakeCCompiler.cmake
│  │  │  │     │  │  │  │     │  │  │  ├─ CMakeDetermineCompilerABI_C.bin
│  │  │  │     │  │  │  │     │  │  │  ├─ CMakeSystem.cmake
│  │  │  │     │  │  │  │     │  │  │  └─ CompilerIdC
│  │  │  │     │  │  │  │     │  │  │     ├─ CMakeCCompilerId.c
│  │  │  │     │  │  │  │     │  │  │     ├─ CMakeCCompilerId.o
│  │  │  │     │  │  │  │     │  │  │     └─ tmp
│  │  │  │     │  │  │  │     │  │  ├─ cmake.check_cache
│  │  │  │     │  │  │  │     │  │  ├─ CMakeOutput.log
│  │  │  │     │  │  │  │     │  │  ├─ CMakeTmp
│  │  │  │     │  │  │  │     │  │  ├─ jni.dir
│  │  │  │     │  │  │  │     │  │  │  ├─ dartjni.c.o
│  │  │  │     │  │  │  │     │  │  │  ├─ include
│  │  │  │     │  │  │  │     │  │  │  │  └─ dart_api_dl.c.o
│  │  │  │     │  │  │  │     │  │  │  └─ third_party
│  │  │  │     │  │  │  │     │  │  │     └─ global_jni_env.c.o
│  │  │  │     │  │  │  │     │  │  ├─ rules.ninja
│  │  │  │     │  │  │  │     │  │  └─ TargetDirectories.txt
│  │  │  │     │  │  │  │     │  ├─ cmake_install.cmake
│  │  │  │     │  │  │  │     │  ├─ compile_commands.json
│  │  │  │     │  │  │  │     │  ├─ compile_commands.json.bin
│  │  │  │     │  │  │  │     │  ├─ configure_fingerprint.bin
│  │  │  │     │  │  │  │     │  ├─ metadata_generation_command.txt
│  │  │  │     │  │  │  │     │  ├─ prefab_config.json
│  │  │  │     │  │  │  │     │  └─ symbol_folder_index.txt
│  │  │  │     │  │  │  │     ├─ hash_key.txt
│  │  │  │     │  │  │  │     ├─ x86
│  │  │  │     │  │  │  │     │  ├─ .cmake
│  │  │  │     │  │  │  │     │  │  └─ api
│  │  │  │     │  │  │  │     │  │     └─ v1
│  │  │  │     │  │  │  │     │  │        ├─ query
│  │  │  │     │  │  │  │     │  │        │  └─ client-agp
│  │  │  │     │  │  │  │     │  │        │     ├─ cache-v2
│  │  │  │     │  │  │  │     │  │        │     ├─ cmakeFiles-v1
│  │  │  │     │  │  │  │     │  │        │     └─ codemodel-v2
│  │  │  │     │  │  │  │     │  │        └─ reply
│  │  │  │     │  │  │  │     │  │           ├─ cache-v2-dfac77358f7b0d5f903b.json
│  │  │  │     │  │  │  │     │  │           ├─ cmakeFiles-v1-0ebf16309973b67cc19e.json
│  │  │  │     │  │  │  │     │  │           ├─ codemodel-v2-5b48c08e2e8661d50e00.json
│  │  │  │     │  │  │  │     │  │           ├─ directory-.-Debug-d0094a50bb2071803777.json
│  │  │  │     │  │  │  │     │  │           ├─ index-2026-06-13T18-49-58-0773.json
│  │  │  │     │  │  │  │     │  │           └─ target-jni-Debug-542f9182b6d6737e4276.json
│  │  │  │     │  │  │  │     │  ├─ .ninja_deps
│  │  │  │     │  │  │  │     │  ├─ .ninja_log
│  │  │  │     │  │  │  │     │  ├─ additional_project_files.txt
│  │  │  │     │  │  │  │     │  ├─ android_gradle_build.json
│  │  │  │     │  │  │  │     │  ├─ android_gradle_build_mini.json
│  │  │  │     │  │  │  │     │  ├─ build.ninja
│  │  │  │     │  │  │  │     │  ├─ build_file_index.txt
│  │  │  │     │  │  │  │     │  ├─ CMakeCache.txt
│  │  │  │     │  │  │  │     │  ├─ CMakeFiles
│  │  │  │     │  │  │  │     │  │  ├─ 3.22.1-g37088a8-dirty
│  │  │  │     │  │  │  │     │  │  │  ├─ CMakeCCompiler.cmake
│  │  │  │     │  │  │  │     │  │  │  ├─ CMakeDetermineCompilerABI_C.bin
│  │  │  │     │  │  │  │     │  │  │  ├─ CMakeSystem.cmake
│  │  │  │     │  │  │  │     │  │  │  └─ CompilerIdC
│  │  │  │     │  │  │  │     │  │  │     ├─ CMakeCCompilerId.c
│  │  │  │     │  │  │  │     │  │  │     ├─ CMakeCCompilerId.o
│  │  │  │     │  │  │  │     │  │  │     └─ tmp
│  │  │  │     │  │  │  │     │  │  ├─ cmake.check_cache
│  │  │  │     │  │  │  │     │  │  ├─ CMakeOutput.log
│  │  │  │     │  │  │  │     │  │  ├─ CMakeTmp
│  │  │  │     │  │  │  │     │  │  ├─ jni.dir
│  │  │  │     │  │  │  │     │  │  │  ├─ dartjni.c.o
│  │  │  │     │  │  │  │     │  │  │  ├─ include
│  │  │  │     │  │  │  │     │  │  │  │  └─ dart_api_dl.c.o
│  │  │  │     │  │  │  │     │  │  │  └─ third_party
│  │  │  │     │  │  │  │     │  │  │     └─ global_jni_env.c.o
│  │  │  │     │  │  │  │     │  │  ├─ rules.ninja
│  │  │  │     │  │  │  │     │  │  └─ TargetDirectories.txt
│  │  │  │     │  │  │  │     │  ├─ cmake_install.cmake
│  │  │  │     │  │  │  │     │  ├─ compile_commands.json
│  │  │  │     │  │  │  │     │  ├─ compile_commands.json.bin
│  │  │  │     │  │  │  │     │  ├─ configure_fingerprint.bin
│  │  │  │     │  │  │  │     │  ├─ metadata_generation_command.txt
│  │  │  │     │  │  │  │     │  ├─ prefab_config.json
│  │  │  │     │  │  │  │     │  └─ symbol_folder_index.txt
│  │  │  │     │  │  │  │     └─ x86_64
│  │  │  │     │  │  │  │        ├─ .cmake
│  │  │  │     │  │  │  │        │  └─ api
│  │  │  │     │  │  │  │        │     └─ v1
│  │  │  │     │  │  │  │        │        ├─ query
│  │  │  │     │  │  │  │        │        │  └─ client-agp
│  │  │  │     │  │  │  │        │        │     ├─ cache-v2
│  │  │  │     │  │  │  │        │        │     ├─ cmakeFiles-v1
│  │  │  │     │  │  │  │        │        │     └─ codemodel-v2
│  │  │  │     │  │  │  │        │        └─ reply
│  │  │  │     │  │  │  │        │           ├─ cache-v2-79cec5976b9f05479805.json
│  │  │  │     │  │  │  │        │           ├─ cmakeFiles-v1-fd0b52345001342c2fdc.json
│  │  │  │     │  │  │  │        │           ├─ codemodel-v2-b7b11e03a5dd81a3c1c5.json
│  │  │  │     │  │  │  │        │           ├─ directory-.-Debug-d0094a50bb2071803777.json
│  │  │  │     │  │  │  │        │           ├─ index-2026-06-13T18-50-00-0248.json
│  │  │  │     │  │  │  │        │           └─ target-jni-Debug-6437d799148b67cc25fe.json
│  │  │  │     │  │  │  │        ├─ .ninja_deps
│  │  │  │     │  │  │  │        ├─ .ninja_log
│  │  │  │     │  │  │  │        ├─ additional_project_files.txt
│  │  │  │     │  │  │  │        ├─ android_gradle_build.json
│  │  │  │     │  │  │  │        ├─ android_gradle_build_mini.json
│  │  │  │     │  │  │  │        ├─ build.ninja
│  │  │  │     │  │  │  │        ├─ build_file_index.txt
│  │  │  │     │  │  │  │        ├─ CMakeCache.txt
│  │  │  │     │  │  │  │        ├─ CMakeFiles
│  │  │  │     │  │  │  │        │  ├─ 3.22.1-g37088a8-dirty
│  │  │  │     │  │  │  │        │  │  ├─ CMakeCCompiler.cmake
│  │  │  │     │  │  │  │        │  │  ├─ CMakeDetermineCompilerABI_C.bin
│  │  │  │     │  │  │  │        │  │  ├─ CMakeSystem.cmake
│  │  │  │     │  │  │  │        │  │  └─ CompilerIdC
│  │  │  │     │  │  │  │        │  │     ├─ CMakeCCompilerId.c
│  │  │  │     │  │  │  │        │  │     ├─ CMakeCCompilerId.o
│  │  │  │     │  │  │  │        │  │     └─ tmp
│  │  │  │     │  │  │  │        │  ├─ cmake.check_cache
│  │  │  │     │  │  │  │        │  ├─ CMakeOutput.log
│  │  │  │     │  │  │  │        │  ├─ CMakeTmp
│  │  │  │     │  │  │  │        │  ├─ jni.dir
│  │  │  │     │  │  │  │        │  │  ├─ dartjni.c.o
│  │  │  │     │  │  │  │        │  │  ├─ include
│  │  │  │     │  │  │  │        │  │  │  └─ dart_api_dl.c.o
│  │  │  │     │  │  │  │        │  │  └─ third_party
│  │  │  │     │  │  │  │        │  │     └─ global_jni_env.c.o
│  │  │  │     │  │  │  │        │  ├─ rules.ninja
│  │  │  │     │  │  │  │        │  └─ TargetDirectories.txt
│  │  │  │     │  │  │  │        ├─ cmake_install.cmake
│  │  │  │     │  │  │  │        ├─ compile_commands.json
│  │  │  │     │  │  │  │        ├─ compile_commands.json.bin
│  │  │  │     │  │  │  │        ├─ configure_fingerprint.bin
│  │  │  │     │  │  │  │        ├─ metadata_generation_command.txt
│  │  │  │     │  │  │  │        ├─ prefab_config.json
│  │  │  │     │  │  │  │        └─ symbol_folder_index.txt
│  │  │  │     │  │  │  └─ tools
│  │  │  │     │  │  │     └─ profile
│  │  │  │     │  │  │        ├─ arm64-v8a
│  │  │  │     │  │  │        │  └─ compile_commands.json
│  │  │  │     │  │  │        ├─ armeabi-v7a
│  │  │  │     │  │  │        │  └─ compile_commands.json
│  │  │  │     │  │  │        ├─ x86
│  │  │  │     │  │  │        │  └─ compile_commands.json
│  │  │  │     │  │  │        └─ x86_64
│  │  │  │     │  │  │           └─ compile_commands.json
│  │  │  │     │  │  ├─ build.gradle
│  │  │  │     │  │  ├─ consumer-rules.pro
│  │  │  │     │  │  ├─ README.md
│  │  │  │     │  │  ├─ settings.gradle
│  │  │  │     │  │  └─ src
│  │  │  │     │  │     └─ main
│  │  │  │     │  │        ├─ AndroidManifest.xml
│  │  │  │     │  │        └─ java
│  │  │  │     │  │           └─ com
│  │  │  │     │  │              └─ github
│  │  │  │     │  │                 └─ dart_lang
│  │  │  │     │  │                    └─ jni
│  │  │  │     │  │                       └─ JniPlugin.java
│  │  │  │     │  ├─ bin
│  │  │  │     │  │  └─ setup.dart
│  │  │  │     │  ├─ CHANGELOG.md
│  │  │  │     │  ├─ dart_test.yaml
│  │  │  │     │  ├─ example
│  │  │  │     │  │  ├─ analysis_options.yaml
│  │  │  │     │  │  ├─ android
│  │  │  │     │  │  │  ├─ app
│  │  │  │     │  │  │  │  ├─ build.gradle
│  │  │  │     │  │  │  │  └─ src
│  │  │  │     │  │  │  │     ├─ debug
│  │  │  │     │  │  │  │     │  └─ AndroidManifest.xml
│  │  │  │     │  │  │  │     ├─ main
│  │  │  │     │  │  │  │     │  ├─ AndroidManifest.xml
│  │  │  │     │  │  │  │     │  ├─ java
│  │  │  │     │  │  │  │     │  │  ├─ com
│  │  │  │     │  │  │  │     │  │  │  └─ github
│  │  │  │     │  │  │  │     │  │  │     └─ dart_lang
│  │  │  │     │  │  │  │     │  │  │        └─ jni_example
│  │  │  │     │  │  │  │     │  │  │           └─ Toaster.java
│  │  │  │     │  │  │  │     │  │  └─ io
│  │  │  │     │  │  │  │     │  │     └─ flutter
│  │  │  │     │  │  │  │     │  │        └─ plugins
│  │  │  │     │  │  │  │     │  ├─ kotlin
│  │  │  │     │  │  │  │     │  │  └─ dev
│  │  │  │     │  │  │  │     │  │     └─ dart
│  │  │  │     │  │  │  │     │  │        └─ jni_example
│  │  │  │     │  │  │  │     │  │           └─ MainActivity.kt
│  │  │  │     │  │  │  │     │  └─ res
│  │  │  │     │  │  │  │     │     ├─ drawable
│  │  │  │     │  │  │  │     │     │  └─ launch_background.xml
│  │  │  │     │  │  │  │     │     ├─ drawable-v21
│  │  │  │     │  │  │  │     │     │  └─ launch_background.xml
│  │  │  │     │  │  │  │     │     ├─ mipmap-hdpi
│  │  │  │     │  │  │  │     │     │  └─ ic_launcher.png
│  │  │  │     │  │  │  │     │     ├─ mipmap-mdpi
│  │  │  │     │  │  │  │     │     │  └─ ic_launcher.png
│  │  │  │     │  │  │  │     │     ├─ mipmap-xhdpi
│  │  │  │     │  │  │  │     │     │  └─ ic_launcher.png
│  │  │  │     │  │  │  │     │     ├─ mipmap-xxhdpi
│  │  │  │     │  │  │  │     │     │  └─ ic_launcher.png
│  │  │  │     │  │  │  │     │     ├─ mipmap-xxxhdpi
│  │  │  │     │  │  │  │     │     │  └─ ic_launcher.png
│  │  │  │     │  │  │  │     │     ├─ values
│  │  │  │     │  │  │  │     │     │  └─ styles.xml
│  │  │  │     │  │  │  │     │     └─ values-night
│  │  │  │     │  │  │  │     │        └─ styles.xml
│  │  │  │     │  │  │  │     └─ profile
│  │  │  │     │  │  │  │        └─ AndroidManifest.xml
│  │  │  │     │  │  │  ├─ build.gradle
│  │  │  │     │  │  │  ├─ gradle
│  │  │  │     │  │  │  │  └─ wrapper
│  │  │  │     │  │  │  │     └─ gradle-wrapper.properties
│  │  │  │     │  │  │  ├─ gradle.properties
│  │  │  │     │  │  │  └─ settings.gradle
│  │  │  │     │  │  ├─ integration_test
│  │  │  │     │  │  │  └─ on_device_jni_test.dart
│  │  │  │     │  │  ├─ lib
│  │  │  │     │  │  │  └─ main.dart
│  │  │  │     │  │  ├─ linux
│  │  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │  │     │  │  │  ├─ flutter
│  │  │  │     │  │  │  │  └─ CMakeLists.txt
│  │  │  │     │  │  │  ├─ main.cc
│  │  │  │     │  │  │  ├─ my_application.cc
│  │  │  │     │  │  │  └─ my_application.h
│  │  │  │     │  │  ├─ macos
│  │  │  │     │  │  │  ├─ Flutter
│  │  │  │     │  │  │  │  ├─ Flutter-Debug.xcconfig
│  │  │  │     │  │  │  │  └─ Flutter-Release.xcconfig
│  │  │  │     │  │  │  ├─ Podfile
│  │  │  │     │  │  │  ├─ Runner
│  │  │  │     │  │  │  │  ├─ AppDelegate.swift
│  │  │  │     │  │  │  │  ├─ Assets.xcassets
│  │  │  │     │  │  │  │  │  └─ AppIcon.appiconset
│  │  │  │     │  │  │  │  │     ├─ app_icon_1024.png
│  │  │  │     │  │  │  │  │     ├─ app_icon_128.png
│  │  │  │     │  │  │  │  │     ├─ app_icon_16.png
│  │  │  │     │  │  │  │  │     ├─ app_icon_256.png
│  │  │  │     │  │  │  │  │     ├─ app_icon_32.png
│  │  │  │     │  │  │  │  │     ├─ app_icon_512.png
│  │  │  │     │  │  │  │  │     ├─ app_icon_64.png
│  │  │  │     │  │  │  │  │     └─ Contents.json
│  │  │  │     │  │  │  │  ├─ Base.lproj
│  │  │  │     │  │  │  │  │  └─ MainMenu.xib
│  │  │  │     │  │  │  │  ├─ Configs
│  │  │  │     │  │  │  │  │  ├─ AppInfo.xcconfig
│  │  │  │     │  │  │  │  │  ├─ Debug.xcconfig
│  │  │  │     │  │  │  │  │  ├─ Release.xcconfig
│  │  │  │     │  │  │  │  │  └─ Warnings.xcconfig
│  │  │  │     │  │  │  │  ├─ DebugProfile.entitlements
│  │  │  │     │  │  │  │  ├─ Info.plist
│  │  │  │     │  │  │  │  ├─ MainFlutterWindow.swift
│  │  │  │     │  │  │  │  └─ Release.entitlements
│  │  │  │     │  │  │  ├─ Runner.xcodeproj
│  │  │  │     │  │  │  │  ├─ project.pbxproj
│  │  │  │     │  │  │  │  ├─ project.xcworkspace
│  │  │  │     │  │  │  │  │  └─ xcshareddata
│  │  │  │     │  │  │  │  │     └─ IDEWorkspaceChecks.plist
│  │  │  │     │  │  │  │  └─ xcshareddata
│  │  │  │     │  │  │  │     └─ xcschemes
│  │  │  │     │  │  │  │        └─ Runner.xcscheme
│  │  │  │     │  │  │  └─ Runner.xcworkspace
│  │  │  │     │  │  │     ├─ contents.xcworkspacedata
│  │  │  │     │  │  │     └─ xcshareddata
│  │  │  │     │  │  │        └─ IDEWorkspaceChecks.plist
│  │  │  │     │  │  ├─ pubspec.yaml
│  │  │  │     │  │  ├─ README.md
│  │  │  │     │  │  └─ windows
│  │  │  │     │  │     ├─ CMakeLists.txt
│  │  │  │     │  │     ├─ flutter
│  │  │  │     │  │     │  └─ CMakeLists.txt
│  │  │  │     │  │     └─ runner
│  │  │  │     │  │        ├─ CMakeLists.txt
│  │  │  │     │  │        ├─ flutter_window.cpp
│  │  │  │     │  │        ├─ flutter_window.h
│  │  │  │     │  │        ├─ main.cpp
│  │  │  │     │  │        ├─ resource.h
│  │  │  │     │  │        ├─ resources
│  │  │  │     │  │        │  └─ app_icon.ico
│  │  │  │     │  │        ├─ runner.exe.manifest
│  │  │  │     │  │        ├─ Runner.rc
│  │  │  │     │  │        ├─ utils.cpp
│  │  │  │     │  │        ├─ utils.h
│  │  │  │     │  │        ├─ win32_window.cpp
│  │  │  │     │  │        └─ win32_window.h
│  │  │  │     │  ├─ ffigen.yaml
│  │  │  │     │  ├─ ffigen_exts.yaml
│  │  │  │     │  ├─ java
│  │  │  │     │  │  ├─ build.gradle.kts
│  │  │  │     │  │  ├─ gradle
│  │  │  │     │  │  │  ├─ libs.versions.toml
│  │  │  │     │  │  │  └─ wrapper
│  │  │  │     │  │  │     ├─ gradle-wrapper.jar
│  │  │  │     │  │  │     └─ gradle-wrapper.properties
│  │  │  │     │  │  ├─ gradlew
│  │  │  │     │  │  ├─ gradlew.bat
│  │  │  │     │  │  ├─ README.md
│  │  │  │     │  │  ├─ settings.gradle.kts
│  │  │  │     │  │  ├─ src
│  │  │  │     │  │  │  └─ main
│  │  │  │     │  │  │     └─ java
│  │  │  │     │  │  │        └─ com
│  │  │  │     │  │  │           └─ github
│  │  │  │     │  │  │              └─ dart_lang
│  │  │  │     │  │  │                 └─ jni
│  │  │  │     │  │  │                    ├─ JniUtils.java
│  │  │  │     │  │  │                    ├─ PortCleaner.java
│  │  │  │     │  │  │                    ├─ PortContinuation.java
│  │  │  │     │  │  │                    └─ PortProxyBuilder.java
│  │  │  │     │  │  └─ ~
│  │  │  │     │  │     └─ dev
│  │  │  │     │  │        ├─ native
│  │  │  │     │  │        │  └─ native
│  │  │  │     │  │        │     └─ pkgs
│  │  │  │     │  │        │        └─ jnigen
│  │  │  │     │  │        │           └─ example
│  │  │  │     │  │        │              └─ pdfbox_plugin
│  │  │  │     │  │        │                 └─ dart_example
│  │  │  │     │  │        └─ native2
│  │  │  │     │  │           └─ pkgs
│  │  │  │     │  │              └─ jnigen
│  │  │  │     │  │                 └─ example
│  │  │  │     │  │                    └─ pdfbox_plugin
│  │  │  │     │  │                       └─ dart_example
│  │  │  │     │  ├─ lib
│  │  │  │     │  │  ├─ jni.dart
│  │  │  │     │  │  ├─ jni_symbols.yaml
│  │  │  │     │  │  ├─ src
│  │  │  │     │  │  │  ├─ accessors.dart
│  │  │  │     │  │  │  ├─ build_util
│  │  │  │     │  │  │  │  └─ build_util.dart
│  │  │  │     │  │  │  ├─ core_bindings.dart
│  │  │  │     │  │  │  ├─ errors.dart
│  │  │  │     │  │  │  ├─ jarray.dart
│  │  │  │     │  │  │  ├─ jclass.dart
│  │  │  │     │  │  │  ├─ jimplementer.dart
│  │  │  │     │  │  │  ├─ jni.dart
│  │  │  │     │  │  │  ├─ jobject.dart
│  │  │  │     │  │  │  ├─ jprimitives.dart
│  │  │  │     │  │  │  ├─ jreference.dart
│  │  │  │     │  │  │  ├─ jvalues.dart
│  │  │  │     │  │  │  ├─ kotlin.dart
│  │  │  │     │  │  │  ├─ lang
│  │  │  │     │  │  │  │  ├─ jboolean.dart
│  │  │  │     │  │  │  │  ├─ jbyte.dart
│  │  │  │     │  │  │  │  ├─ jcharacter.dart
│  │  │  │     │  │  │  │  ├─ jdouble.dart
│  │  │  │     │  │  │  │  ├─ jfloat.dart
│  │  │  │     │  │  │  │  ├─ jinteger.dart
│  │  │  │     │  │  │  │  ├─ jlong.dart
│  │  │  │     │  │  │  │  ├─ jnumber.dart
│  │  │  │     │  │  │  │  ├─ jshort.dart
│  │  │  │     │  │  │  │  ├─ jstring.dart
│  │  │  │     │  │  │  │  └─ lang.dart
│  │  │  │     │  │  │  ├─ method_invocation.dart
│  │  │  │     │  │  │  ├─ nio
│  │  │  │     │  │  │  │  ├─ jbuffer.dart
│  │  │  │     │  │  │  │  ├─ jbyte_buffer.dart
│  │  │  │     │  │  │  │  └─ nio.dart
│  │  │  │     │  │  │  ├─ primitive_jarrays.dart
│  │  │  │     │  │  │  ├─ third_party
│  │  │  │     │  │  │  │  ├─ generated_bindings.dart
│  │  │  │     │  │  │  │  ├─ global_env_extensions.dart
│  │  │  │     │  │  │  │  └─ jni_bindings_generated.dart
│  │  │  │     │  │  │  ├─ types.dart
│  │  │  │     │  │  │  ├─ util
│  │  │  │     │  │  │  │  ├─ jiterator.dart
│  │  │  │     │  │  │  │  ├─ jlist.dart
│  │  │  │     │  │  │  │  ├─ jmap.dart
│  │  │  │     │  │  │  │  ├─ jset.dart
│  │  │  │     │  │  │  │  └─ util.dart
│  │  │  │     │  │  │  └─ version_check.dart
│  │  │  │     │  │  └─ _internal.dart
│  │  │  │     │  ├─ LICENSE
│  │  │  │     │  ├─ linux
│  │  │  │     │  │  └─ CMakeLists.txt
│  │  │  │     │  ├─ pubspec.yaml
│  │  │  │     │  ├─ README.md
│  │  │  │     │  ├─ src
│  │  │  │     │  │  ├─ CMakeLists.txt
│  │  │  │     │  │  ├─ dartjni.c
│  │  │  │     │  │  ├─ dartjni.h
│  │  │  │     │  │  ├─ include
│  │  │  │     │  │  │  ├─ analyze_snapshot_api.h
│  │  │  │     │  │  │  ├─ bin
│  │  │  │     │  │  │  │  ├─ dart_io_api.h
│  │  │  │     │  │  │  │  └─ native_assets_api.h
│  │  │  │     │  │  │  ├─ BUILD.gn
│  │  │  │     │  │  │  ├─ dart_api.h
│  │  │  │     │  │  │  ├─ dart_api_dl.c
│  │  │  │     │  │  │  ├─ dart_api_dl.h
│  │  │  │     │  │  │  ├─ dart_embedder_api.h
│  │  │  │     │  │  │  ├─ dart_native_api.h
│  │  │  │     │  │  │  ├─ dart_tools_api.h
│  │  │  │     │  │  │  ├─ dart_version.h
│  │  │  │     │  │  │  └─ internal
│  │  │  │     │  │  │     └─ dart_api_dl_impl.h
│  │  │  │     │  │  ├─ jni_constants.h
│  │  │  │     │  │  ├─ README.md
│  │  │  │     │  │  └─ third_party
│  │  │  │     │  │     ├─ global_jni_env.c
│  │  │  │     │  │     └─ global_jni_env.h
│  │  │  │     │  ├─ test
│  │  │  │     │  │  ├─ boxed_test.dart
│  │  │  │     │  │  ├─ debug_release_test.dart
│  │  │  │     │  │  ├─ exception_test.dart
│  │  │  │     │  │  ├─ global_env_test.dart
│  │  │  │     │  │  ├─ isolate_test.dart
│  │  │  │     │  │  ├─ jarray_test.dart
│  │  │  │     │  │  ├─ jbyte_buffer_test.dart
│  │  │  │     │  │  ├─ jlist_test.dart
│  │  │  │     │  │  ├─ jmap_test.dart
│  │  │  │     │  │  ├─ jobject_test.dart
│  │  │  │     │  │  ├─ jset_test.dart
│  │  │  │     │  │  ├─ jstring_test.dart
│  │  │  │     │  │  ├─ load_test.dart
│  │  │  │     │  │  ├─ test_util
│  │  │  │     │  │  │  └─ test_util.dart
│  │  │  │     │  │  ├─ version_check
│  │  │  │     │  │  │  ├─ fail_major.dart
│  │  │  │     │  │  │  ├─ fail_minor.dart
│  │  │  │     │  │  │  └─ pass.dart
│  │  │  │     │  │  └─ version_check_test.dart
│  │  │  │     │  ├─ third_party
│  │  │  │     │  │  └─ jni.h
│  │  │  │     │  ├─ tool
│  │  │  │     │  │  ├─ generate_ffi_bindings.dart
│  │  │  │     │  │  ├─ generate_ide_files.dart
│  │  │  │     │  │  ├─ generate_jni_bindings.dart
│  │  │  │     │  │  ├─ generate_primitive_arrays.dart
│  │  │  │     │  │  └─ wrapper_generators
│  │  │  │     │  │     ├─ ffigen_util.dart
│  │  │  │     │  │     ├─ generate_c_extensions.dart
│  │  │  │     │  │     ├─ generate_dart_extensions.dart
│  │  │  │     │  │     ├─ generate_helper_functions.dart
│  │  │  │     │  │     └─ logging.dart
│  │  │  │     │  └─ windows
│  │  │  │     │     └─ CMakeLists.txt
│  │  │  │     ├─ path_provider_linux
│  │  │  │     │  ├─ AUTHORS
│  │  │  │     │  ├─ CHANGELOG.md
│  │  │  │     │  ├─ example
│  │  │  │     │  │  ├─ integration_test
│  │  │  │     │  │  │  └─ path_provider_test.dart
│  │  │  │     │  │  ├─ lib
│  │  │  │     │  │  │  └─ main.dart
│  │  │  │     │  │  ├─ linux
│  │  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │  │     │  │  │  ├─ flutter
│  │  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │  │     │  │  │  ├─ main.cc
│  │  │  │     │  │  │  ├─ my_application.cc
│  │  │  │     │  │  │  └─ my_application.h
│  │  │  │     │  │  ├─ pubspec.yaml
│  │  │  │     │  │  ├─ README.md
│  │  │  │     │  │  └─ test_driver
│  │  │  │     │  │     └─ integration_test.dart
│  │  │  │     │  ├─ lib
│  │  │  │     │  │  ├─ path_provider_linux.dart
│  │  │  │     │  │  └─ src
│  │  │  │     │  │     ├─ get_application_id.dart
│  │  │  │     │  │     ├─ get_application_id_real.dart
│  │  │  │     │  │     ├─ get_application_id_stub.dart
│  │  │  │     │  │     └─ path_provider_linux.dart
│  │  │  │     │  ├─ LICENSE
│  │  │  │     │  ├─ pubspec.yaml
│  │  │  │     │  ├─ README.md
│  │  │  │     │  └─ test
│  │  │  │     │     ├─ get_application_id_test.dart
│  │  │  │     │     └─ path_provider_linux_test.dart
│  │  │  │     └─ printing
│  │  │  │        ├─ analysis_options.yaml
│  │  │  │        ├─ android
│  │  │  │        │  ├─ build.gradle
│  │  │  │        │  ├─ settings.gradle
│  │  │  │        │  └─ src
│  │  │  │        │     └─ main
│  │  │  │        │        ├─ AndroidManifest.xml
│  │  │  │        │        ├─ java
│  │  │  │        │        │  ├─ android
│  │  │  │        │        │  │  └─ print
│  │  │  │        │        │  │     └─ PdfConvert.java
│  │  │  │        │        │  └─ net
│  │  │  │        │        │     └─ nfet
│  │  │  │        │        │        └─ flutter
│  │  │  │        │        │           └─ printing
│  │  │  │        │        │              ├─ PrintFileProvider.java
│  │  │  │        │        │              ├─ PrintingHandler.java
│  │  │  │        │        │              ├─ PrintingJob.java
│  │  │  │        │        │              └─ PrintingPlugin.java
│  │  │  │        │        └─ res
│  │  │  │        │           └─ xml
│  │  │  │        │              └─ flutter_printing_file_paths.xml
│  │  │  │        ├─ CHANGELOG.md
│  │  │  │        ├─ CONTRIBUTING.md
│  │  │  │        ├─ example
│  │  │  │        │  ├─ lib
│  │  │  │        │  │  └─ main.dart
│  │  │  │        │  └─ pubspec.yaml
│  │  │  │        ├─ example.png
│  │  │  │        ├─ ios
│  │  │  │        │  ├─ Classes
│  │  │  │        │  │  ├─ CustomPrintPaper.swift
│  │  │  │        │  │  ├─ PrintingPlugin.m
│  │  │  │        │  │  ├─ PrintingPlugin.swift
│  │  │  │        │  │  └─ PrintJob.swift
│  │  │  │        │  └─ printing.podspec
│  │  │  │        ├─ lib
│  │  │  │        │  ├─ printing.dart
│  │  │  │        │  ├─ printing_web.dart
│  │  │  │        │  └─ src
│  │  │  │        │     ├─ asset_utils.dart
│  │  │  │        │     ├─ cache.dart
│  │  │  │        │     ├─ callback.dart
│  │  │  │        │     ├─ fonts
│  │  │  │        │     │  ├─ font.dart
│  │  │  │        │     │  ├─ gfonts.dart
│  │  │  │        │     │  └─ manifest.dart
│  │  │  │        │     ├─ interface.dart
│  │  │  │        │     ├─ method_channel.dart
│  │  │  │        │     ├─ method_channel_ffi.dart
│  │  │  │        │     ├─ method_channel_js.dart
│  │  │  │        │     ├─ mutex.dart
│  │  │  │        │     ├─ output_type.dart
│  │  │  │        │     ├─ pdfjs.dart
│  │  │  │        │     ├─ platform_js.dart
│  │  │  │        │     ├─ platform_os.dart
│  │  │  │        │     ├─ preview
│  │  │  │        │     │  ├─ actions.dart
│  │  │  │        │     │  ├─ action_bar_theme.dart
│  │  │  │        │     │  ├─ controller.dart
│  │  │  │        │     │  ├─ custom.dart
│  │  │  │        │     │  ├─ page.dart
│  │  │  │        │     │  ├─ pdf_preview.dart
│  │  │  │        │     │  └─ raster.dart
│  │  │  │        │     ├─ printer.dart
│  │  │  │        │     ├─ printing.dart
│  │  │  │        │     ├─ printing_info.dart
│  │  │  │        │     ├─ print_job.dart
│  │  │  │        │     └─ raster.dart
│  │  │  │        ├─ LICENSE
│  │  │  │        ├─ linux
│  │  │  │        │  ├─ CMakeLists.txt
│  │  │  │        │  ├─ include
│  │  │  │        │  │  └─ printing
│  │  │  │        │  │     └─ printing_plugin.h
│  │  │  │        │  ├─ printing_plugin.cc
│  │  │  │        │  ├─ print_job.cc
│  │  │  │        │  └─ print_job.h
│  │  │  │        ├─ macos
│  │  │  │        │  ├─ Classes
│  │  │  │        │  │  ├─ PrintingPlugin.m
│  │  │  │        │  │  ├─ PrintingPlugin.swift
│  │  │  │        │  │  └─ PrintJob.swift
│  │  │  │        │  └─ printing.podspec
│  │  │  │        ├─ pubspec.yaml
│  │  │  │        ├─ README.md
│  │  │  │        ├─ test
│  │  │  │        │  ├─ document_test.dart
│  │  │  │        │  ├─ info_test.dart
│  │  │  │        │  ├─ printing_test.dart
│  │  │  │        │  └─ raster_test.dart
│  │  │  │        └─ windows
│  │  │  │           ├─ CMakeLists.txt
│  │  │  │           ├─ DownloadProject.cmake
│  │  │  │           ├─ DownloadProject.CMakeLists.cmake.in
│  │  │  │           ├─ include
│  │  │  │           │  └─ printing
│  │  │  │           │     └─ printing_plugin.h
│  │  │  │           ├─ printing.cpp
│  │  │  │           ├─ printing.h
│  │  │  │           ├─ printing_plugin.cpp
│  │  │  │           ├─ print_job.cpp
│  │  │  │           └─ print_job.h
│  │  │  ├─ generated_plugins.cmake
│  │  │  ├─ generated_plugin_registrant.cc
│  │  │  └─ generated_plugin_registrant.h
│  │  └─ runner
│  │     ├─ CMakeLists.txt
│  │     ├─ main.cc
│  │     ├─ my_application.cc
│  │     └─ my_application.h
│  ├─ macos
│  │  ├─ Flutter
│  │  │  ├─ ephemeral
│  │  │  │  ├─ Flutter-Generated.xcconfig
│  │  │  │  ├─ flutter_export_environment.sh
│  │  │  │  └─ flutter_native_integration.env
│  │  │  ├─ Flutter-Debug.xcconfig
│  │  │  ├─ Flutter-Release.xcconfig
│  │  │  └─ GeneratedPluginRegistrant.swift
│  │  ├─ Runner
│  │  │  ├─ AppDelegate.swift
│  │  │  ├─ Assets.xcassets
│  │  │  │  └─ AppIcon.appiconset
│  │  │  │     ├─ app_icon_1024.png
│  │  │  │     ├─ app_icon_128.png
│  │  │  │     ├─ app_icon_16.png
│  │  │  │     ├─ app_icon_256.png
│  │  │  │     ├─ app_icon_32.png
│  │  │  │     ├─ app_icon_512.png
│  │  │  │     ├─ app_icon_64.png
│  │  │  │     └─ Contents.json
│  │  │  ├─ Base.lproj
│  │  │  │  └─ MainMenu.xib
│  │  │  ├─ Configs
│  │  │  │  ├─ AppInfo.xcconfig
│  │  │  │  ├─ Debug.xcconfig
│  │  │  │  ├─ Release.xcconfig
│  │  │  │  └─ Warnings.xcconfig
│  │  │  ├─ DebugProfile.entitlements
│  │  │  ├─ Info.plist
│  │  │  ├─ MainFlutterWindow.swift
│  │  │  └─ Release.entitlements
│  │  ├─ Runner.xcodeproj
│  │  │  ├─ project.pbxproj
│  │  │  ├─ project.xcworkspace
│  │  │  │  └─ xcshareddata
│  │  │  │     └─ IDEWorkspaceChecks.plist
│  │  │  └─ xcshareddata
│  │  │     └─ xcschemes
│  │  │        └─ Runner.xcscheme
│  │  ├─ Runner.xcworkspace
│  │  │  ├─ contents.xcworkspacedata
│  │  │  └─ xcshareddata
│  │  │     └─ IDEWorkspaceChecks.plist
│  │  └─ RunnerTests
│  │     └─ RunnerTests.swift
│  ├─ native_splash.yaml
│  ├─ pubspec.lock
│  ├─ pubspec.yaml
│  ├─ README.md
│  ├─ scripts
│  │  └─ fix-adb.ps1
│  ├─ test
│  │  └─ widget_test.dart
│  └─ web
│     ├─ favicon.png
│     ├─ icons
│     │  ├─ Icon-192.png
│     │  ├─ Icon-512.png
│     │  ├─ Icon-maskable-192.png
│     │  └─ Icon-maskable-512.png
│     ├─ index.html
│     ├─ manifest.json
│     └─ splash
│        └─ img
│           ├─ branding-1x.png
│           ├─ branding-2x.png
│           ├─ branding-3x.png
│           ├─ branding-4x.png
│           ├─ branding-dark-1x.png
│           ├─ branding-dark-2x.png
│           ├─ branding-dark-3x.png
│           ├─ branding-dark-4x.png
│           ├─ dark-1x.png
│           ├─ dark-2x.png
│           ├─ dark-3x.png
│           ├─ dark-4x.png
│           ├─ light-1x.png
│           ├─ light-2x.png
│           ├─ light-3x.png
│           └─ light-4x.png
└─ README.md

```