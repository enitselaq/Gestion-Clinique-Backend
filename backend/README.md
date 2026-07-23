
```
backend
├─ clinic_backend
│  ├─ asgi.py
│  ├─ settings.py
│  ├─ urls.py
│  ├─ wsgi.py
│  └─ __init__.py
├─ core
│  ├─ admin.py
│  ├─ apps.py
│  ├─ migrations
│  │  ├─ 0001_initial.py
│  │  ├─ 0002_alter_patient_sexe.py
│  │  ├─ 0003_rendezvous_medecin_alter_patient_sexe_and_more.py
│  │  ├─ 0004_receptionniste_alter_rendezvous_options_and_more.py
│  │  ├─ 0005_notification.py
│  │  ├─ 0006_alter_rendezvous_statut.py
│  │  └─ __init__.py
│  ├─ models.py
│  ├─ permissions.py
│  ├─ serializers.py
│  ├─ tests.py
│  ├─ urls.py
│  ├─ views.py
│  └─ __init__.py
├─ manage.py
├─ manual_api_test.py
├─ requirements.txt
└─ staticfiles
   ├─ admin
   │  ├─ css
   │  │  ├─ autocomplete.css
   │  │  ├─ base.css
   │  │  ├─ changelists.css
   │  │  ├─ dark_mode.css
   │  │  ├─ dashboard.css
   │  │  ├─ forms.css
   │  │  ├─ login.css
   │  │  ├─ nav_sidebar.css
   │  │  ├─ responsive.css
   │  │  ├─ responsive_rtl.css
   │  │  ├─ rtl.css
   │  │  ├─ unusable_password_field.css
   │  │  ├─ vendor
   │  │  │  └─ select2
   │  │  │     ├─ LICENSE-SELECT2.md
   │  │  │     ├─ select2.css
   │  │  │     └─ select2.min.css
   │  │  └─ widgets.css
   │  ├─ img
   │  │  ├─ calendar-icons.svg
   │  │  ├─ icon-addlink.svg
   │  │  ├─ icon-alert-dark.svg
   │  │  ├─ icon-alert.svg
   │  │  ├─ icon-calendar.svg
   │  │  ├─ icon-changelink.svg
   │  │  ├─ icon-clock.svg
   │  │  ├─ icon-debug-dark.svg
   │  │  ├─ icon-debug.svg
   │  │  ├─ icon-deletelink.svg
   │  │  ├─ icon-hidelink.svg
   │  │  ├─ icon-info-dark.svg
   │  │  ├─ icon-info.svg
   │  │  ├─ icon-no-dark.svg
   │  │  ├─ icon-no.svg
   │  │  ├─ icon-unknown-alt.svg
   │  │  ├─ icon-unknown.svg
   │  │  ├─ icon-viewlink.svg
   │  │  ├─ icon-yes-dark.svg
   │  │  ├─ icon-yes.svg
   │  │  ├─ inline-delete.svg
   │  │  ├─ README.md
   │  │  ├─ search.svg
   │  │  ├─ selector-icons.svg
   │  │  ├─ sorting-icons.svg
   │  │  ├─ tooltag-add.svg
   │  │  └─ tooltag-arrowright.svg
   │  └─ js
   │     ├─ actions.js
   │     ├─ admin
   │     │  ├─ DateTimeShortcuts.js
   │     │  └─ RelatedObjectLookups.js
   │     ├─ autocomplete.js
   │     ├─ calendar.js
   │     ├─ cancel.js
   │     ├─ change_form.js
   │     ├─ core.js
   │     ├─ filters.js
   │     ├─ inlines.js
   │     ├─ jquery.init.js
   │     ├─ nav_sidebar.js
   │     ├─ popup_response.js
   │     ├─ prepopulate.js
   │     ├─ prepopulate_init.js
   │     ├─ SelectBox.js
   │     ├─ SelectFilter2.js
   │     ├─ theme.js
   │     ├─ urlify.js
   │     └─ vendor
   │        ├─ jquery
   │        │  ├─ jquery.js
   │        │  ├─ jquery.min.js
   │        │  └─ LICENSE.txt
   │        ├─ select2
   │        │  ├─ i18n
   │        │  │  ├─ af.js
   │        │  │  ├─ ar.js
   │        │  │  ├─ az.js
   │        │  │  ├─ bg.js
   │        │  │  ├─ bn.js
   │        │  │  ├─ bs.js
   │        │  │  ├─ ca.js
   │        │  │  ├─ cs.js
   │        │  │  ├─ da.js
   │        │  │  ├─ de.js
   │        │  │  ├─ dsb.js
   │        │  │  ├─ el.js
   │        │  │  ├─ en.js
   │        │  │  ├─ es.js
   │        │  │  ├─ et.js
   │        │  │  ├─ eu.js
   │        │  │  ├─ fa.js
   │        │  │  ├─ fi.js
   │        │  │  ├─ fr.js
   │        │  │  ├─ gl.js
   │        │  │  ├─ he.js
   │        │  │  ├─ hi.js
   │        │  │  ├─ hr.js
   │        │  │  ├─ hsb.js
   │        │  │  ├─ hu.js
   │        │  │  ├─ hy.js
   │        │  │  ├─ id.js
   │        │  │  ├─ is.js
   │        │  │  ├─ it.js
   │        │  │  ├─ ja.js
   │        │  │  ├─ ka.js
   │        │  │  ├─ km.js
   │        │  │  ├─ ko.js
   │        │  │  ├─ lt.js
   │        │  │  ├─ lv.js
   │        │  │  ├─ mk.js
   │        │  │  ├─ ms.js
   │        │  │  ├─ nb.js
   │        │  │  ├─ ne.js
   │        │  │  ├─ nl.js
   │        │  │  ├─ pl.js
   │        │  │  ├─ ps.js
   │        │  │  ├─ pt-BR.js
   │        │  │  ├─ pt.js
   │        │  │  ├─ ro.js
   │        │  │  ├─ ru.js
   │        │  │  ├─ sk.js
   │        │  │  ├─ sl.js
   │        │  │  ├─ sq.js
   │        │  │  ├─ sr-Cyrl.js
   │        │  │  ├─ sr.js
   │        │  │  ├─ sv.js
   │        │  │  ├─ th.js
   │        │  │  ├─ tk.js
   │        │  │  ├─ tr.js
   │        │  │  ├─ uk.js
   │        │  │  ├─ vi.js
   │        │  │  ├─ zh-CN.js
   │        │  │  └─ zh-TW.js
   │        │  ├─ LICENSE.md
   │        │  ├─ select2.full.js
   │        │  └─ select2.full.min.js
   │        └─ xregexp
   │           ├─ LICENSE.txt
   │           ├─ xregexp.js
   │           └─ xregexp.min.js
   ├─ jazzmin
   │  ├─ css
   │  │  ├─ main.css
   │  │  └─ main.css.backup
   │  ├─ img
   │  │  ├─ calendar-icons.svg
   │  │  ├─ default-log.svg
   │  │  ├─ default.jpg
   │  │  ├─ icon-calendar.svg
   │  │  ├─ icon-changelink.svg
   │  │  └─ selector-icons.svg
   │  ├─ js
   │  │  ├─ change_form.js
   │  │  ├─ change_list.js
   │  │  ├─ main.js
   │  │  ├─ related-modal.js
   │  │  └─ ui-builder.js
   │  └─ plugins
   │     └─ bootstrap-show-modal
   │        └─ bootstrap-show-modal.min.js
   ├─ rest_framework
   │  ├─ css
   │  │  ├─ bootstrap-theme.min.css
   │  │  ├─ bootstrap-theme.min.css.map
   │  │  ├─ bootstrap-tweaks.css
   │  │  ├─ bootstrap.min.css
   │  │  ├─ bootstrap.min.css.map
   │  │  ├─ default.css
   │  │  ├─ font-awesome-4.0.3.css
   │  │  └─ prettify.css
   │  ├─ docs
   │  │  ├─ css
   │  │  │  ├─ base.css
   │  │  │  ├─ highlight.css
   │  │  │  └─ jquery.json-view.min.css
   │  │  ├─ img
   │  │  │  ├─ favicon.ico
   │  │  │  └─ grid.png
   │  │  └─ js
   │  │     ├─ api.js
   │  │     ├─ highlight.pack.js
   │  │     └─ jquery.json-view.min.js
   │  ├─ fonts
   │  │  ├─ fontawesome-webfont.eot
   │  │  ├─ fontawesome-webfont.svg
   │  │  ├─ fontawesome-webfont.ttf
   │  │  ├─ fontawesome-webfont.woff
   │  │  ├─ glyphicons-halflings-regular.eot
   │  │  ├─ glyphicons-halflings-regular.svg
   │  │  ├─ glyphicons-halflings-regular.ttf
   │  │  ├─ glyphicons-halflings-regular.woff
   │  │  └─ glyphicons-halflings-regular.woff2
   │  ├─ img
   │  │  ├─ glyphicons-halflings-white.png
   │  │  ├─ glyphicons-halflings.png
   │  │  └─ grid.png
   │  └─ js
   │     ├─ ajax-form.js
   │     ├─ bootstrap.min.js
   │     ├─ coreapi-0.1.1.js
   │     ├─ csrf.js
   │     ├─ default.js
   │     ├─ jquery-3.7.1.min.js
   │     ├─ load-ajax-form.js
   │     └─ prettify-min.js
   ├─ silk
   │  ├─ css
   │  │  ├─ components
   │  │  │  ├─ cell.css
   │  │  │  ├─ colors.css
   │  │  │  ├─ fonts.css
   │  │  │  ├─ heading.css
   │  │  │  ├─ numeric.css
   │  │  │  ├─ row.css
   │  │  │  └─ summary.css
   │  │  └─ pages
   │  │     ├─ base.css
   │  │     ├─ clear_db.css
   │  │     ├─ cprofile.css
   │  │     ├─ detail_base.css
   │  │     ├─ profile_detail.css
   │  │     ├─ profiling.css
   │  │     ├─ raw.css
   │  │     ├─ request.css
   │  │     ├─ requests.css
   │  │     ├─ root_base.css
   │  │     ├─ sql.css
   │  │     ├─ sql_detail.css
   │  │     └─ summary.css
   │  ├─ favicon-16x16.png
   │  ├─ favicon-32x32.png
   │  ├─ filter.png
   │  ├─ filter2.png
   │  ├─ fonts
   │  │  ├─ fantasque
   │  │  │  ├─ FantasqueSansMono-Bold.woff
   │  │  │  ├─ FantasqueSansMono-BoldItalic.woff
   │  │  │  ├─ FantasqueSansMono-RegItalic.woff
   │  │  │  └─ FantasqueSansMono-Regular.woff
   │  │  ├─ fira
   │  │  │  ├─ FiraSans-Bold.woff
   │  │  │  ├─ FiraSans-BoldItalic.woff
   │  │  │  ├─ FiraSans-Light.woff
   │  │  │  ├─ FiraSans-LightItalic.woff
   │  │  │  ├─ FiraSans-Medium.woff
   │  │  │  ├─ FiraSans-MediumItalic.woff
   │  │  │  ├─ FiraSans-Regular.woff
   │  │  │  └─ FiraSans-RegularItalic.woff
   │  │  ├─ glyphicons-halflings-regular.eot
   │  │  ├─ glyphicons-halflings-regular.svg
   │  │  ├─ glyphicons-halflings-regular.ttf
   │  │  ├─ glyphicons-halflings-regular.woff
   │  │  └─ glyphicons-halflings-regular.woff2
   │  ├─ js
   │  │  ├─ components
   │  │  │  ├─ cell.js
   │  │  │  └─ filters.js
   │  │  └─ pages
   │  │     ├─ base.js
   │  │     ├─ clear_db.js
   │  │     ├─ detail_base.js
   │  │     ├─ profile_detail.js
   │  │     ├─ profiling.js
   │  │     ├─ raw.js
   │  │     ├─ request.js
   │  │     ├─ requests.js
   │  │     ├─ root_base.js
   │  │     ├─ sql.js
   │  │     ├─ sql_detail.js
   │  │     └─ summary.js
   │  └─ lib
   │     ├─ bootstrap-datetimepicker.min.css
   │     ├─ bootstrap-datetimepicker.min.js
   │     ├─ bootstrap-theme.min.css
   │     ├─ bootstrap.min.css
   │     ├─ bootstrap.min.js
   │     ├─ highlight
   │     │  ├─ foundation.css
   │     │  └─ highlight.pack.js
   │     ├─ images
   │     │  ├─ animated-overlay.gif
   │     │  ├─ ui-bg_diagonals-thick_18_b81900_40x40.png
   │     │  ├─ ui-bg_diagonals-thick_20_666666_40x40.png
   │     │  ├─ ui-bg_flat_10_000000_40x100.png
   │     │  ├─ ui-bg_glass_100_f6f6f6_1x400.png
   │     │  ├─ ui-bg_glass_100_fdf5ce_1x400.png
   │     │  ├─ ui-bg_glass_55_fbf9ee_1x400.png
   │     │  ├─ ui-bg_glass_65_ffffff_1x400.png
   │     │  ├─ ui-bg_glass_75_dadada_1x400.png
   │     │  ├─ ui-bg_glass_75_e6e6e6_1x400.png
   │     │  ├─ ui-bg_glass_95_fef1ec_1x400.png
   │     │  ├─ ui-bg_gloss-wave_35_f6a828_500x100.png
   │     │  ├─ ui-bg_highlight-soft_100_eeeeee_1x100.png
   │     │  ├─ ui-bg_highlight-soft_75_cccccc_1x100.png
   │     │  ├─ ui-bg_highlight-soft_75_ffe45c_1x100.png
   │     │  ├─ ui-icons_222222_256x240.png
   │     │  ├─ ui-icons_228ef1_256x240.png
   │     │  ├─ ui-icons_2e83ff_256x240.png
   │     │  ├─ ui-icons_444444_256x240.png
   │     │  ├─ ui-icons_454545_256x240.png
   │     │  ├─ ui-icons_555555_256x240.png
   │     │  ├─ ui-icons_777620_256x240.png
   │     │  ├─ ui-icons_777777_256x240.png
   │     │  ├─ ui-icons_888888_256x240.png
   │     │  ├─ ui-icons_cc0000_256x240.png
   │     │  ├─ ui-icons_cd0a0a_256x240.png
   │     │  ├─ ui-icons_ef8c08_256x240.png
   │     │  ├─ ui-icons_ffd27a_256x240.png
   │     │  └─ ui-icons_ffffff_256x240.png
   │     ├─ jquery-3.6.0.min.js
   │     ├─ jquery-ui-1.13.1.min.css
   │     ├─ jquery-ui-1.13.1.min.js
   │     ├─ jquery-ui-1.13.2.min.css
   │     ├─ jquery-ui-1.13.2.min.js
   │     ├─ jquery.datetimepicker.css
   │     ├─ jquery.datetimepicker.js
   │     ├─ sortable.js
   │     ├─ svg-pan-zoom.min.js
   │     └─ viz-lite.js
   └─ vendor
      ├─ adminlte
      │  ├─ css
      │  │  ├─ adminlte.min.css
      │  │  └─ adminlte.min.css.map
      │  ├─ img
      │  │  ├─ AdminLTELogo.png
      │  │  ├─ icons.png
      │  │  └─ user2-160x160.jpg
      │  └─ js
      │     ├─ adminlte.min.js
      │     └─ adminlte.min.js.map
      ├─ bootstrap
      │  └─ js
      │     ├─ bootstrap.bundle.min.js
      │     ├─ bootstrap.min.js
      │     └─ bootstrap.min.js.map
      ├─ bootswatch
      │  ├─ brite
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ cerulean
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ cosmo
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ cyborg
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ darkly
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ default
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ flatly
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ journal
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ litera
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ lumen
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ lux
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ materia
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ minty
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ morph
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ pulse
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ quartz
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ sandstone
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ simplex
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ sketchy
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ slate
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ solar
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ spacelab
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ superhero
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ united
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ vapor
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ yeti
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  └─ zephyr
      │     ├─ bootstrap.min.css
      │     └─ bootstrap.min.css.map
      ├─ fontawesome-free
      │  ├─ css
      │  │  └─ all.min.css
      │  └─ webfonts
      │     ├─ fa-brands-400.ttf
      │     ├─ fa-brands-400.woff2
      │     ├─ fa-regular-400.ttf
      │     ├─ fa-regular-400.woff2
      │     ├─ fa-solid-900.ttf
      │     ├─ fa-solid-900.woff2
      │     ├─ fa-v4compatibility.ttf
      │     └─ fa-v4compatibility.woff2
      └─ select2
         ├─ css
         │  └─ select2.min.css
         └─ js
            └─ select2.min.js

```
```
backend
├─ clinic_backend
│  ├─ asgi.py
│  ├─ settings.py
│  ├─ urls.py
│  ├─ wsgi.py
│  └─ __init__.py
├─ core
│  ├─ admin.py
│  ├─ apps.py
│  ├─ migrations
│  │  ├─ 0001_initial.py
│  │  ├─ 0002_alter_patient_sexe.py
│  │  ├─ 0003_rendezvous_medecin_alter_patient_sexe_and_more.py
│  │  ├─ 0004_receptionniste_alter_rendezvous_options_and_more.py
│  │  ├─ 0005_notification.py
│  │  ├─ 0006_alter_rendezvous_statut.py
│  │  └─ __init__.py
│  ├─ models.py
│  ├─ permissions.py
│  ├─ serializers.py
│  ├─ tests.py
│  ├─ urls.py
│  ├─ views.py
│  └─ __init__.py
├─ manage.py
├─ manual_api_test.py
├─ README.md
├─ requirements.txt
└─ staticfiles
   ├─ admin
   │  ├─ css
   │  │  ├─ autocomplete.css
   │  │  ├─ base.css
   │  │  ├─ changelists.css
   │  │  ├─ dark_mode.css
   │  │  ├─ dashboard.css
   │  │  ├─ forms.css
   │  │  ├─ login.css
   │  │  ├─ nav_sidebar.css
   │  │  ├─ responsive.css
   │  │  ├─ responsive_rtl.css
   │  │  ├─ rtl.css
   │  │  ├─ unusable_password_field.css
   │  │  ├─ vendor
   │  │  │  └─ select2
   │  │  │     ├─ LICENSE-SELECT2.md
   │  │  │     ├─ select2.css
   │  │  │     └─ select2.min.css
   │  │  └─ widgets.css
   │  ├─ img
   │  │  ├─ calendar-icons.svg
   │  │  ├─ icon-addlink.svg
   │  │  ├─ icon-alert-dark.svg
   │  │  ├─ icon-alert.svg
   │  │  ├─ icon-calendar.svg
   │  │  ├─ icon-changelink.svg
   │  │  ├─ icon-clock.svg
   │  │  ├─ icon-debug-dark.svg
   │  │  ├─ icon-debug.svg
   │  │  ├─ icon-deletelink.svg
   │  │  ├─ icon-hidelink.svg
   │  │  ├─ icon-info-dark.svg
   │  │  ├─ icon-info.svg
   │  │  ├─ icon-no-dark.svg
   │  │  ├─ icon-no.svg
   │  │  ├─ icon-unknown-alt.svg
   │  │  ├─ icon-unknown.svg
   │  │  ├─ icon-viewlink.svg
   │  │  ├─ icon-yes-dark.svg
   │  │  ├─ icon-yes.svg
   │  │  ├─ inline-delete.svg
   │  │  ├─ README.md
   │  │  ├─ search.svg
   │  │  ├─ selector-icons.svg
   │  │  ├─ sorting-icons.svg
   │  │  ├─ tooltag-add.svg
   │  │  └─ tooltag-arrowright.svg
   │  └─ js
   │     ├─ actions.js
   │     ├─ admin
   │     │  ├─ DateTimeShortcuts.js
   │     │  └─ RelatedObjectLookups.js
   │     ├─ autocomplete.js
   │     ├─ calendar.js
   │     ├─ cancel.js
   │     ├─ change_form.js
   │     ├─ core.js
   │     ├─ filters.js
   │     ├─ inlines.js
   │     ├─ jquery.init.js
   │     ├─ nav_sidebar.js
   │     ├─ popup_response.js
   │     ├─ prepopulate.js
   │     ├─ prepopulate_init.js
   │     ├─ SelectBox.js
   │     ├─ SelectFilter2.js
   │     ├─ theme.js
   │     ├─ urlify.js
   │     └─ vendor
   │        ├─ jquery
   │        │  ├─ jquery.js
   │        │  ├─ jquery.min.js
   │        │  └─ LICENSE.txt
   │        ├─ select2
   │        │  ├─ i18n
   │        │  │  ├─ af.js
   │        │  │  ├─ ar.js
   │        │  │  ├─ az.js
   │        │  │  ├─ bg.js
   │        │  │  ├─ bn.js
   │        │  │  ├─ bs.js
   │        │  │  ├─ ca.js
   │        │  │  ├─ cs.js
   │        │  │  ├─ da.js
   │        │  │  ├─ de.js
   │        │  │  ├─ dsb.js
   │        │  │  ├─ el.js
   │        │  │  ├─ en.js
   │        │  │  ├─ es.js
   │        │  │  ├─ et.js
   │        │  │  ├─ eu.js
   │        │  │  ├─ fa.js
   │        │  │  ├─ fi.js
   │        │  │  ├─ fr.js
   │        │  │  ├─ gl.js
   │        │  │  ├─ he.js
   │        │  │  ├─ hi.js
   │        │  │  ├─ hr.js
   │        │  │  ├─ hsb.js
   │        │  │  ├─ hu.js
   │        │  │  ├─ hy.js
   │        │  │  ├─ id.js
   │        │  │  ├─ is.js
   │        │  │  ├─ it.js
   │        │  │  ├─ ja.js
   │        │  │  ├─ ka.js
   │        │  │  ├─ km.js
   │        │  │  ├─ ko.js
   │        │  │  ├─ lt.js
   │        │  │  ├─ lv.js
   │        │  │  ├─ mk.js
   │        │  │  ├─ ms.js
   │        │  │  ├─ nb.js
   │        │  │  ├─ ne.js
   │        │  │  ├─ nl.js
   │        │  │  ├─ pl.js
   │        │  │  ├─ ps.js
   │        │  │  ├─ pt-BR.js
   │        │  │  ├─ pt.js
   │        │  │  ├─ ro.js
   │        │  │  ├─ ru.js
   │        │  │  ├─ sk.js
   │        │  │  ├─ sl.js
   │        │  │  ├─ sq.js
   │        │  │  ├─ sr-Cyrl.js
   │        │  │  ├─ sr.js
   │        │  │  ├─ sv.js
   │        │  │  ├─ th.js
   │        │  │  ├─ tk.js
   │        │  │  ├─ tr.js
   │        │  │  ├─ uk.js
   │        │  │  ├─ vi.js
   │        │  │  ├─ zh-CN.js
   │        │  │  └─ zh-TW.js
   │        │  ├─ LICENSE.md
   │        │  ├─ select2.full.js
   │        │  └─ select2.full.min.js
   │        └─ xregexp
   │           ├─ LICENSE.txt
   │           ├─ xregexp.js
   │           └─ xregexp.min.js
   ├─ jazzmin
   │  ├─ css
   │  │  ├─ main.css
   │  │  └─ main.css.backup
   │  ├─ img
   │  │  ├─ calendar-icons.svg
   │  │  ├─ default-log.svg
   │  │  ├─ default.jpg
   │  │  ├─ icon-calendar.svg
   │  │  ├─ icon-changelink.svg
   │  │  └─ selector-icons.svg
   │  ├─ js
   │  │  ├─ change_form.js
   │  │  ├─ change_list.js
   │  │  ├─ main.js
   │  │  ├─ related-modal.js
   │  │  └─ ui-builder.js
   │  └─ plugins
   │     └─ bootstrap-show-modal
   │        └─ bootstrap-show-modal.min.js
   ├─ rest_framework
   │  ├─ css
   │  │  ├─ bootstrap-theme.min.css
   │  │  ├─ bootstrap-theme.min.css.map
   │  │  ├─ bootstrap-tweaks.css
   │  │  ├─ bootstrap.min.css
   │  │  ├─ bootstrap.min.css.map
   │  │  ├─ default.css
   │  │  ├─ font-awesome-4.0.3.css
   │  │  └─ prettify.css
   │  ├─ docs
   │  │  ├─ css
   │  │  │  ├─ base.css
   │  │  │  ├─ highlight.css
   │  │  │  └─ jquery.json-view.min.css
   │  │  ├─ img
   │  │  │  ├─ favicon.ico
   │  │  │  └─ grid.png
   │  │  └─ js
   │  │     ├─ api.js
   │  │     ├─ highlight.pack.js
   │  │     └─ jquery.json-view.min.js
   │  ├─ fonts
   │  │  ├─ fontawesome-webfont.eot
   │  │  ├─ fontawesome-webfont.svg
   │  │  ├─ fontawesome-webfont.ttf
   │  │  ├─ fontawesome-webfont.woff
   │  │  ├─ glyphicons-halflings-regular.eot
   │  │  ├─ glyphicons-halflings-regular.svg
   │  │  ├─ glyphicons-halflings-regular.ttf
   │  │  ├─ glyphicons-halflings-regular.woff
   │  │  └─ glyphicons-halflings-regular.woff2
   │  ├─ img
   │  │  ├─ glyphicons-halflings-white.png
   │  │  ├─ glyphicons-halflings.png
   │  │  └─ grid.png
   │  └─ js
   │     ├─ ajax-form.js
   │     ├─ bootstrap.min.js
   │     ├─ coreapi-0.1.1.js
   │     ├─ csrf.js
   │     ├─ default.js
   │     ├─ jquery-3.7.1.min.js
   │     ├─ load-ajax-form.js
   │     └─ prettify-min.js
   ├─ silk
   │  ├─ css
   │  │  ├─ components
   │  │  │  ├─ cell.css
   │  │  │  ├─ colors.css
   │  │  │  ├─ fonts.css
   │  │  │  ├─ heading.css
   │  │  │  ├─ numeric.css
   │  │  │  ├─ row.css
   │  │  │  └─ summary.css
   │  │  └─ pages
   │  │     ├─ base.css
   │  │     ├─ clear_db.css
   │  │     ├─ cprofile.css
   │  │     ├─ detail_base.css
   │  │     ├─ profile_detail.css
   │  │     ├─ profiling.css
   │  │     ├─ raw.css
   │  │     ├─ request.css
   │  │     ├─ requests.css
   │  │     ├─ root_base.css
   │  │     ├─ sql.css
   │  │     ├─ sql_detail.css
   │  │     └─ summary.css
   │  ├─ favicon-16x16.png
   │  ├─ favicon-32x32.png
   │  ├─ filter.png
   │  ├─ filter2.png
   │  ├─ fonts
   │  │  ├─ fantasque
   │  │  │  ├─ FantasqueSansMono-Bold.woff
   │  │  │  ├─ FantasqueSansMono-BoldItalic.woff
   │  │  │  ├─ FantasqueSansMono-RegItalic.woff
   │  │  │  └─ FantasqueSansMono-Regular.woff
   │  │  ├─ fira
   │  │  │  ├─ FiraSans-Bold.woff
   │  │  │  ├─ FiraSans-BoldItalic.woff
   │  │  │  ├─ FiraSans-Light.woff
   │  │  │  ├─ FiraSans-LightItalic.woff
   │  │  │  ├─ FiraSans-Medium.woff
   │  │  │  ├─ FiraSans-MediumItalic.woff
   │  │  │  ├─ FiraSans-Regular.woff
   │  │  │  └─ FiraSans-RegularItalic.woff
   │  │  ├─ glyphicons-halflings-regular.eot
   │  │  ├─ glyphicons-halflings-regular.svg
   │  │  ├─ glyphicons-halflings-regular.ttf
   │  │  ├─ glyphicons-halflings-regular.woff
   │  │  └─ glyphicons-halflings-regular.woff2
   │  ├─ js
   │  │  ├─ components
   │  │  │  ├─ cell.js
   │  │  │  └─ filters.js
   │  │  └─ pages
   │  │     ├─ base.js
   │  │     ├─ clear_db.js
   │  │     ├─ detail_base.js
   │  │     ├─ profile_detail.js
   │  │     ├─ profiling.js
   │  │     ├─ raw.js
   │  │     ├─ request.js
   │  │     ├─ requests.js
   │  │     ├─ root_base.js
   │  │     ├─ sql.js
   │  │     ├─ sql_detail.js
   │  │     └─ summary.js
   │  └─ lib
   │     ├─ bootstrap-datetimepicker.min.css
   │     ├─ bootstrap-datetimepicker.min.js
   │     ├─ bootstrap-theme.min.css
   │     ├─ bootstrap.min.css
   │     ├─ bootstrap.min.js
   │     ├─ highlight
   │     │  ├─ foundation.css
   │     │  └─ highlight.pack.js
   │     ├─ images
   │     │  ├─ animated-overlay.gif
   │     │  ├─ ui-bg_diagonals-thick_18_b81900_40x40.png
   │     │  ├─ ui-bg_diagonals-thick_20_666666_40x40.png
   │     │  ├─ ui-bg_flat_10_000000_40x100.png
   │     │  ├─ ui-bg_glass_100_f6f6f6_1x400.png
   │     │  ├─ ui-bg_glass_100_fdf5ce_1x400.png
   │     │  ├─ ui-bg_glass_55_fbf9ee_1x400.png
   │     │  ├─ ui-bg_glass_65_ffffff_1x400.png
   │     │  ├─ ui-bg_glass_75_dadada_1x400.png
   │     │  ├─ ui-bg_glass_75_e6e6e6_1x400.png
   │     │  ├─ ui-bg_glass_95_fef1ec_1x400.png
   │     │  ├─ ui-bg_gloss-wave_35_f6a828_500x100.png
   │     │  ├─ ui-bg_highlight-soft_100_eeeeee_1x100.png
   │     │  ├─ ui-bg_highlight-soft_75_cccccc_1x100.png
   │     │  ├─ ui-bg_highlight-soft_75_ffe45c_1x100.png
   │     │  ├─ ui-icons_222222_256x240.png
   │     │  ├─ ui-icons_228ef1_256x240.png
   │     │  ├─ ui-icons_2e83ff_256x240.png
   │     │  ├─ ui-icons_444444_256x240.png
   │     │  ├─ ui-icons_454545_256x240.png
   │     │  ├─ ui-icons_555555_256x240.png
   │     │  ├─ ui-icons_777620_256x240.png
   │     │  ├─ ui-icons_777777_256x240.png
   │     │  ├─ ui-icons_888888_256x240.png
   │     │  ├─ ui-icons_cc0000_256x240.png
   │     │  ├─ ui-icons_cd0a0a_256x240.png
   │     │  ├─ ui-icons_ef8c08_256x240.png
   │     │  ├─ ui-icons_ffd27a_256x240.png
   │     │  └─ ui-icons_ffffff_256x240.png
   │     ├─ jquery-3.6.0.min.js
   │     ├─ jquery-ui-1.13.1.min.css
   │     ├─ jquery-ui-1.13.1.min.js
   │     ├─ jquery-ui-1.13.2.min.css
   │     ├─ jquery-ui-1.13.2.min.js
   │     ├─ jquery.datetimepicker.css
   │     ├─ jquery.datetimepicker.js
   │     ├─ sortable.js
   │     ├─ svg-pan-zoom.min.js
   │     └─ viz-lite.js
   └─ vendor
      ├─ adminlte
      │  ├─ css
      │  │  ├─ adminlte.min.css
      │  │  └─ adminlte.min.css.map
      │  ├─ img
      │  │  ├─ AdminLTELogo.png
      │  │  ├─ icons.png
      │  │  └─ user2-160x160.jpg
      │  └─ js
      │     ├─ adminlte.min.js
      │     └─ adminlte.min.js.map
      ├─ bootstrap
      │  └─ js
      │     ├─ bootstrap.bundle.min.js
      │     ├─ bootstrap.min.js
      │     └─ bootstrap.min.js.map
      ├─ bootswatch
      │  ├─ brite
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ cerulean
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ cosmo
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ cyborg
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ darkly
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ default
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ flatly
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ journal
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ litera
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ lumen
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ lux
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ materia
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ minty
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ morph
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ pulse
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ quartz
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ sandstone
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ simplex
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ sketchy
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ slate
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ solar
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ spacelab
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ superhero
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ united
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ vapor
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  ├─ yeti
      │  │  ├─ bootstrap.min.css
      │  │  └─ bootstrap.min.css.map
      │  └─ zephyr
      │     ├─ bootstrap.min.css
      │     └─ bootstrap.min.css.map
      ├─ fontawesome-free
      │  ├─ css
      │  │  └─ all.min.css
      │  └─ webfonts
      │     ├─ fa-brands-400.ttf
      │     ├─ fa-brands-400.woff2
      │     ├─ fa-regular-400.ttf
      │     ├─ fa-regular-400.woff2
      │     ├─ fa-solid-900.ttf
      │     ├─ fa-solid-900.woff2
      │     ├─ fa-v4compatibility.ttf
      │     └─ fa-v4compatibility.woff2
      └─ select2
         ├─ css
         │  └─ select2.min.css
         └─ js
            └─ select2.min.js

```