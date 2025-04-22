import 'package:get/get.dart';

/// 应用翻译类
/// 用于管理应用的多语言支持
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        // 英文翻译
        'en_US': {
          // 通用
          'app_name': 'GetX Demo',
          'ok': 'OK',
          'cancel': 'Cancel',
          'save': 'Save',
          'delete': 'Delete',
          'edit': 'Edit',
          
          // 主页
          'home_title': 'GetX Demo Home',
          'simple_counter': 'Simple Counter',
          'reactive_counter': 'Reactive Counter',
          'todo_list': 'Todo List',
          'theme_settings': 'Theme Settings',
          'language_settings': 'Language Settings',
          
          // 简单计数器页面
          'simple_counter_title': 'Simple Counter Demo',
          'increment': 'Increment',
          'decrement': 'Decrement',
          'reset': 'Reset',
          'counter_value': 'Counter Value: @value',
          
          // 响应式计数器页面
          'reactive_counter_title': 'Reactive Counter Demo',
          'count_value': 'Count Value: @value',
          'is_even': 'The number is even',
          'is_odd': 'The number is odd',
          
          // Todo页面
          'todo_title': 'Todo List',
          'add_todo': 'Add Todo',
          'todo_hint': 'Enter task here...',
          'no_todos': 'No todos yet.',
          'clear_completed': 'Clear Completed',
          'completed': 'Completed',
          'active': 'Active',
          'all': 'All',
          'items_left': '@count items left',
          
          // 主题设置页面
          'theme_title': 'Theme Settings',
          'dark_mode': 'Dark Mode',
          'light_mode': 'Light Mode',
          'system_mode': 'System Mode',
          'current_theme': 'Current Theme: @theme',
          
          // 语言设置页面
          'language_title': 'Language Settings',
          'english': 'English',
          'chinese': 'Chinese',
          'current_language': 'Current Language: @language',
        },
        
        // 中文翻译
        'zh_CN': {
          // 通用
          'app_name': 'GetX 演示',
          'ok': '确定',
          'cancel': '取消',
          'save': '保存',
          'delete': '删除',
          'edit': '编辑',
          
          // 主页
          'home_title': 'GetX 演示首页',
          'simple_counter': '简单计数器',
          'reactive_counter': '响应式计数器',
          'todo_list': '待办事项',
          'theme_settings': '主题设置',
          'language_settings': '语言设置',
          
          // 简单计数器页面
          'simple_counter_title': '简单计数器演示',
          'increment': '增加',
          'decrement': '减少',
          'reset': '重置',
          'counter_value': '计数值: @value',
          
          // 响应式计数器页面
          'reactive_counter_title': '响应式计数器演示',
          'count_value': '计数值: @value',
          'is_even': '这是偶数',
          'is_odd': '这是奇数',
          
          // Todo页面
          'todo_title': '待办事项',
          'add_todo': '添加待办',
          'todo_hint': '在此输入任务...',
          'no_todos': '暂无待办事项',
          'clear_completed': '清除已完成',
          'completed': '已完成',
          'active': '未完成',
          'all': '全部',
          'items_left': '剩余 @count 项',
          
          // 主题设置页面
          'theme_title': '主题设置',
          'dark_mode': '深色模式',
          'light_mode': '浅色模式',
          'system_mode': '跟随系统',
          'current_theme': '当前主题: @theme',
          
          // 语言设置页面
          'language_title': '语言设置',
          'english': '英文',
          'chinese': '中文',
          'current_language': '当前语言: @language',
        },
      };
} 