import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nntu_map/app/modules/rooms/rooms_model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class RoomsController extends GetxController {
  static const String currentFormatVersion = 'v1';
  final String url = "https://vvadev.ru/files/rooms.json";

  List<RoomData> roomsData = [];
  List<RoomData> filteredRoomsData = [];
  bool isLoading = true;
  bool hasError = false;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
    fetchRoomsData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  static Future<void> deleteAllData() async {
    var box = await Hive.openBox('roomsBox');
    await box.clear();
    Get.snackbar(
      '[DEBUG]',
      'Данные аудиторий удалены',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.8),
    );
  }

  Future<void> fetchRoomsData() async {
    try {
      var box = await Hive.openBox('roomsBox');
      var storedData = box.get('roomsData');
      var storedVersion = box.get('version', defaultValue: 0);

      if (storedData != null) {
        // Данные есть в базе, загружаем их
        MainRoomsModel storedModel =
            MainRoomsModel.fromJson(jsonDecode(storedData));
        roomsData = storedModel.getRoomsByVersion(currentFormatVersion);
        filteredRoomsData = roomsData;

        fetchAndSaveDataFromServer(storedVersion);
      } else {
        // Данных нет, пробуем загрузить с сервера
        await fetchAndSaveDataFromServer(storedVersion);
      }
    } catch (e) {
      print(e);
      hasError = true;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchAndSaveDataFromServer(int storedVersion) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        MainRoomsModel newData = MainRoomsModel.fromJson(jsonResponse);

        if (newData.version > storedVersion) {
          // Удаляем старые данные и сохраняем новые
          var box = await Hive.openBox('roomsBox');
          await box.clear();
          await box.put('roomsData', jsonEncode(newData.toJson()));
          await box.put('version', newData.version);
          roomsData = newData.getRoomsByVersion(currentFormatVersion);
          filteredRoomsData = roomsData;

          Get.snackbar(
            'Данные обновлены',
            'Новые данные успешно загружены с сервера',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.greenAccent.withOpacity(0.8),
          );
        }
      } else {
        hasError = true;
      }
    } catch (e) {
      print(e);
      // hasError = true;
    } finally {
      update();
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    filteredRoomsData = roomsData.where((room) {
      return room.name.toLowerCase().contains(query) ||
          room.room.toString().contains(query);
    }).toList();
    update();
  }
}
