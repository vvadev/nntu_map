import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'map_controller.dart';

// Карта вуза

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final roomController = TextEditingController();

  late PackageInfo packageInfo;

  void getInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
        init: MapController(),
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: false,
              title: const Text('NNTU Map'),
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      barrierColor: Colors.black38,
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('О приложении'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                'Данное приложение было разработано в качестве временной замены приложения НГТУ.\nОно не является официальным и может содержать в себе баги и прочие ошибки.\nРазработчик не несет ответственности за какие-либо неполадки.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                "Версия: ${packageInfo.version} (${packageInfo.buildNumber})",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const Divider(),
                              const InkWell(
                                onTap: _launchUrl,
                                child: Text('Developed by VVA Dev'),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                ),
              ],
            ),
            body: Stack(
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
                      controller: roomController,
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
                              if (roomController.text != '') {
                                if (controller.searchRoomNumber !=
                                    int.parse(roomController.text)) {
                                  controller.setSearchRoomNumber(
                                      int.parse(roomController.text));
                                  controller.searchImage(true);
                                } else {
                                  roomController.text = '';
                                  controller.setSearchRoomNumber(0);
                                  controller.searchImage(false);
                                }
                              }
                            },
                            child: (controller.searchRoomNumber !=
                                    int.tryParse(roomController.text))
                                ? const Icon(
                                    Icons.search_outlined,
                                  )
                                : const Icon(Icons.close)),
                      ),
                      onSubmitted: (value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (roomController.text != '') {
                          controller.setSearchRoomNumber(
                              int.parse(roomController.text));
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

Future<void> _launchUrl() async {
  if (!await launchUrlString(
    'https://vvadev.ru',
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch https://vvadev.ru');
  }
}
