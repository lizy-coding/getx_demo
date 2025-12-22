import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/lifecycle_lab_controller.dart';

class LifecycleLabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LifecycleLabController>(() => LifecycleLabController());
  }
}
