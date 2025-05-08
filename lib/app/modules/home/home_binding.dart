import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_demo/app/controllers/theme_controller.dart';
import 'package:getx_demo/app/controllers/language_controller.dart';
import 'package:getx_demo/app/controllers/counter_controller.dart';
import 'package:getx_demo/app/controllers/reactive_counter_controller.dart';
import 'package:getx_demo/app/controllers/todo_controller.dart';
import 'package:getx_demo/app/core/logger.dart' show AppLogger;

/// 主页面绑定类
/// 负责将控制器注入到依赖管理器中
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // 初始化GetStorage
    GetStorage.init();
    
    // 注册各种控制器，使其在整个应用中可用
    
    // 主题控制器 - 永久单例
    Get.put<ThemeController>(ThemeController(), permanent: true);
    
    // 语言控制器 - 永久单例
    Get.put<LanguageController>(LanguageController(), permanent: true);
    
    // 简单计数器控制器 - 懒加载单例
    Get.lazyPut<CounterController>(() => CounterController(), fenix: true);
    
    // 响应式计数器控制器 - 懒加载单例
    Get.lazyPut<ReactiveCounterController>(() => ReactiveCounterController(), fenix: true);
    
    // Todo列表控制器 - 懒加载单例
    Get.lazyPut<TodoController>(() => TodoController(), fenix: true);
    
    final logger = Get.find<AppLogger>();
    logger.d('【依赖注入】HomeBinding - 所有控制器已注册');
  }
} 