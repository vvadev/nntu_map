import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nntu_map/app/modules/layout/main_layout.dart';
import 'package:nntu_map/app/modules/layout/nav_controller.dart';
import 'package:nntu_map/app/routes/app_pages.dart';

import '../controllers/rooms_controller.dart';

class RoomsView extends GetView<RoomsController> {
  const RoomsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBar: AppBar(
        title: const Text("Важные места"),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                RoomsController.deleteAllData();
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      child: GetBuilder<RoomsController>(
        init: RoomsController(),
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.hasError) {
            return const Center(child: Text('Ошибка загрузки данных'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: TextField(
                    controller: controller.searchController,
                    decoration: const InputDecoration(
                      labelText: 'Название аудитории',
                      border: OutlineInputBorder(),
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.filteredRoomsData.length,
                    itemBuilder: (context, index) {
                      final room = controller.filteredRoomsData[index];
                      return ListTile(
                        title: Text(room.name),
                        subtitle: Text('Аудитория: ${room.room}'),
                        onTap: () {
                          final NavController navController = Get.find();
                          navController
                              .changePageByString(Routes.MAP, [room.room]);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
