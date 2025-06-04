import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'dart:convert';

/// 应用翻译类
/// 用于管理应用的多语言支持
/// 翻译内容已分离到单独的文件中，便于维护
class AppTranslations extends Translations {
  static final Map<String, Map<String, String>> _cachedTranslations = {};

  // Static getter for LanguageController to log cached keys for debugging
  static Iterable<String> get cachedLanguageCodes => _cachedTranslations.keys;

  @override
  Map<String, Map<String, String>> get keys {
    Get.log('AppTranslations.keys accessed by GetX. Currently cached languages: ${_cachedTranslations.keys.toList()}. Returning all cached translations.');
    return _cachedTranslations;
  }

  /// 动态加载指定语言的JSON翻译文件（带缓存）
  static Future<void> load(String languageCode) async {
    if (_cachedTranslations.containsKey(languageCode)) return; // 已缓存则跳过

    try {
      // 从assets目录加载JSON文件
      final jsonString = await rootBundle.loadString(
        'lib/app/translations/locales/$languageCode.json'
      );
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      // 转换为Map<String, String>并存入缓存
      _cachedTranslations[languageCode] = jsonMap.map(
        (key, value) => MapEntry(key, value.toString())
      );
    } catch (e) {
      Get.log('加载语言文件失败: $languageCode.json - $e', isError: true);
      _cachedTranslations[languageCode] = {}; // 空值避免崩溃
    }
  }

  /// 移除指定语言的缓存（新增方法）
  static void unload(String languageCode) {
    _cachedTranslations.remove(languageCode);
    Get.log('已卸载语言缓存: $languageCode', isError: false);
  }
}


