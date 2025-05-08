import 'package:get/get.dart';
import 'package:getx_demo/app/core/logger.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AppLogger>()) {
      Get.put<AppLogger>(AppLogger(), permanent: true);
    }
  }
}
