import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_demo/app/core/logger.dart' show AppLogger;
import 'package:getx_demo/app/core/storage_keys.dart';

class AuthService extends GetxService {
  final GetStorage _storage = GetStorage();
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLoginStatus();
  }

  void login() {
    isLoggedIn.value = true;
    _storage.write(StorageKeys.isLoggedIn, true);
    _logger.d('【Auth】登录成功');
  }

  void logout() {
    isLoggedIn.value = false;
    _storage.remove(StorageKeys.isLoggedIn);
    _logger.d('【Auth】已登出并清理登录状态');
  }

  void _loadLoginStatus() {
    final stored = _storage.read(StorageKeys.isLoggedIn);
    if (stored is bool) {
      isLoggedIn.value = stored;
    }
    _logger.d('【Auth】登录状态加载完成: ${isLoggedIn.value}');
  }

  AppLogger get _logger => Get.find<AppLogger>();
}
