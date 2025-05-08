import 'package:get/get.dart';
import 'package:logger/logger.dart' show Logger;

/// 简单状态管理控制器示例
/// 使用GetBuilder更新UI
class CounterController extends GetxController {
  // 简单的状态变量
  int counter = 0;
  final _counterLogger = Logger();

  /// 增加计数器值
  void increment() {
    counter++;
    // 调用update()通知监听此控制器的GetBuilder重建
    update(); // 这相当于StatefulWidget中的setState 
    _counterLogger.d('【简单状态管理】计数器增加: $counter');
  }
  
  /// 减少计数器值
  void decrement() {
    if (counter > 0) {
      counter--;
      update();
      _counterLogger.d('【简单状态管理】计数器减少: $counter');
    }
  }
  
  /// 重置计数器
  void reset() {
    counter = 0;
    update();
    _counterLogger.d('【简单状态管理】计数器重置: $counter');
  }
} 