import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart' show Logger;

/// Todo项模型
class TodoItem {
  String id;
  String title;
  bool completed;

  TodoItem({required this.id, required this.title, this.completed = false});

  // 从Json转换
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }

  // 转换为Json
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'completed': completed};
  }

  // 创建副本
  TodoItem copyWith({String? id, String? title, bool? completed}) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}

/// Todo列表控制器
class TodoController extends GetxController {
  final _todoLogger = Logger();
  // 使用GetStorage存储Todo项
  final _storage = GetStorage();
  final _storageKey = 'todos';

  // 响应式变量
  RxList<TodoItem> todos = <TodoItem>[].obs;
  Rx<TodoItem?> selectedTodo = Rx<TodoItem?>(null);
  RxBool isLoading = false.obs;
  RxString filterStatus = 'all'.obs; // 'all', 'active', 'completed'

  /// 当控制器初始化时调用
  @override
  void onInit() {
    super.onInit();
    _loadTodos();

    // 示例：添加一个worker监听todos的变化
    ever(todos, (_) {
      _saveTodos();
      _todoLogger.d('【Todo管理】Todo列表已更新，共${todos.length}个项目');
    });

    _todoLogger.d('【Todo管理】控制器初始化完成');
  }

  /// 加载保存的Todo项
  void _loadTodos() {
    try {
      isLoading.value = true;
      final List<dynamic>? storedTodos = _storage.read(_storageKey);
      if (storedTodos != null) {
        todos.value =
            storedTodos.map((item) => TodoItem.fromJson(item)).toList();
        _todoLogger.d('【Todo管理】已加载${todos.length}个Todo项');
      }
    } catch (e) {
      _todoLogger.e('【Todo管理】加载Todo出错: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 保存Todo项到存储
  void _saveTodos() {
    try {
      final List<Map<String, dynamic>> jsonList =
          todos.map((item) => item.toJson()).toList();
      _storage.write(_storageKey, jsonList);
      _todoLogger.d('【Todo管理】已保存${todos.length}个Todo项到本地存储');
    } catch (e) {
      _todoLogger.e('【Todo管理】保存Todo出错: $e');
    }
  }

  /// 添加新的Todo项
  void addTodo(String title) {
    if (title.trim().isEmpty) return;

    final newTodo = TodoItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );

    todos.add(newTodo);
    _todoLogger.d('【Todo管理】添加新Todo: ${newTodo.title}');
  }

  /// 删除一个Todo项
  void removeTodo(String id) {
    todos.removeWhere((todo) => todo.id == id);
    _todoLogger.d('【Todo管理】删除Todo, ID: $id');
  }

  /// 更新Todo的完成状态
  void toggleTodoStatus(String id) {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index >= 0) {
      final todo = todos[index];
      final updatedTodo = todo.copyWith(completed: !todo.completed);
      todos[index] = updatedTodo;
      _todoLogger.d(
        '【Todo管理】切换Todo状态: ${updatedTodo.title} - ${updatedTodo.completed ? "已完成" : "未完成"}',
      );
    }
  }

  /// 清除所有已完成的Todo
  void clearCompleted() {
    todos.removeWhere((todo) => todo.completed);
    _todoLogger.d('【Todo管理】清除所有已完成的Todo');
  }

  /// 获取过滤后的Todo列表
  List<TodoItem> get filteredTodos {
    switch (filterStatus.value) {
      case 'active':
        return todos.where((todo) => !todo.completed).toList();
      case 'completed':
        return todos.where((todo) => todo.completed).toList();
      case 'all':
      default:
        return todos.toList();
    }
  }

  /// 设置过滤条件
  void setFilter(String filter) {
    filterStatus.value = filter;
    _todoLogger.d('【Todo管理】设置过滤条件: $filter');
  }

  /// 获取待办任务计数
  int get activeCount => todos.where((todo) => !todo.completed).length;

  /// 获取已完成任务计数
  int get completedCount => todos.where((todo) => todo.completed).length;
}
