import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/auth_guard_demo_controller.dart';

class AuthGuardDemoPage extends GetView<AuthGuardDemoController> {
  const AuthGuardDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('auth_guard_demo_title'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(
              () => Text(
                controller.isLoggedIn.value
                    ? 'auth_status_logged_in'.tr
                    : 'auth_status_logged_out'.tr,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.goToProtected,
              child: Text('auth_go_protected'.tr),
            ),
            const SizedBox(height: 8),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoggedIn.value
                    ? controller.logout
                    : controller.goToLogin,
                child: Text(
                  controller.isLoggedIn.value
                      ? 'auth_logout'.tr
                      : 'auth_login'.tr,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
