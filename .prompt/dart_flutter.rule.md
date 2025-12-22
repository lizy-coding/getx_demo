# DART / FLUTTER RULE

[LANGUAGE]
dart_null_safety_strict

[WIDGET_RULES]
- no_logic_in_build
- no_controller_creation_in_widget
- widgets_stateless_preferred
- state_in_controller_only

[PERFORMANCE]
- avoid_rebuild_scope_expand
- no_heavy_object_in_build
- const_where_possible

[STRUCTURE]
- respect_existing_folder
- no_flatten_structure
- file_name_matches_class

[FORBIDDEN]
- setState
- inheritedwidget_custom_impl
