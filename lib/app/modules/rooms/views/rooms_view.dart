import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nntu_map/app/modules/layout/main_layout.dart';

import '../controllers/rooms_controller.dart';

class RoomsView extends GetView<RoomsController> {
  const RoomsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Этот экран находится на стадии разработки',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
