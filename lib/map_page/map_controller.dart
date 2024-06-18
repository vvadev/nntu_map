import 'package:get/get.dart';

class MapController extends GetxController {
  // выбранный этаж
  int _floor = 1;
  int get floor => _floor;

  // выбранный корпус
  int _building = 1;
  int get building => _building;

  // отображать выбор этажей или корпусов
  int _typeMenuItem = 1;
  int get typeMenuItem => _typeMenuItem;

  final _buildings = [1, 2, 3, 4, 5, 6];
  List<int> get buildings => _buildings;
  // этажи в каждом из корпусов
  final _buildingFloors = [
    [1, 2, 3],
    [1, 2, 3],
    [1, 2, 3],
    [1, 2, 3, 4],
    [1, 2, 3, 4],
    [0, 1, 2, 3, 4, 5]
  ];
  List<List<int>> get buildingFloors => _buildingFloors;
  List<int> getFloors(int i) {
    return _buildingFloors[i - 1];
  }

  // Установить тип выбранного пункта меню
  void setTypeMenuItem(int i) async {
    if (_building == 5) {
      _building = 4;
      update();
      await Future.delayed(
        const Duration(milliseconds: 80),
      );
      _building = 5;
    }
    // _floor = 1;
    if (_searchRoomNumber == 0) {
      _floor = 1;
    } else {
      int requestedFloor = ((_searchRoomNumber / 100) % 10).toInt();
      _floor = requestedFloor;
    }
    _typeMenuItem = i;
    searchImage(false);
  }

  void chengeBuilding(int i) {
    _building = i;
    searchImage(false);
  }

  Future<void> chengeFloor(int i, {int reqBuilding = -1}) async {
    if (reqBuilding != -1 &&
        getFloors(_building).length > getFloors(reqBuilding).length) {
      _floor = 1;
      await Future.delayed(
        const Duration(milliseconds: 800),
      );
      _floor = i;
    } else {
      _floor = i;
    }
    searchImage(false);
  }

  String _imageURL = 'assets/navigate/1/1level non-active.png';
  String get imageURL => _imageURL;

  // void loadImage() {
  //   _imageURL =
  //       'assets/navigate/${_building}/${_floor}level non-active.png';
  //   notifyListeners();
  // }

  int _searchRoomNumber = 0;
  int get searchRoomNumber => _searchRoomNumber;

  // Установить номер комнаты для поиска
  void setSearchRoomNumber(int room) {
    _searchRoomNumber = room;
    _typeMenuItem = 0;
  }

  void searchImage(bool chengePage) async {
    // Извлечь информацию об этаже и корпусе из номера комнаты для поиска
    int requestedFloor = ((_searchRoomNumber / 100) % 10).toInt();
    int requestedBuilding = (_searchRoomNumber) ~/ 1000;

    // Проверить, являются ли запрошенный этаж и корпус допустимыми, и обновить их при необходимости
    if (requestedBuilding >= 1 && requestedBuilding <= 6 && chengePage) {
      if (_buildingFloors[requestedBuilding - 1].contains(requestedFloor)) {
        await chengeFloor(requestedFloor, reqBuilding: requestedBuilding);
        // _floor = requestedFloor;
        _building = requestedBuilding;
        update();
      }
    }

    // Специальный случай для определенного диапазона номеров комнат
    if (_searchRoomNumber >= 6103 && _searchRoomNumber <= 6110) {
      requestedFloor = 0;
    }

    if (_searchRoomNumber != 0) {
      if (_floor == requestedFloor && _building == requestedBuilding) {
        _imageURL = 'assets/navigate/$_building/$_searchRoomNumber.png';
      } else {
        if (requestedBuilding == _building) {
          switch (_building) {
            case 1:
              final weirdBlock = [1280, 1281, 1361, 1362];
              if (_floor < requestedFloor &&
                  weirdBlock.contains(_searchRoomNumber)) {
                _imageURL =
                    'assets/navigate/$_building/${_floor}level up weird.png';
              } else if (_floor < requestedFloor) {
                _imageURL = 'assets/navigate/$_building/${_floor}level up.png';
              } else if (_searchRoomNumber == 1161 && _floor == 2) {
                _imageURL =
                    'assets/navigate/$_building/${_floor}level down.png';
              } else {
                _imageURL = showemptyfloors();
              }
              break;
            case 2:
              if (_floor < requestedFloor) {
                _imageURL = 'assets/navigate/$_building/${_floor}level up.png';
              } else if (_floor == 2 && requestedFloor == 1) {
                _imageURL =
                    'assets/navigate/$_building/${_floor}level down.png';
              } else {
                _imageURL = showemptyfloors();
              }
              break;
            case 3:
              if (_floor < requestedFloor) {
                _imageURL = 'assets/navigate/$_building/${_floor}level up.png';
              } else {
                _imageURL = showemptyfloors();
              }
              break;
            case 4:
              if (((_searchRoomNumber > 4400 && _searchRoomNumber < 4410) ||
                      (_searchRoomNumber > 4303 && _searchRoomNumber < 4313)) &&
                  (_floor < requestedFloor)) {
                _imageURL =
                    'assets/navigate/$_building/${_floor}level up sec.png';
              } else if (_floor < requestedFloor) {
                _imageURL = 'assets/navigate/$_building/${_floor}level up.png';
              } else {
                _imageURL = showemptyfloors();
              }
              break;
            case 5:
              if (((requestedFloor == 2 && _floor == 1) ||
                      (_searchRoomNumber == 5301 ||
                          _searchRoomNumber == 5302) ||
                      (_searchRoomNumber == 5401 ||
                          _searchRoomNumber == 5402)) &&
                  _floor < requestedFloor) {
                _imageURL =
                    'assets/navigate/$_building/${_floor}level up sec.png';
              } else if (_floor > 0 && _floor < requestedFloor) {
                _imageURL = 'assets/navigate/$_building/${_floor}level up.png';
              } else {
                _imageURL = showemptyfloors();
              }
              break;
            case 6:
              if (_floor > 1 && _floor < requestedFloor) {
                _imageURL = 'assets/navigate/$_building/${_floor}level up.png';
              } else if (_floor > requestedFloor && requestedFloor != 0) {
                _imageURL = showemptyfloors();
              } else if (_floor == 1) {
                if (_searchRoomNumber == 6243) {
                  _imageURL =
                      'assets/navigate/$_building/${_floor}level up 6243.png';
                } else if (_searchRoomNumber == 6244) {
                  _imageURL =
                      'assets/navigate/$_building/${_floor}level up 6244.png';
                } else if (_searchRoomNumber == 6245 ||
                    _searchRoomNumber == 6246) {
                  _imageURL =
                      'assets/navigate/$_building/${_floor}level up B3.png';
                } else if (_searchRoomNumber >= 6247 &&
                    _searchRoomNumber <= 6257) {
                  _imageURL =
                      'assets/navigate/$_building/${_floor}level up B4.png';
                } else if (_searchRoomNumber == 6258 ||
                    _searchRoomNumber == 6259) {
                  _imageURL =
                      'assets/navigate/$_building/${_floor}level up B5.png';
                } else if (_searchRoomNumber >= 6260 &&
                    _searchRoomNumber <= 6269) {
                  _imageURL =
                      'assets/navigate/$_building/${_floor}level up B6.png';
                } else if (_searchRoomNumber == 6270) {
                  _imageURL =
                      'assets/navigate/$_building/${_floor}level up B7.png';
                } else if (_searchRoomNumber == 6020) {
                  _imageURL =
                      'assets/navigate/$_building/${_floor}level down 6020.png';
                } else if (_searchRoomNumber >= 6103 &&
                    _searchRoomNumber <= 6110) {
                  _imageURL =
                      'assets/navigate/$_building/${_floor}level down B3.png';
                } else if (_searchRoomNumber >= 6022 &&
                    _searchRoomNumber <= 6043) {
                  _imageURL =
                      'assets/navigate/$_building/${_floor}level down B4 B6.png';
                } else {
                  _imageURL =
                      'assets/navigate/$_building/${_floor}level up.png';
                }
              } else if (requestedFloor == 0 && _floor > 1) {
                _imageURL = showemptyfloors();
              }
              break;
            default:
              _imageURL = showemptyfloors();
          }
        } else {
          _imageURL = showemptyfloors();
        }
      }
    } else {
      _imageURL = showemptyfloors();
    }

    update();
  }

  String showemptyfloors() {
    return 'assets/navigate/$_building/${_floor}level non-active.png';
  }
}
