import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/todo_controller.dart';

/// Todo绑定类
/// 负责注入Todo控制器
class TodoBinding extends Bindings {
  @override
  void dependencies() {
    // 在这里注册控制器，如果还没有被注册的话
    
    if (!Get.isRegistered<TodoController>()) {
      Get.lazyPut<TodoController>(() => TodoController());
      print('【依赖注入】TodoBinding - 注册TodoController');
    } else {
      print('【依赖注入】TodoBinding - TodoController已存在');
    }
  }
} 