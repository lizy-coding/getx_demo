import 'package:get/get.dart';
import 'package:getx_demo/app/routes/app_routes.dart';
import 'package:getx_demo/app/services/auth_service.dart';

class ProtectedController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  RxBool get isLoggedIn => _authService.isLoggedIn;

  void logoutAndExit() {
    _authService.logout();
    Get.offNamed(Routes.HOME);
  }
}
