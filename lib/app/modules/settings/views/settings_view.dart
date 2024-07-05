import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nntu_map/app/core/controllers/theme_controller.dart';
import 'package:nntu_map/app/modules/rooms/controllers/rooms_controller.dart';
import 'package:settings_ui/settings_ui.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
        init: ThemeController(),
        builder: (themeController) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Настройки'),
              centerTitle: false,
            ),
            body: SettingsList(
              platform: DevicePlatform.device,
              sections: [
                SettingsSection(
                  title: Text('Основные'),
                  tiles: [
                    SettingsTile.switchTile(
                      initialValue: themeController.currentTheme == 'dark',
                      onToggle: (value) {
                        themeController.setThemeMode(value ? 'dark' : 'light');
                      },
                      title: Text('Темная тема'),
                    )
                  ],
                ),
                SettingsSection(
                  title: const Text('DEBUG'),
                  tiles: [
                    SettingsTile(
                      title: Text('Сбросить данные аудиторий'),
                      onPressed: (context) {
                        RoomsController.deleteAllData();
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
