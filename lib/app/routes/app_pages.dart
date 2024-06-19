import 'package:get/get.dart';

import '../modules/apps/bindings/apps_binding.dart';
import '../modules/apps/views/apps_view.dart';
import '../modules/map/bindings/map_binding.dart';
import '../modules/map/views/map_view.dart';
import '../modules/rooms/bindings/rooms_binding.dart';
import '../modules/rooms/views/rooms_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAP;

  static final routes = [
    GetPage(
      name: _Paths.MAP,
      page: () => const MapView(),
      binding: MapBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.APPS,
      page: () => const AppsView(),
      binding: AppsBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.ROOMS,
      page: () => const RoomsView(),
      binding: RoomsBinding(),
      transition: Transition.noTransition,
    ),
  ];
}
