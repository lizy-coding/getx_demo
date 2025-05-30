import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_demo/app/core/logger.dart';

/// 语言控制器
/// 用于管理应用的语言设置
class LanguageController extends GetxController {
  final logger = Get.find<AppLogger>();

  // 使用Get Storage存储语言设置
  final _storage = GetStorage();
  final _languageKey = 'language';

  // 支持的语言列表
  final List<Map<String, dynamic>> languages = [
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': '中文', 'locale': const Locale('zh', 'CN')},
    {
      'name': 'العربية', // 阿拉伯语名称
      'locale': const Locale('ar', 'SA'), // 阿拉伯语地区
    },
  ];

  // 响应式变量，跟踪当前语言
  Rx<String> currentLanguageCode = 'en'.obs;

  /// 当控制器被创建时调用
  @override
  void onInit() {
    super.onInit();
    // 从存储中加载语言设置
    currentLanguageCode.value = _loadLanguageFromStorage();
    logger.d('【国际化】初始化语言: ${currentLanguageCode.value}');

    // 设置初始语言
    updateLocale(currentLanguageCode.value);
  }

  /// 从存储中加载语言设置
  String _loadLanguageFromStorage() {
    return _storage.read(_languageKey) ?? 'en';
  }

  /// 将语言设置保存到存储
  void _saveLanguageToStorage(String languageCode) {
    _storage.write(_languageKey, languageCode);
  }

  /// 通过语言代码更新应用语言
  void updateLocale(String languageCode) {
    final locale = _getLocaleFromLanguageCode(languageCode);
    if (locale != null) {
      Get.updateLocale(locale);
      currentLanguageCode.value = languageCode;
      _saveLanguageToStorage(languageCode);
      logger.d('【国际化】语言已更新: $languageCode');
    }
  }

  /// 切换语言（在支持的语言之间循环）
  void toggleLanguage() {
    // 获取当前语言的索引
    int currentIndex = languages.indexWhere(
      (lang) => lang['locale'].languageCode == currentLanguageCode.value,
    );

    // 切换到下一个语言（如果是最后一个则回到第一个）
    int nextIndex = (currentIndex + 1) % languages.length;
    String nextLanguageCode = languages[nextIndex]['locale'].languageCode;

    updateLocale(nextLanguageCode);
    logger.d('【国际化】切换语言: $nextLanguageCode');
  }

  /// 获取当前语言名称
  String get currentLanguageName {
    final currentLang = languages.firstWhere(
      (lang) => lang['locale'].languageCode == currentLanguageCode.value,
      orElse: () => languages[0],
    );
    return currentLang['name'];
  }

  /// 从语言代码获取Locale对象
  Locale? _getLocaleFromLanguageCode(String languageCode) {
    for (final lang in languages) {
      if (lang['locale'].languageCode == languageCode) {
        return lang['locale'];
      }
    }
    return null;
  }
}
