import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:nntu_map/app/modules/layout/main_layout.dart';
import 'package:photo_view/photo_view.dart';

import '../controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
        init: MapController(),
        builder: (controller) {
          return MainLayout(
            enableSafeArea: true,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40),
                  child: PhotoView(
                    enableRotation: true,
                    initialScale: PhotoViewComputedScale.contained * 0.95,
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 1.8,
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.transparent),
                    imageProvider: AssetImage(controller.imageURL),
                    enablePanAlways: true,
                  ),
                ),
                Positioned(
                  top: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: controller.roomController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                      maxLines: 1,
                      autocorrect: false,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        border: const OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(15),
                            // borderSide: BorderSide(
                            //   color: Theme.of(context).colorScheme.primary,
                            // ),
                            ),
                        hintText: 'Введите аудиторию..',
                        // hintStyle: Theme.of(context).textTheme.titleMedium,
                        suffixIcon: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (controller.roomController.text != '') {
                                if (controller.searchRoomNumber !=
                                    int.parse(controller.roomController.text)) {
                                  controller.setSearchRoomNumber(int.parse(
                                      controller.roomController.text));
                                  controller.searchImage(true);
                                } else {
                                  controller.roomController.text = '';
                                  controller.setSearchRoomNumber(0);
                                  controller.searchImage(false);
                                }
                              }
                            },
                            child: (controller.searchRoomNumber !=
                                    int.tryParse(
                                        controller.roomController.text))
                                ? const Icon(
                                    Icons.search_outlined,
                                  )
                                : const Icon(Icons.close)),
                      ),
                      onSubmitted: (value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (controller.roomController.text != '') {
                          controller.setSearchRoomNumber(
                              int.parse(controller.roomController.text));
                          controller.searchImage(true);
                        }
                      },
                      keyboardType: TextInputType.number,
                      onTapOutside: (event) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        AnimatedToggleSwitch<String>.size(
                          indicatorSize: const Size.fromWidth(70),
                          selectedIconScale: sqrt(1),
                          current:
                              controller.typeMenuItem == 0 ? 'Этаж' : 'Корпус',
                          values: const ['Этаж', 'Корпус'],
                          iconOpacity: 1,
                          style: ToggleStyle(
                            indicatorBorderRadius: BorderRadius.circular(13.0),
                            borderRadius: BorderRadius.circular(15.0),
                            indicatorBorder: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                strokeAlign: BorderSide.strokeAlignCenter),
                            borderColor: Theme.of(context).colorScheme.primary,
                            indicatorColor: Theme.of(context).hoverColor,
                          ),
                          borderWidth: 1,
                          iconBuilder: (value) {
                            return Center(
                              child: Text(
                                value.toString(),
                                textAlign: TextAlign.center,
                                style: controller.typeMenuItem ==
                                        (value == 'Этаж' ? 0 : 1)
                                    ? Theme.of(context).textTheme.titleMedium
                                    : Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .color!
                                                .withOpacity(0.8)),
                              ),
                            );
                          },
                          onChanged: (i) {
                            controller.setTypeMenuItem(i == 'Этаж' ? 0 : 1);
                          },
                        ),
                        const SizedBox(width: 16),
                        controller.typeMenuItem == 0
                            ? Expanded(
                                child: AnimatedToggleSwitch<int>.size(
                                  current: controller.floor,
                                  values:
                                      controller.getFloors(controller.building),
                                  style: ToggleStyle(
                                    indicatorBorderRadius:
                                        BorderRadius.circular(13.0),
                                    borderRadius: BorderRadius.circular(15.0),
                                    indicatorBorder: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter),
                                    borderColor:
                                        Theme.of(context).colorScheme.primary,
                                    indicatorColor:
                                        Theme.of(context).hoverColor,
                                  ),
                                  iconOpacity: 1,
                                  borderWidth: 1,
                                  iconBuilder: (value) {
                                    return Center(
                                      child: Text(
                                        value.toString(),
                                        textAlign: TextAlign.center,
                                        style: controller.floor == value
                                            ? Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                            : Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .color!
                                                        .withOpacity(0.8)),
                                      ),
                                    );
                                  },
                                  onChanged: (i) {
                                    print(i);
                                    controller.chengeFloor(i);
                                  },
                                ),
                              )
                            : Expanded(
                                child: AnimatedToggleSwitch<int>.size(
                                  current: controller.building,
                                  values: controller.buildings,
                                  style: ToggleStyle(
                                    indicatorBorderRadius:
                                        BorderRadius.circular(13.0),
                                    borderRadius: BorderRadius.circular(15.0),
                                    indicatorBorder: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter),
                                    borderColor:
                                        Theme.of(context).colorScheme.primary,
                                    indicatorColor:
                                        Theme.of(context).hoverColor,
                                  ),
                                  iconOpacity: 1,
                                  borderWidth: 1,
                                  iconBuilder: (value) {
                                    return Center(
                                      child: Text(
                                        value.toString(),
                                        textAlign: TextAlign.center,
                                        style: controller.building == value
                                            ? Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                            : Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .color!
                                                        .withOpacity(0.8)),
                                      ),
                                    );
                                  },
                                  onChanged: (i) {
                                    controller.chengeBuilding(i);
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
