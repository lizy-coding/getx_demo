import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/ui_feedback_demo_controller.dart';

class UiFeedbackDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UiFeedbackDemoController>(() => UiFeedbackDemoController());
  }
}
