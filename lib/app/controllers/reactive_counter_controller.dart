import 'package:get/get.dart';

/// 响应式状态管理控制器示例
/// 使用.obs和Obx更新UI
class ReactiveCounterController extends GetxController {
  // 使用.obs使变量变为响应式
  RxInt count = 0.obs;
  RxBool isEven = true.obs;
  
  /// 增加计数器值
  void increment() {
    count.value++;
    _updateEvenStatus();
    print('【响应式状态管理】计数器增加: ${count.value}');
  }
  
  /// 减少计数器值
  void decrement() {
    if (count.value > 0) {
      count.value--;
      _updateEvenStatus();
      print('【响应式状态管理】计数器减少: ${count.value}');
    }
  }
  
  /// 重置计数器
  void reset() {
    count.value = 0;
    _updateEvenStatus();
    print('【响应式状态管理】计数器重置: ${count.value}');
  }
  
  /// 更新偶数状态
  void _updateEvenStatus() {
    isEven.value = count.value % 2 == 0;
  }
  
  /// 当控制器被创建时调用
  @override
  void onInit() {
    super.onInit();
    // 可以在这里设置初始值或添加workers
    
    // 添加一个worker，监听count变化
    ever(count, (_) {
      print('【响应式状态管理】count发生变化: ${count.value}');
    });
    
    // 添加一个debounce，延迟处理输入
    debounce(count, (_) {
      print('【响应式状态管理】debounce触发: ${count.value} (延迟500ms)');
    }, time: const Duration(milliseconds: 500));
    
    print('【响应式状态管理】控制器初始化完成');
  }
  
  /// 当控制器被释放时调用
  @override
  void onClose() {
    // 可以在这里做一些清理工作
    print('【响应式状态管理】控制器被释放');
    super.onClose();
  }
} 