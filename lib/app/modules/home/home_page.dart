import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/theme_controller.dart';
import 'package:getx_demo/app/controllers/language_controller.dart';
import 'package:getx_demo/app/routes/app_routes.dart';

/// 主页面
/// 展示不同GetX特性的入口
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  
  // 使用Get.find()获取已注册的控制器
  final ThemeController themeController = Get.find<ThemeController>();
  final LanguageController languageController = Get.find<LanguageController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home_title'.tr),
        actions: [
          // 主题切换按钮
          Obx(() => IconButton(
            onPressed: themeController.toggleTheme,
            icon: Icon(
              themeController.isDarkMode.value 
                ? Icons.light_mode 
                : Icons.dark_mode,
            ),
            tooltip: themeController.isDarkMode.value
                ? 'light_mode'.tr
                : 'dark_mode'.tr,
          )),
          // 语言切换按钮
          IconButton(
            onPressed: languageController.toggleLanguage,
            icon: const Icon(Icons.language),
            tooltip: 'language_settings'.tr,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFeatureCard(
              title: 'simple_counter'.tr,
              description: '【简单状态管理】使用GetBuilder展示GetX的简单状态管理功能',
              icon: Icons.add_circle_outline,
              onTap: () => Get.toNamed(Routes.SIMPLE_COUNTER),
            ),
            _buildFeatureCard(
              title: 'reactive_counter'.tr,
              description: '【响应式状态管理】使用Obx和.obs展示GetX的响应式状态管理功能',
              icon: Icons.autorenew,
              onTap: () => Get.toNamed(Routes.REACTIVE_COUNTER),
            ),
            _buildFeatureCard(
              title: 'todo_list'.tr,
              description: '【数据持久化】结合响应式状态管理和GetStorage展示数据持久化',
              icon: Icons.checklist,
              onTap: () => Get.toNamed(Routes.TODO),
            ),
            _buildFeatureCard(
              title: 'theme_settings'.tr,
              description: '【主题管理】展示GetX的主题切换功能',
              icon: Icons.color_lens,
              onTap: () => Get.toNamed(Routes.THEME),
            ),
            _buildFeatureCard(
              title: 'language_settings'.tr,
              description: '【国际化】展示GetX的多语言支持功能',
              icon: Icons.translate,
              onTap: () => Get.toNamed(Routes.LANGUAGE),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建功能卡片
  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
} 