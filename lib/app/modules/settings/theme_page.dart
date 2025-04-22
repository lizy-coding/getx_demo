import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/theme_controller.dart';

/// 主题设置页面
/// 展示GetX的主题管理功能
class ThemePage extends GetView<ThemeController> {
  const ThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('theme_title'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 主题信息
            Obx(() => Text(
              'current_theme'.trParams({
                'theme': controller.isDarkMode.value 
                    ? 'dark_mode'.tr 
                    : 'light_mode'.tr
              }),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )),
            
            const SizedBox(height: 24),
            
            // 主题切换选项
            Obx(() => _buildThemeOption(
              title: 'light_mode'.tr,
              description: '浅色主题 - 适合白天使用',
              icon: Icons.light_mode,
              isSelected: !controller.isDarkMode.value,
              onTap: () => controller.setTheme(false),
            )),
            
            const SizedBox(height: 16),
            
            Obx(() => _buildThemeOption(
              title: 'dark_mode'.tr,
              description: '深色主题 - 适合夜间使用，保护眼睛',
              icon: Icons.dark_mode,
              isSelected: controller.isDarkMode.value,
              onTap: () => controller.setTheme(true),
            )),
            
            const SizedBox(height: 40),
            
            // 主题切换按钮
            Center(
              child: ElevatedButton.icon(
                onPressed: controller.toggleTheme,
                icon: Obx(() => Icon(controller.isDarkMode.value 
                    ? Icons.light_mode 
                    : Icons.dark_mode)),
                label: Text('切换到${controller.isDarkMode.value 
                    ? "浅色" 
                    : "深色"}主题'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24, 
                    vertical: 12,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 主题管理说明
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '【主题管理】',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'GetX提供了简便的主题管理功能。可以使用Get.changeTheme()或Get.changeThemeMode()切换主题，'
                    '无需使用Provider或重建MaterialApp。并且可以结合GetStorage轻松实现主题持久化保存。',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建主题选项
  Widget _buildThemeOption({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Get.theme.colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon, 
                size: 32,
                color: isSelected ? Get.theme.colorScheme.primary : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Get.theme.colorScheme.primary : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Get.theme.colorScheme.primary : Get.theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Get.theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}