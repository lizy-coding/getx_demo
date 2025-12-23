import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/auth_guard_demo_controller.dart';

class AuthGuardDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthGuardDemoController>(() => AuthGuardDemoController());
  }
}
