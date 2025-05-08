import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/todo_controller.dart';
import 'package:getx_demo/app/core/logger.dart' show AppLogger;

/// Todo绑定类
/// 负责注入Todo控制器
class TodoBinding extends Bindings {
  @override
  void dependencies() {
    // 在这里注册控制器，如果还没有被注册的话
    final logger = Get.find<AppLogger>();

    if (!Get.isRegistered<TodoController>()) {
      Get.lazyPut<TodoController>(() => TodoController());
      logger.d('【依赖注入】TodoBinding - 注册TodoController');
    } else {
      logger.d('【依赖注入】TodoBinding - TodoController已存在');
    }
  }
}
