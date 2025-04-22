import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/counter_controller.dart';

/// 简单计数器页面
/// 展示GetX的简单状态管理功能
class SimpleCounterPage extends StatelessWidget {
  SimpleCounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 获取控制器
    // 也可以使用final controller = Get.find<CounterController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('simple_counter_title'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(), // 使用GetX的导航
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 使用GetBuilder监听状态变化
            // 只有当调用update()时才会重建此小部件
            GetBuilder<CounterController>(
              builder: (controller) {
                print('【简单状态管理】GetBuilder重建UI, 当前计数: ${controller.counter}');
                return Column(
                  children: [
                    Text(
                      'counter_value'.trParams({'value': controller.counter.toString()}),
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
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
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // 使用Get.find()获取控制器实例
                final controller = Get.find<CounterController>();
                controller.reset();
                
                // 显示一个SnackBar - GetX的Snackbar无需context
                Get.snackbar(
                  'simple_counter'.tr,
                  '计数器已重置',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.blue.withOpacity(0.7),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              },
              child: Text('reset'.tr),
            ),
            const SizedBox(height: 40),
            // 简单状态管理说明
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    '【简单状态管理】',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '使用GetBuilder监听状态变化，只有当调用controller.update()时才会重建UI。'
                    '适用于简单的状态管理场景，比GetX的响应式状态管理更轻量。',
                    textAlign: TextAlign.center,
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