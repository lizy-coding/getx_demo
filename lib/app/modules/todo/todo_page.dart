import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_demo/app/controllers/todo_controller.dart';
import 'package:getx_demo/app/core/logger.dart' show AppLogger;

/// Todo页面
/// 展示GetX的数据持久化功能
class TodoPage extends GetView<TodoController> {
  TodoPage({super.key});

  // 文本编辑控制器
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('todo_title'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // 添加新待办的输入框
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'todo_hint'.tr,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _addTodo();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _addTodo, child: Text('add_todo'.tr)),
              ],
            ),
          ),

          // 过滤选项
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 左侧显示剩余项目数
                Obx(
                  () => Text(
                    'items_left'.trParams({
                      'count': controller.activeCount.toString(),
                    }),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                // 右侧过滤按钮
                Row(
                  children: [
                    _buildFilterButton('all'.tr, 'all'),
                    const SizedBox(width: 8),
                    _buildFilterButton('active'.tr, 'active'),
                    const SizedBox(width: 8),
                    _buildFilterButton('completed'.tr, 'completed'),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // Todo列表
          Expanded(
            child: Obx(() {
              final logger = Get.find<AppLogger>();
              logger.d(
                '【Todo管理】重建Todo列表UI，已过滤: ${controller.filterStatus.value}',
              );

              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final todos = controller.filteredTodos;

              if (todos.isEmpty) {
                return Center(
                  child: Text(
                    'no_todos'.tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return _buildTodoItem(todo);
                },
              );
            }),
          ),

          // 底部操作按钮
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                controller.clearCompleted();

                // 使用GetX对话框
                Get.dialog(
                  AlertDialog(
                    title: Text('todo_title'.tr),
                    content: const Text('所有已完成的任务已被清除'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('ok'.tr),
                      ),
                    ],
                  ),
                );
              },
              child: Text('clear_completed'.tr),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建Todo项
  Widget _buildTodoItem(TodoItem todo) {
    return ListTile(
      leading: Checkbox(
        value: todo.completed,
        onChanged: (value) {
          controller.toggleTodoStatus(todo.id);
        },
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.completed ? TextDecoration.lineThrough : null,
          color: todo.completed ? Colors.grey : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          controller.removeTodo(todo.id);
        },
      ),
    );
  }

  /// 构建过滤按钮
  Widget _buildFilterButton(String text, String filter) {
    return Obx(
      () => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              controller.filterStatus.value == filter
                  ? Get.theme.colorScheme.primary
                  : Get.theme.colorScheme.surfaceVariant,
          foregroundColor:
              controller.filterStatus.value == filter
                  ? Get.theme.colorScheme.onPrimary
                  : Get.theme.colorScheme.onSurfaceVariant,
        ),
        onPressed: () => controller.setFilter(filter),
        child: Text(text),
      ),
    );
  }

  /// 添加新的Todo
  void _addTodo() {
    if (textController.text.trim().isNotEmpty) {
      controller.addTodo(textController.text);
      textController.clear();
    } else {
      // 使用GetX的Snackbar
      Get.snackbar(
        'todo_title'.tr,
        '任务标题不能为空',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }
}
