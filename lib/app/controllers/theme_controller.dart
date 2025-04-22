import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// 主题控制器
/// 用于管理应用的主题
class ThemeController extends GetxController {
  // 使用Get Storage存储主题设置
  final _storage = GetStorage();
  final _themeKey = 'isDarkMode';
  
  // 响应式变量，跟踪当前主题状态
  RxBool isDarkMode = false.obs;
  
  /// 获取当前主题模式
  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  
  /// 当控制器被创建时调用
  @override
  void onInit() {
    super.onInit();
    // 从存储中加载主题设置
    isDarkMode.value = _loadThemeFromStorage();
    print('【主题管理】初始化主题: ${isDarkMode.value ? "深色" : "浅色"}');
  }
  
  /// 切换主题
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _saveThemeToStorage();
    // 使用Get.changeTheme改变应用主题
    Get.changeThemeMode(themeMode);
    print('【主题管理】切换主题: ${isDarkMode.value ? "深色" : "浅色"}');
  }
  
  /// 从存储中加载主题设置
  bool _loadThemeFromStorage() {
    return _storage.read(_themeKey) ?? false;
  }
  
  /// 将主题设置保存到存储
  void _saveThemeToStorage() {
    _storage.write(_themeKey, isDarkMode.value);
  }
  
  /// 设置特定的主题
  void setTheme(bool isDark) {
    if (isDarkMode.value != isDark) {
      isDarkMode.value = isDark;
      _saveThemeToStorage();
      Get.changeThemeMode(themeMode);
      print('【主题管理】设置主题: ${isDarkMode.value ? "深色" : "浅色"}');
    }
  }
}

/// 应用的主题数据
class AppTheme {
  /// 浅色主题
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
  );
  
  /// 深色主题
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.teal,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    ),
  );
} 