import 'package:get/get.dart';
import 'package:nntu_map/app/routes/app_pages.dart';

class NavController extends GetxController {
  int currentIndex = 1;

  @override
  void onInit() {
    super.onInit();
    // Get.routing.obs.listen(handleRouteChanged);
    // ever(Get.currentRoute.obs, handleRouteChanged);
  }

  void handleRouteChanged(String? route) {
    switch (route) {
      case Routes.ROOMS:
        currentIndex = 0;
        update();
        break;
      case Routes.MAP:
        currentIndex = 1;
        update();
        break;
      case Routes.APPS:
        currentIndex = 2;
        update();
        break;
    }
  }

  int getCurrentIndex() {
    return currentIndex;
  }

  void changePage(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed(Routes.ROOMS);
        handleRouteChanged(Routes.ROOMS);
        break;
      case 1:
        Get.offAllNamed(Routes.MAP);
        handleRouteChanged(Routes.MAP);
        break;
      case 2:
        Get.offAllNamed(Routes.APPS);
        handleRouteChanged(Routes.APPS);
        break;
    }
  }

  void changePageByString(String route, [dynamic arguments]) {
    Get.offAllNamed(route, arguments: arguments);
    handleRouteChanged(route);
  }
}
