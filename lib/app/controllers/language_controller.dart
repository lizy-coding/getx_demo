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
  String? _previousLanguageCode; // 记录上一次使用的语言代码（新增）

  /// 当控制器被创建时调用
  @override
  void onInit() {
    super.onInit();
    _initDefaultLanguage();
  }

  /// 初始化默认语言（仅加载中文）
  void _initDefaultLanguage() async {
    String savedLangFullCode = _loadLanguageFromStorage();
    currentLanguageCode.value = savedLangFullCode; // Already ensured to be full or default full
    
    logger.d('Initializing language to: ${currentLanguageCode.value}');
    await AppTranslations.load(currentLanguageCode.value);
    // No need to call updateLocale here as Get.updateLocale will be implicitly handled by GetX if needed,
    // and translations are now loaded. Setting currentLanguageCode.value will trigger Obx listeners.
    // If Get.updateLocale is strictly needed for initial locale setting beyond translations, 
    // ensure it's called with the correct Locale object derived from currentLanguageCode.value.
    // For now, let's assume GetX handles initial locale setting based on translations. 
    // We might need to explicitly call Get.updateLocale if issues persist with initial UI rendering.
    final initialLocale = _getLocaleFromFullCode(currentLanguageCode.value);
    if (initialLocale != null) {
      Get.updateLocale(initialLocale);
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
  void updateLocale(String languageCode) async { // Renamed parameter to languageCode
    final String fullLanguageCode = _ensureFullLanguageCode(languageCode); // Ensure we have the full code
    // 记录当前语言作为上一次语言（切换前）
    if (currentLanguageCode.value.isNotEmpty) {
      _previousLanguageCode = currentLanguageCode.value;
    }

    // 切换语言时加载对应JSON文件（未缓存时才加载）
    await AppTranslations.load(fullLanguageCode);
    
    final locale = _getLocaleFromFullCode(fullLanguageCode); // Use new helper
    if (locale != null) {
      logger.d('Before Get.updateLocale. Target Locale: $locale, AppTranslations has keys for: ${AppTranslations.cachedLanguageCodes.toList()}');
      Get.updateLocale(locale);
      currentLanguageCode.value = fullLanguageCode;
      _saveLanguageToStorage(fullLanguageCode);
      logger.d('【国际化】语言切换成功: $fullLanguageCode');

      // 卸载上一次使用的语言缓存（非当前语言时）
      if (_previousLanguageCode != null && _previousLanguageCode != fullLanguageCode) {
        // AppTranslations.unload(_previousLanguageCode!); // Temporarily disabled for debugging
        // logger.d('【国际化】已卸载旧语言缓存: $_previousLanguageCode (UNLOAD DISABLED)');
        logger.d('【国际化】Skipping unload of old language cache for debugging: $_previousLanguageCode');
      }
      update(); // Notify GetBuilder listeners to rebuild
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
