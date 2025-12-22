# GETX ARCHITECTURE RULE

[STATE]
- controller_extends_getxcontroller
- ui_never_hold_state
- reactive_first

[REACTIVE]
- obs_with_primitive_only
- Obx_scope_minimal
- no_nested_obx

[SIMPLE_STATE]
- GetBuilder_requires_update_call
- id_scoped_update_preferred

[DEPENDENCY_INJECTION]
- binding_mandatory
- no_Get_put_in_ui
- lazyPut_default
- permanent_only_for_global

[ROUTING]
- GetPage_only
- binding_attached_to_route
- no_context_navigation

[LIFECYCLE]
- onInit_for_init
- onClose_for_dispose
- no_manual_dispose

[FORBIDDEN]
- global_controller
- Get.find_in_build
