import 'package:get/get.dart';
import 'package:getx_demo/app/core/logger.dart';
import 'package:getx_demo/app/services/auth_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AppLogger>()) {
      Get.put<AppLogger>(AppLogger(), permanent: true);
    }
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService(), permanent: true);
    }
  }
}
