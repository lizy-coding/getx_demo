import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/language_controller.dart';

/// 语言设置页面
/// 展示GetX的国际化功能
class LanguagePage extends GetView<LanguageController> {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('language_title'.tr),
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
            // 当前语言信息
            Obx(
              () => Text(
                'current_language'.trParams({
                  'language': controller.currentLanguageName,
                }),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 语言列表
            ListView.builder(
              shrinkWrap: true,
              itemCount: controller.languages.length,
              itemBuilder: (context, index) { // This is the context we need to pass
                final language = controller.languages[index];
                return Obx(
                  () => _buildLanguageItem(
                    context: context, // Pass the context here
                    title: language['name'] as String,
                    languageCode: language['locale'].languageCode as String,
                    isSelected:
                        controller.currentLanguageCode.value ==
                        language['locale'].languageCode,
                    onTap:
                        () => controller.updateLocale(
                          language['locale'].languageCode,
                        ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // 语言切换按钮
            Center(
              child: ElevatedButton.icon(
                onPressed: controller.toggleLanguage,
                icon: const Icon(Icons.language),
                label: const Text('切换语言'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 国际化说明
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '【国际化】',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'GetX提供了简便的国际化支持。只需定义翻译字符串，然后使用.tr方法获取当前语言的翻译，'
                    '无需重启应用即可实时切换语言。支持参数替换，复数形式等高级功能。',
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

  /// 构建语言选项
  Widget _buildLanguageItem({
    required BuildContext context, // Add this parameter
    required String title,
    required String languageCode,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 4 : 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              isSelected ? Get.theme.colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            textDirection: Directionality.of(context), // Now uses the passed context
            children: [
              // 选中图标在 RTL 中显示在右侧
              if (isSelected)
                Icon(Icons.check_circle, color: Get.theme.colorScheme.primary),
              // 文本在中间，自动右对齐（RTL）或左对齐（LTR）
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Get.theme.colorScheme.primary : null,
                  ),
                  textAlign: TextAlign.start, // 自动适配方向
                ),
              ),
              const SizedBox(width: 16),
              // 语言代码徽章在 RTL 中显示在最右侧
              CircleAvatar(
                child: Text(
                  languageCode.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor:
                    isSelected
                        ? Get.theme.colorScheme.primary
                        : Get.theme.colorScheme.primaryContainer,
                foregroundColor:
                    isSelected
                        ? Get.theme.colorScheme.onPrimary
                        : Get.theme.colorScheme.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
