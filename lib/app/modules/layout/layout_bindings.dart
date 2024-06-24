import 'package:get/get.dart';
import 'package:nntu_map/app/modules/layout/nav_controller.dart';

class NavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavController>(
      () => NavController(),
    );
  }
}
