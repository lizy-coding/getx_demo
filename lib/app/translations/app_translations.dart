import 'package:get/get.dart';
import 'locales/app_locales.dart';

/// 应用翻译类
/// 用于管理应用的多语言支持
/// 翻译内容已分离到单独的文件中，便于维护
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // 从单独的翻译文件中加载内容
    'en_US': enUS,
    'zh_CN': zhCN,
    // 添加新语言时，只需在此处添加新的映射
    // 例如: 'ja_JP': jaJP,
  };
}
