import 'package:get/get.dart';
import 'package:getx_demo/app/modules/home/home_binding.dart';
import 'package:getx_demo/app/modules/home/home_page.dart';
import 'package:getx_demo/app/modules/simple_counter/simple_counter_binding.dart';
import 'package:getx_demo/app/modules/simple_counter/simple_counter_page.dart';
import 'package:getx_demo/app/modules/reactive_counter/reactive_counter_binding.dart';
import 'package:getx_demo/app/modules/reactive_counter/reactive_counter_page.dart';
import 'package:getx_demo/app/modules/todo/todo_binding.dart';
import 'package:getx_demo/app/modules/todo/todo_page.dart';
import 'package:getx_demo/app/modules/settings/theme_page.dart';
import 'package:getx_demo/app/modules/settings/language_page.dart';
import 'package:getx_demo/app/routes/app_routes.dart';

/// 应用页面配置
/// 定义所有路由及其绑定和页面
class AppPages {
  /// 当应用启动时的初始路由
  static const INITIAL = Routes.HOME;

  /// 获取所有路由页面配置
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.SIMPLE_COUNTER,
      page: () => SimpleCounterPage(),
      binding: SimpleCounterBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.REACTIVE_COUNTER,
      page: () => ReactiveCounterPage(),
      binding: ReactiveCounterBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.TODO,
      page: () => TodoPage(),
      binding: TodoBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.THEME,
      page: () => ThemePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.LANGUAGE,
      page: () => LanguagePage(),
      transition: Transition.rightToLeft,
    ),
  ];
} 