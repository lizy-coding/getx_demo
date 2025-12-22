import 'package:get/get.dart';
import 'package:getx_demo/app/core/logger.dart' show AppLogger;
import 'package:getx_demo/app/routes/app_routes.dart';

enum LifecycleRegisterMode { defaultMode, fenix, permanent }

class LifecycleSnapshot {
  final RxInt initCount = 0.obs;
  final RxInt readyCount = 0.obs;
  final RxInt closeCount = 0.obs;
  final RxInt controllerHashCode = 0.obs;
}

class LifecycleRegistry {
  static final Map<String, LifecycleSnapshot> _snapshots = {};

  static LifecycleSnapshot snapshotFor(String tag) {
    return _snapshots.putIfAbsent(tag, () => LifecycleSnapshot());
  }

  static void recordInit(String tag, int hashCode) {
    final snapshot = snapshotFor(tag);
    snapshot.initCount.value += 1;
    snapshot.controllerHashCode.value = hashCode;
  }

  static void recordReady(String tag) {
    final snapshot = snapshotFor(tag);
    snapshot.readyCount.value += 1;
  }

  static void recordClose(String tag) {
    final snapshot = snapshotFor(tag);
    snapshot.closeCount.value += 1;
  }
}

class LifecycleProbeController extends GetxController {
  LifecycleProbeController({required this.modeTag});

  final String modeTag;

  AppLogger get _logger => Get.find<AppLogger>();

  @override
  void onInit() {
    super.onInit();
    LifecycleRegistry.recordInit(modeTag, hashCode);
    _logger.d('【Lifecycle】$modeTag onInit -> $hashCode');
  }

  @override
  void onReady() {
    super.onReady();
    LifecycleRegistry.recordReady(modeTag);
    _logger.d('【Lifecycle】$modeTag onReady -> $hashCode');
  }

  @override
  void onClose() {
    LifecycleRegistry.recordClose(modeTag);
    _logger.d('【Lifecycle】$modeTag onClose -> $hashCode');
    super.onClose();
  }
}

class LifecycleLabController extends GetxController {
  final Rx<LifecycleRegisterMode> currentMode =
      LifecycleRegisterMode.defaultMode.obs;
  final RxBool isRegistered = false.obs;
  final RxBool forceDelete = false.obs;
  final RxString currentRoute = ''.obs;

  LifecycleSnapshot get currentSnapshot =>
      LifecycleRegistry.snapshotFor(_tagForMode(currentMode.value));

  AppLogger get _logger => Get.find<AppLogger>();

  @override
  void onInit() {
    super.onInit();
    _syncRegistrationState();
    _updateRoute();
  }

  void setMode(LifecycleRegisterMode mode) {
    currentMode.value = mode;
    _syncRegistrationState();
  }

  void registerCurrent() {
    final mode = currentMode.value;
    final tag = _tagForMode(mode);

    if (_isAlreadyRegistered(tag)) {
      _logger.d('【Lifecycle】$tag 已存在，跳过注册');
      _syncRegistrationState();
      return;
    }

    if (mode == LifecycleRegisterMode.fenix) {
      Get.lazyPut<LifecycleProbeController>(
        () => LifecycleProbeController(modeTag: tag),
        tag: tag,
        fenix: true,
      );
    } else if (mode == LifecycleRegisterMode.permanent) {
      Get.put<LifecycleProbeController>(
        LifecycleProbeController(modeTag: tag),
        tag: tag,
        permanent: true,
      );
    } else {
      Get.put<LifecycleProbeController>(
        LifecycleProbeController(modeTag: tag),
        tag: tag,
      );
    }

    _logger.d('【Lifecycle】$tag 已注册');
    _syncRegistrationState();
  }

  void findCurrent() {
    final tag = _tagForMode(currentMode.value);
    try {
      Get.find<LifecycleProbeController>(tag: tag);
      _logger.d('【Lifecycle】找到实例: $tag');
    } catch (_) {
      _logger.d('【Lifecycle】未找到实例: $tag');
    }
    _syncRegistrationState();
  }

  void deleteCurrent() {
    final tag = _tagForMode(currentMode.value);
    final deleted = Get.delete<LifecycleProbeController>(
      tag: tag,
      force: forceDelete.value,
    );
    _logger.d('【Lifecycle】删除 $tag -> $deleted');
    _syncRegistrationState();
  }

  void pushChild() {
    Get.toNamed(Routes.LIFECYCLE_CHILD);
    _updateRoute();
  }

  void goBack() {
    Get.back();
    _updateRoute();
  }

  String labelForMode(LifecycleRegisterMode mode) {
    if (mode == LifecycleRegisterMode.fenix) {
      return 'lifecycle_mode_fenix'.tr;
    }
    if (mode == LifecycleRegisterMode.permanent) {
      return 'lifecycle_mode_permanent'.tr;
    }
    return 'lifecycle_mode_default'.tr;
  }

  bool _isAlreadyRegistered(String tag) {
    return Get.isRegistered<LifecycleProbeController>(tag: tag);
  }

  void _syncRegistrationState() {
    final tag = _tagForMode(currentMode.value);
    isRegistered.value = Get.isRegistered<LifecycleProbeController>(tag: tag);
  }

  void _updateRoute() {
    currentRoute.value = Get.currentRoute;
  }

  String _tagForMode(LifecycleRegisterMode mode) {
    if (mode == LifecycleRegisterMode.fenix) {
      return 'fenix';
    }
    if (mode == LifecycleRegisterMode.permanent) {
      return 'permanent';
    }
    return 'default';
  }
}
