import 'package:get/get.dart';
import 'package:getx_demo/app/routes/app_routes.dart';
import 'package:getx_demo/app/services/auth_service.dart';

class AuthGuardDemoController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  RxBool get isLoggedIn => _authService.isLoggedIn;

  void goToProtected() {
    Get.toNamed(Routes.PROTECTED);
  }

  void goToLogin() {
    Get.toNamed(
      Routes.LOGIN,
      parameters: {'from': Routes.AUTH_GUARD_DEMO},
    );
  }

  void logout() {
    _authService.logout();
  }
}
