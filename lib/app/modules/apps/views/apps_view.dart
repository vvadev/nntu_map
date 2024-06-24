import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nntu_map/app/modules/layout/main_layout.dart';
import 'package:nntu_map/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controllers/apps_controller.dart';

class AppsView extends GetView<AppsController> {
  const AppsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppsController>(
        init: AppsController(),
        builder: (context) {
          return MainLayout(
            appBar: AppBar(
              title: const Text('NNTU Map'),
              centerTitle: false,
            ),
            child: GridView(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 128),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
              children: List.generate(
                options.length,
                (index) => AppsItemWidget(
                  layout: options[index],
                ),
              ),
            ),
          );
        });
  }
}

class _AppsItemClass {
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  _AppsItemClass(
      {required this.title,
      required this.icon,
      required this.route,
      required this.color});
}

List options = [
  _AppsItemClass(
      title: 'Настройки',
      icon: Icons.settings_outlined,
      route: Routes.SETTINGS,
      color: Colors.grey),
  _AppsItemClass(
      title: 'О\nприложении',
      icon: Icons.info_outline,
      route: Routes.ABOUT,
      color: Colors.cyan),
  _AppsItemClass(
      title: 'Поддержать\nпроект',
      icon: Icons.payments_outlined,
      route: 'https://pay.cloudtips.ru/p/1adcfd32',
      color: Colors.greenAccent),
];

class AppsItemWidget extends StatelessWidget {
  final _AppsItemClass layout;

  const AppsItemWidget({
    super.key,
    required this.layout,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (layout.route.contains('https://')) {
          launchUrlString(layout.route);
        } else {
          Get.toNamed(layout.route);
        }
      },
      child: Card(
        elevation: 4,
        shadowColor: layout.color,
        color: layout.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: Center(
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Icon(layout.icon, size: 120, color: Colors.black26),
                  )),
              Positioned(
                  bottom: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      layout.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
