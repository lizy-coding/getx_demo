import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LifecycleChildPage extends StatelessWidget {
  const LifecycleChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lifecycle_child_title'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Text('lifecycle_child_hint'.tr),
      ),
    );
  }
}
