import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/language_controller.dart';

/// 语言设置页面
/// 展示GetX的国际化功能
class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  // 获取语言控制器
  LanguageController get controller => Get.find<LanguageController>();
  
  // 用于跟踪内存清理状态的RxBool
  final RxBool _cleaningMemory = false.obs;
  
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

            // 下拉框语言选择
            Obx(
              () => DropdownButton<String>(
                value: controller.currentLanguageCode.value,
                isExpanded: true, // 让下拉框宽度撑满父容器
                hint: Text('language_settings'.tr),
                items:
                    controller.languages.map((language) {
                      // 使用完整语言代码 (e.g., 'en_US')
                      final locale = language['locale'] as Locale;
                      final fullCode = locale.toString(); 
                      return DropdownMenuItem<String>(
                        value: fullCode,
                        child: Text(language['name'] as String),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    // 设置内存清理状态为true
                    _cleaningMemory.value = true;
                    
                    // 切换语言
                    controller.updateLocale(newValue);
                    
                    // 模拟内存清理完成
                    Future.delayed(const Duration(milliseconds: 800), () {
                      _cleaningMemory.value = false;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 16),
            
            // 内存清理指示器
            Obx(() => _cleaningMemory.value
              ? Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 10),
                    Text('loading'.tr + ' ' + 'memory_cleanup'.tr),
                  ],
                )
              : const SizedBox.shrink()
            ),

            const SizedBox(height: 40),

            // 语言列表
            Text(
              'available_languages'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.languages.length,
              itemBuilder: (context, index) {
                final language = controller.languages[index];
                final locale = language['locale'] as Locale;
                final fullCode = locale.toString();
                final isSelected = fullCode == controller.currentLanguageCode.value;
                
                return ListTile(
                  title: Text(language['name'] as String),
                  trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                  onTap: () {
                    if (!isSelected) {
                      // 设置内存清理状态为true
                      _cleaningMemory.value = true;
                      
                      // 切换语言
                      controller.updateLocale(fullCode);
                      
                      // 模拟内存清理完成
                      Future.delayed(const Duration(milliseconds: 800), () {
                        _cleaningMemory.value = false;
                      });
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 40),

            // 国际化说明
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'information'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'GetX提供了简便的国际化支持。只需定义翻译字符串，然后使用.tr方法获取当前语言的翻译，'
                    '无需重启应用即可实时切换语言。支持参数替换，复数形式等高级功能。',
                    style: const TextStyle(fontSize: 14),
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
