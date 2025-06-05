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
          // 语言切换下拉菜单（优化后）
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            tooltip: 'language_settings'.tr,
            // 仅在需要响应式更新的部分使用 Obx（如选中状态）
            itemBuilder: (context) => languageController.languages.map((language) {
              return PopupMenuItem<String>(
                value: language['locale'].languageCode,
                child: Obx(() => Row(  // 仅包裹需要响应 currentLanguageCode 的子部件
                  children: [
                    if (language['locale'].languageCode == languageController.currentLanguageCode.value)
                      Icon(Icons.check, color: Get.theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(language['name'] as String),
                  ],
                )),
              );
            }).toList(),
            onSelected: (languageCode) {
              languageController.updateLocale(languageCode);
            },
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
              description: 'simple_counter_description'.tr,
              icon: Icons.add_circle_outline,
              onTap: () => Get.toNamed(Routes.SIMPLE_COUNTER),
            ),
            _buildFeatureCard(
              title: 'reactive_counter'.tr,
              description: 'reactive_counter_description'.tr,
              icon: Icons.autorenew,
              onTap: () => Get.toNamed(Routes.REACTIVE_COUNTER),
            ),
            _buildFeatureCard(
              title: 'todo_list'.tr,
              description: 'todo_list_description'.tr,
              icon: Icons.checklist,
              onTap: () => Get.toNamed(Routes.TODO),
            ),
            _buildFeatureCard(
              title: 'theme_settings'.tr,
              description: 'theme_settings_description'.tr,
              icon: Icons.color_lens,
              onTap: () => Get.toNamed(Routes.THEME),
            ),
            _buildFeatureCard(
              title: 'language_settings'.tr,
              description: 'language_settings_description'.tr,
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