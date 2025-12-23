import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/utils/ui_feedback.dart';

class UiFeedbackDemoController extends GetxController {
  final RxString confirmResult = ''.obs;

  @override
  void onInit() {
    super.onInit();
    confirmResult.value = 'ui_feedback_confirm_pending'.tr;
  }

  void showSuccess() {
    UiFeedback.showSuccess('ui_feedback_success_msg'.tr);
  }

  void showError() {
    UiFeedback.showError('ui_feedback_error_msg'.tr);
  }

  Future<void> showConfirm() async {
    final result = await UiFeedback.confirm(
      'ui_feedback_confirm_title'.tr,
      'ui_feedback_confirm_content'.tr,
    );
    confirmResult.value =
        result ? 'ui_feedback_confirm_yes'.tr : 'ui_feedback_confirm_no'.tr;
  }

  void showLoading() {
    UiFeedback.showLoading(text: 'ui_feedback_loading'.tr);
    Future.delayed(const Duration(milliseconds: 800), () {
      UiFeedback.hideLoading();
    });
  }

  void showSheet() {
    UiFeedback.showSheet(
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ui_feedback_sheet_title'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('ui_feedback_sheet_content'.tr),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('ok'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
