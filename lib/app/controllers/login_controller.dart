import 'package:get/get.dart';
import 'package:getx_demo/app/routes/app_routes.dart';
import 'package:getx_demo/app/services/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  String? get redirectFrom => Get.parameters['from'];

  void login() {
    _authService.login();
    final from = redirectFrom;
    if (from != null && from.isNotEmpty) {
      Get.offNamed(Uri.decodeComponent(from));
      return;
    }
    Get.offNamed(Routes.HOME);
  }
}
