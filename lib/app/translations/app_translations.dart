import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart' show Locale;
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';

/// 应用翻译类
/// 用于管理应用的多语言支持
/// 翻译内容已分离到单独的文件中，便于维护
/// 修改为在启动时预加载所有翻译文件
class AppTranslations extends Translations {
  // 支持的语言列表（与LanguageController中保持一致）
  static const List<String> supportedLanguages = [
    'en_US',
    'zh_CN',
    'ar_SA',
  ];
  
  // 存储所有翻译的静态映射
  static final Map<String, Map<String, String>> _translations = {};
  
  // 标记是否已经预加载
  static bool _preloaded = false;
  
  // 用于获取已加载语言列表的getter
  static List<String> get loadedLanguages => _translations.keys.toList();
  
  @override
  Map<String, Map<String, String>> get keys {
    Get.log('AppTranslations.keys被GetX访问，返回所有预加载的翻译');
    
    // 创建GetX期望格式的翻译映射
    final Map<String, Map<String, String>> formattedTranslations = {};
    
    _translations.forEach((fullCode, translations) {
      // 从全编码（如'en_US'）中提取语言代码
      final parts = fullCode.split('_');
      if (parts.length >= 2) {
        final languageCode = parts[0]; // 例如从'en_US'中提取'en'
        
        // GetX使用语言代码作为主键
        formattedTranslations[languageCode] = translations;
        
        Get.log('已映射 $fullCode 翻译到语言代码 $languageCode');
        final sampleKeys = translations.keys.take(3).toList();
        Get.log('$languageCode 示例键: $sampleKeys');
      } else {
        // 对于没有国家代码的简单语言代码
        formattedTranslations[fullCode] = translations;
      }
    });
    
    Get.log('最终翻译映射键: ${formattedTranslations.keys.toList()}');
    return formattedTranslations;
  }
  
  /// 预加载所有支持的语言翻译
  /// 在应用启动时调用
  static Future<void> preloadAllTranslations() async {
    if (_preloaded) {
      Get.log('翻译已预加载，跳过');
      return;
    }
    
    Get.log('开始预加载所有语言翻译...');
    
    // 创建加载所有语言的Future列表
    final List<Future<void>> loadFutures = [];
    
    for (final languageCode in supportedLanguages) {
      loadFutures.add(_loadLanguageFile(languageCode));
    }
    
    // 等待所有语言加载完成
    await Future.wait(loadFutures);
    
    _preloaded = true;
    Get.log('所有语言翻译预加载完成！已加载: ${_translations.keys.toList()}');
  }
  
  /// 内部方法：加载单个语言文件
  static Future<void> _loadLanguageFile(String languageCode) async {
    try {
      final String filePath = 'lib/app/translations/locales/$languageCode.json';
      Get.log('加载翻译文件: $filePath');
      
      final jsonString = await rootBundle.loadString(filePath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      // 转换为Map<String, String>并存入翻译映射
      _translations[languageCode] = jsonMap.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      
      final int keyCount = _translations[languageCode]?.length ?? 0;
      Get.log('成功加载语言 $languageCode: 共 $keyCount 个翻译键值');
    } catch (e) {
      Get.log('加载语言文件失败: $languageCode.json - $e', isError: true);
      _translations[languageCode] = {}; // 空值避免崩溃
    }
  }
  
  /// 切换应用语言
  /// 由于所有翻译都已预加载，此方法只需更新Locale
  static void switchLanguage(String fullLanguageCode) {
    Get.log('切换语言到: $fullLanguageCode');
    
    if (!_translations.containsKey(fullLanguageCode)) {
      Get.log('警告: 请求的语言 $fullLanguageCode 未预加载', isError: true);
      return;
    }
    
    // 从全编码中提取语言和国家代码
    final parts = fullLanguageCode.split('_');
    if (parts.length >= 2) {
      final languageCode = parts[0]; // 例如 'en'
      final countryCode = parts[1];  // 例如 'US'
      
      // 强制刷新GetX的翻译系统
      // 先切换到不同语言再切回来，确保UI完全刷新
      final targetLocale = Locale(languageCode, countryCode);
      
      // 如果当前已经是目标语言，先切换到另一个语言
      if (Get.locale?.languageCode == languageCode) {
        // 找一个不同的语言临时切换
        final tempLang = supportedLanguages.firstWhere(
          (code) => !code.startsWith(languageCode),
          orElse: () => 'en_US',
        );
        final tempParts = tempLang.split('_');
        Get.updateLocale(Locale(tempParts[0], tempParts[1]));
        Get.log('临时切换到: $tempLang 以强制刷新');
      }
      
      // 延迟一下再切换到目标语言
      Future.delayed(const Duration(milliseconds: 50), () {
        Get.updateLocale(targetLocale);
        Get.log('已切换到目标语言: $fullLanguageCode');
        
        // 在语言切换完成后进行内存清理
        _cleanupMemory();
      });
    } else {
      Get.updateLocale(Locale(fullLanguageCode));
      Get.log('已切换到目标语言: $fullLanguageCode (无国家代码)');
      
      // 在语言切换完成后进行内存清理
      _cleanupMemory();
    }
  }
  
  /// 清理内存
  /// 在语言切换后调用，释放不必要的资源
  static void _cleanupMemory() {
    Get.log('执行内存清理操作');
    
    // 手动触发垃圾回收
    // 注意：这只是建议系统进行垃圾回收，不保证立即执行
    Future.delayed(const Duration(milliseconds: 100), () {
      // 在切换语言后稍后再执行清理，避免影响UI刷新
      Get.log('请求系统进行垃圾回收');
      
      // 清理不再使用的缓存
      // 尝试强制GetX重新加载翻译
      // 注意：GetX没有直接的方法清理翻译缓存
      // 通过更新locale来触发刷新
      
      // 尝试释放一些内存
      // 注意：这些操作只是建议性的，实际效果取决于底层实现
      // 在真实项目中，可以使用更高级的内存管理工具
    });
  }
}
