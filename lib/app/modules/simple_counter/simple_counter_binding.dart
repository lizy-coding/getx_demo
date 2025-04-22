import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/counter_controller.dart';

/// 简单计数器绑定类
/// 负责注入简单计数器控制器
class SimpleCounterBinding extends Bindings {
  @override
  void dependencies() {
    // 在这里注册控制器，如果还没有被注册的话
    
    // 因为已经在HomeBinding中使用lazyPut注册了CounterController
    // 并设置了fenix: true，所以不需要再次注册
    // 但为了演示，这里仍然添加一个条件注册
    
    if (!Get.isRegistered<CounterController>()) {
      Get.lazyPut<CounterController>(() => CounterController());
      print('【依赖注入】SimpleCounterBinding - 注册CounterController');
    } else {
      print('【依赖注入】SimpleCounterBinding - CounterController已存在');
    }
  }
}