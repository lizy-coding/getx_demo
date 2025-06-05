import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_demo/app/controllers/theme_controller.dart';
import 'package:getx_demo/app/core/app_binding.dart';
import 'package:getx_demo/app/core/logger.dart' show AppLogger;
import 'package:getx_demo/app/routes/app_pages.dart';
import 'package:getx_demo/app/translations/app_translations.dart';
import 'package:logger/logger.dart' show Logger;

/// 应用入口
/// 演示GetX框架的使用方法
void main() async {
  // 确保绑定完成
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化GetStorage
  await GetStorage.init();
  
  // 初始化Logger
  final logger = Get.put(AppLogger(), permanent: true);
  logger.d('【GetX Demo】应用启动中...');
  
  // 预加载所有翻译
  logger.d('【GetX Demo】开始预加载所有翻译');
  await AppTranslations.preloadAllTranslations();
  logger.d('【GetX Demo】翻译预加载完成，已加载: ${AppTranslations.loadedLanguages}');

  // 运行应用
  runApp(const MyApp());

  // 打印欢迎信息
  logger.d('【GetX Demo】应用已启动');
  logger.d('【GetX Demo】这个演示应用展示了GetX的各种功能：');
  logger.d('【GetX Demo】1. 状态管理 - 简单状态管理和响应式状态管理');
  logger.d('【GetX Demo】2. 依赖注入 - 控制器注入与获取');
  logger.d('【GetX Demo】3. 路由管理 - 无需context的导航');
  logger.d('【GetX Demo】4. 国际化 - 多语言支持');
  logger.d('【GetX Demo】5. 主题管理 - 动态切换主题');
  logger.d('【GetX Demo】6. 数据持久化 - 使用GetStorage存储数据');
}

/// 应用根组件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用GetMaterialApp替代MaterialApp
    return GetMaterialApp(
      // 应用标题
      title: 'GetX Demo',

      // 调试标志
      debugShowCheckedModeBanner: false,

      // 启用日志
      enableLog: true,

      // 默认过渡动画
      defaultTransition: Transition.fade,

      // 国际化配置
      translations: AppTranslations(),
      locale: const Locale('zh', 'CN'), // 默认语言: 中文
      fallbackLocale: const Locale('en', 'US'), // 回退语言: 英文
      // 主题配置
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system, // 默认跟随系统
      // 路由配置
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      // 绑定全局依赖
      initialBinding: AppBinding(),

      // 日志配置
      logWriterCallback: (String text, {bool isError = false}) {
        Logger().d('【GetX】 $text');
      },
    );
  }
}
