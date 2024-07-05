import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ThemeController extends GetxController {
  // Создаем статический экземпляр ThemeController
  static ThemeController get to => Get.find();

  // Переменная для хранения текущей темы
  final theme = "system".obs;

  // Коробка Hive для хранения данных
  late Box box;

  // Переменная для хранения текущего режима темы
  late ThemeMode _themeMode;

  // Геттер для получения текущего режима темы
  ThemeMode get themeMode => _themeMode;

  // Геттер для получения текущей темы
  String get currentTheme => theme.value;

  // Метод для инициализации Hive и открытия коробки
  Future<void> initHive() async {
    box = await Hive.openBox('settings'); // Открываем коробку 'settings'
    getThemeModeFromStore(); // Получаем режим темы из хранилища
  }

  // Метод для установки режима темы и сохранения его в хранилище
  Future<void> setThemeMode(String value) async {
    theme.value = value; // Обновляем значение темы
    _themeMode = getThemeModeFromString(value); // Получаем ThemeMode из строки
    Get.changeThemeMode(_themeMode); // Меняем режим темы в приложении
    await box.put('theme', value); // Сохраняем тему в хранилище
    update(); // Обновляем контроллер
  }

  // Метод для получения режима темы из строки
  ThemeMode getThemeModeFromString(String themeString) {
    ThemeMode setThemeMode = ThemeMode.system;
    if (themeString == 'light') {
      setThemeMode = ThemeMode.light;
    }
    if (themeString == 'dark') {
      setThemeMode = ThemeMode.dark;
    }
    return setThemeMode;
  }

  // Метод для получения режима темы из хранилища
  getThemeModeFromStore() async {
    String themeString = box.get('theme',
        defaultValue:
            'system'); // Читаем тему из коробки, по умолчанию 'system'
    setThemeMode(themeString); // Устанавливаем тему
  }

  // Метод для проверки, включен ли темный режим
  bool get isDarkModeOn {
    if (currentTheme == 'system') {
      if (PlatformDispatcher.instance.platformBrightness == Brightness.dark) {
        return true; // Темный режим включен системой
      }
    }
    if (currentTheme == 'dark') {
      return true; // Пользователь установил темный режим
    }
    return false; // Темный режим не включен
  }
}
