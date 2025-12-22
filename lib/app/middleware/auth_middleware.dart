import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/routes/app_routes.dart';
import 'package:getx_demo/app/services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  AuthService get _authService => Get.find<AuthService>();

  @override
  RouteSettings? redirect(String? route) {
    if (_authService.isLoggedIn.value) {
      return null;
    }

    final target = route ?? Routes.HOME;
    final redirectTo = '${Routes.LOGIN}?from=${Uri.encodeComponent(target)}';
    return RouteSettings(name: redirectTo);
  }
}
