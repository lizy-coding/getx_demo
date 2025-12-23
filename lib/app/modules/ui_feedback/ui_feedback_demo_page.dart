import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/ui_feedback_demo_controller.dart';

class UiFeedbackDemoPage extends GetView<UiFeedbackDemoController> {
  const UiFeedbackDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ui_feedback_title'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'ui_feedback_hint'.tr,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.showSuccess,
            child: Text('ui_feedback_show_success'.tr),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: controller.showError,
            child: Text('ui_feedback_show_error'.tr),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: controller.showConfirm,
            child: Text('ui_feedback_show_confirm'.tr),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: controller.showLoading,
            child: Text('ui_feedback_show_loading'.tr),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: controller.showSheet,
            child: Text('ui_feedback_show_sheet'.tr),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Text(
              'ui_feedback_confirm_result'.trParams({
                'result': controller.confirmResult.value,
              }),
            ),
          ),
        ],
      ),
    );
  }
}
