import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/protected_controller.dart';

class ProtectedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProtectedController>(() => ProtectedController());
  }
}
