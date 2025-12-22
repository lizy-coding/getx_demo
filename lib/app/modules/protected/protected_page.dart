import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/protected_controller.dart';

class ProtectedPage extends GetView<ProtectedController> {
  const ProtectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('protected_title'.tr),
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
            Text(
              'protected_hint'.tr,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Text(
                controller.isLoggedIn.value
                    ? 'auth_status_logged_in'.tr
                    : 'auth_status_logged_out'.tr,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.logoutAndExit,
              child: Text('auth_logout'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
