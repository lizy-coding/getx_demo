import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UiFeedback {
  static bool _loadingVisible = false;

  static void showSuccess(String message, {String? title}) {
    _showSnack(
      message,
      title: title ?? 'ui_feedback_success'.tr,
      backgroundColor: Colors.green.withOpacity(0.8),
    );
  }

  static void showError(String message, {String? title}) {
    _showSnack(
      message,
      title: title ?? 'ui_feedback_error'.tr,
      backgroundColor: Colors.red.withOpacity(0.8),
    );
  }

  static Future<bool> confirm(String title, String content) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text('ok'.tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return result ?? false;
  }

  static void showLoading({String? text}) {
    if (_loadingVisible) {
      return;
    }

    _loadingVisible = true;
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  text ?? 'loading'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    ).whenComplete(() {
      _loadingVisible = false;
    });
  }

  static void hideLoading() {
    if (!_loadingVisible) {
      return;
    }

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    _loadingVisible = false;
  }

  static void showSheet(Widget child) {
    Get.bottomSheet(
      child,
      isScrollControlled: true,
      backgroundColor: Colors.white,
    );
  }

  static void _showSnack(
    String message, {
    required String title,
    required Color backgroundColor,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }
}
