# PROJECT-SPECIFIC RULE (GetX Demo)

[PROJECT]
getx_demo_flutter

[STRUCTURE]
- lib/app/controllers
- lib/app/modules
- lib/app/routes
- lib/app/bindings
- lib/app/translations

[FEATURE_SCOPE]
- state_management
- dependency_injection
- routing
- i18n
- theme
- persistence

[LOGGER]
- use_AppLogger_only
- no_print
- logger_from_Get_find

[STORAGE]
- GetStorage_only
- no_shared_preferences

[STYLE]
- demo_level_clarity
- readable_over_abstract
- jetpack_like_modular

[FORBIDDEN]
- business_overengineering
- cross_feature_coupling
