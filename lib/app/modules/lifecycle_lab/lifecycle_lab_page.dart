import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/lifecycle_lab_controller.dart';

class LifecycleLabPage extends GetView<LifecycleLabController> {
  const LifecycleLabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lifecycle_lab_title'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.goBack,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'lifecycle_lab_hint'.tr,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Obx(
            () => DropdownButton<LifecycleRegisterMode>(
              value: controller.currentMode.value,
              isExpanded: true,
              items: LifecycleRegisterMode.values
                  .map(
                    (mode) => DropdownMenuItem(
                      value: mode,
                      child: Text(controller.labelForMode(mode)),
                    ),
                  )
                  .toList(),
              onChanged: (mode) {
                if (mode != null) {
                  controller.setMode(mode);
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: controller.registerCurrent,
            child: Text('lifecycle_register'.tr),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.findCurrent,
                  child: Text('lifecycle_find'.tr),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.deleteCurrent,
                  child: Text('lifecycle_delete'.tr),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(
            () => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('lifecycle_force_delete'.tr),
              value: controller.forceDelete.value,
              onChanged: (value) => controller.forceDelete.value = value,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.pushChild,
                  child: Text('lifecycle_push_child'.tr),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.goBack,
                  child: Text('lifecycle_back'.tr),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            final snapshot = controller.currentSnapshot;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(
                      'lifecycle_mode'.tr,
                      controller.labelForMode(controller.currentMode.value),
                    ),
                    _infoRow(
                      'lifecycle_registered'.tr,
                      controller.isRegistered.value
                          ? 'lifecycle_yes'.tr
                          : 'lifecycle_no'.tr,
                    ),
                    _infoRow(
                      'lifecycle_hash'.tr,
                      snapshot.controllerHashCode.value == 0
                          ? '-'
                          : snapshot.controllerHashCode.value.toString(),
                    ),
                    _infoRow(
                      'lifecycle_init'.tr,
                      snapshot.initCount.value.toString(),
                    ),
                    _infoRow(
                      'lifecycle_ready'.tr,
                      snapshot.readyCount.value.toString(),
                    ),
                    _infoRow(
                      'lifecycle_close'.tr,
                      snapshot.closeCount.value.toString(),
                    ),
                    _infoRow(
                      'lifecycle_route'.tr,
                      controller.currentRoute.value,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
