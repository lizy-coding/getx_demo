import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_demo/app/core/logger.dart';
import 'package:getx_demo/app/translations/app_translations.dart' show AppTranslations;

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
  final RxString currentLanguageCode = 'en_US'.obs;  // Stores full locale string e.g. en_US, zh_CN

  // Default full language code if no valid one is found
  static const String _defaultFullLanguageCode = 'en_US';

  /// 当控制器被创建时调用
  @override
  void onInit() {
    super.onInit();
    _initDefaultLanguage();
  }

  /// 初始化默认语言
  void _initDefaultLanguage() async {
    // 预加载所有语言翻译
    logger.d('开始预加载所有语言翻译');
    await AppTranslations.preloadAllTranslations();
    logger.d('翻译预加载完成，已加载: ${AppTranslations.loadedLanguages}');
    
    // 从存储中加载保存的语言设置
    String savedLangFullCode = _loadLanguageFromStorage();
    currentLanguageCode.value = savedLangFullCode; // 确保是全编码
    
    logger.d('初始化语言为: ${currentLanguageCode.value}');
    
    // 设置初始区域设置
    final initialLocale = _getLocaleFromFullCode(currentLanguageCode.value);
    if (initialLocale != null) {
      Get.updateLocale(initialLocale);
      logger.d('已设置初始区域设置: $initialLocale');
    }
  }

  /// 从存储中加载语言设置
  String _loadLanguageFromStorage() {
    final String? storedCode = _storage.read(_languageKey);
    return _ensureFullLanguageCode(storedCode ?? _defaultFullLanguageCode);
  }

  /// 将语言设置保存到存储
  void _saveLanguageToStorage(String languageCode) {
    _storage.write(_languageKey, languageCode);
  }

  /// 通过语言代码更新应用语言（关键修改）
  /// 更新应用语言
  /// @param languageCode 语言代码，可以是短代码(en)或全代码(en_US)
  void updateLocale(String languageCode) async {
    final String fullLanguageCode = _ensureFullLanguageCode(languageCode);
    logger.d('【国际化】更新语言: $languageCode -> $fullLanguageCode');

    if (fullLanguageCode != currentLanguageCode.value) {
      // 更新当前语言代码（这会触发UI刷新）
      currentLanguageCode.value = fullLanguageCode;
      
      // 保存语言设置到本地存储
      _saveLanguageToStorage(fullLanguageCode);
      logger.d('【国际化】已保存语言设置: $fullLanguageCode');
      
      // 使用新的切换语言方法
      // 由于所有翻译都已预加载，只需要切换Locale
      AppTranslations.switchLanguage(fullLanguageCode);
      
      // 通知GetBuilder监听器重建
      update();
      
      // 记录最终状态
      logger.d('【国际化】语言切换完成: $fullLanguageCode');
      logger.d('【国际化】当前加载的语言: ${AppTranslations.loadedLanguages}');
    }
  }

  /// 切换语言（在支持的语言之间循环）
  void toggleLanguage() {
    int currentIndex = languages.indexWhere(
      (lang) => (lang['locale'] as Locale).toString() == currentLanguageCode.value,
    );
    if (currentIndex == -1) {
      // Fallback if current language code is not found (should not happen)
      currentIndex = 0;
    }

    int nextIndex = (currentIndex + 1) % languages.length;
    String nextLanguageFullCode = (languages[nextIndex]['locale'] as Locale).toString();

    updateLocale(nextLanguageFullCode);
    logger.d('【国际化】切换语言: $nextLanguageFullCode');
  }
  
  /// 获取当前语言名称
  String get currentLanguageName {
    final currentLang = languages.firstWhere(
      (lang) => (lang['locale'] as Locale).toString() == currentLanguageCode.value,
      orElse: () => languages.first,
    );
    return currentLang['name'] as String;
  }

  /// 从完整的语言代码字符串（如 "en_US"）获取Locale对象
  Locale? _getLocaleFromFullCode(String fullCode) {
    if (fullCode.isEmpty) return null;
    final parts = fullCode.split('_');
    if (parts.length == 1) return Locale(parts[0]); // e.g. 'en'
    if (parts.length >= 2) return Locale(parts[0], parts[1]); // e.g. 'en_US'
    return null; // Invalid format
  }

  /// Ensures the language code is in the full format (e.g., 'en_US').
  /// Converts short codes ('en', 'zh') to their full counterparts.
  String _ensureFullLanguageCode(String code) {
    if (code.contains('_')) return code; // Already a full code

    // Attempt to map short code to full code from the `languages` list
    for (final langMap in languages) {
      final locale = langMap['locale'] as Locale;
      if (locale.languageCode == code) {
        return locale.toString(); // Returns 'languageCode_countryCode' or 'languageCode'
      }
    }
    // If no match found, or if it was an unmapped full code without '_', return default
    logger.w('Could not map short code "$code" to a full code. Defaulting to $_defaultFullLanguageCode');
    return _defaultFullLanguageCode; 
  }
}
