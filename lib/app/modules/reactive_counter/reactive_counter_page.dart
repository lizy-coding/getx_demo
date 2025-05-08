import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/reactive_counter_controller.dart';
import 'package:getx_demo/app/core/logger.dart' show AppLogger;

/// 响应式计数器页面
/// 展示GetX的响应式状态管理功能
class ReactiveCounterPage extends StatelessWidget {
  ReactiveCounterPage({super.key});

  // 使用Get.find获取控制器实例
  final ReactiveCounterController controller =
      Get.find<ReactiveCounterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('reactive_counter_title'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 使用Obx监听响应式变量的变化
            Obx(() {
              final logger = Get.find<AppLogger>();
              logger.d('【响应式状态管理】Obx重建计数UI: ${controller.count.value}');
              return Column(
                children: [
                  Text(
                    'count_value'.trParams({
                      'value': controller.count.value.toString(),
                    }),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  // 根据count的奇偶性显示不同的文本
                  Obx(() {
                    logger.d('【响应式状态管理】Obx重建偶数/奇数状态UI');
                    return Text(
                      controller.isEven.value ? 'is_even'.tr : 'is_odd'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            controller.isEven.value
                                ? Colors.green
                                : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ],
              );
            }),
            const SizedBox(height: 20),
            // 按钮不需要包在Obx中，因为它们不依赖于响应式状态
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controller.decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: controller.increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                controller.reset();
                // 使用GetX的底部表单
                Get.bottomSheet(
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '计数器已重置',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Get.theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          child: Text('ok'.tr),
                        ),
                      ],
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                );
              },
              child: Text('reset'.tr),
            ),
            const SizedBox(height: 40),
            // 响应式状态管理说明
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    '【响应式状态管理】',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '使用.obs创建响应式变量，使用Obx自动监听变量变化并重建UI。'
                    '无需手动调用setState或update，响应式变量变化时自动更新UI。',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '通过在控制器中使用workers（ever、debounce等）可以监听响应式变量变化并执行额外操作。',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
