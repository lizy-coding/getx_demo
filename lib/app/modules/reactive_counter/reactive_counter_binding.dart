import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/reactive_counter_controller.dart';
import 'package:getx_demo/app/core/logger.dart' show AppLogger;

/// 响应式计数器绑定类
/// 负责注入响应式计数器控制器
class ReactiveCounterBinding extends Bindings {
  @override
  void dependencies() {
    // 在这里注册控制器，如果还没有被注册的话
    final logger = Get.find<AppLogger>();

    if (!Get.isRegistered<ReactiveCounterController>()) {
      Get.lazyPut<ReactiveCounterController>(() => ReactiveCounterController());
      logger.d('【依赖注入】ReactiveCounterBinding - 注册ReactiveCounterController');
    } else {
      logger.d('【依赖注入】ReactiveCounterBinding - ReactiveCounterController已存在');
    }
  }
}
