import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'nav_controller.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  MainLayout({required this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    final NavController navController = Get.find();

    return GetBuilder<NavController>(
        init: NavController(),
        builder: (context) {
          return Scaffold(
            appBar: appBar,
            resizeToAvoidBottomInset: false,
            body: SafeArea(child: child),
            extendBody: true,
            bottomNavigationBar: CrystalNavigationBar(
              currentIndex: navController.getCurrentIndex(),
              onTap: (index) {
                navController.changePage(index);
              },
              height: 10,
              unselectedItemColor: Colors.white70,
              backgroundColor: Colors.black.withOpacity(0.1),
              items: [
                CrystalNavigationBarItem(
                  icon: Icons.list,
                ),
                CrystalNavigationBarItem(
                  icon: Icons.map,
                ),
                CrystalNavigationBarItem(
                  icon: Icons.apps,
                ),
                // Добавьте дополнительные элементы, если необходимо
              ],
            ),
          );
        });
  }
}
