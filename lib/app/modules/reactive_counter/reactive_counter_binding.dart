import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/reactive_counter_controller.dart';

/// 响应式计数器绑定类
/// 负责注入响应式计数器控制器
class ReactiveCounterBinding extends Bindings {
  @override
  void dependencies() {
    // 在这里注册控制器，如果还没有被注册的话
    
    if (!Get.isRegistered<ReactiveCounterController>()) {
      Get.lazyPut<ReactiveCounterController>(() => ReactiveCounterController());
      print('【依赖注入】ReactiveCounterBinding - 注册ReactiveCounterController');
    } else {
      print('【依赖注入】ReactiveCounterBinding - ReactiveCounterController已存在');
    }
  }
} 