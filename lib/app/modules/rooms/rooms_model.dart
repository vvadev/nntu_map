class RoomData {
  final String name;
  final int room;

  RoomData({
    required this.name,
    required this.room,
  });

  factory RoomData.fromJson(Map<String, dynamic> json) {
    return RoomData(
      name: json['name'],
      room: json['room'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'room': room,
    };
  }
}

class RoomsData {
  final List<RoomData> v1;
  final List<RoomData> v2;

  RoomsData({
    required this.v1,
    required this.v2,
  });

  factory RoomsData.fromJson(Map<String, dynamic> json) {
    var v1List = json['v1'] as List;
    var v2List = json['v2'] as List;

    List<RoomData> v1 = v1List.map((i) => RoomData.fromJson(i)).toList();
    List<RoomData> v2 = v2List.map((i) => RoomData.fromJson(i)).toList();

    return RoomsData(
      v1: v1,
      v2: v2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'v1': v1.map((roomData) => roomData.toJson()).toList(),
      'v2': v2.map((roomData) => roomData.toJson()).toList(),
    };
  }
}

class MainRoomsModel {
  final int version;
  final RoomsData data;

  MainRoomsModel({
    required this.version,
    required this.data,
  });

  factory MainRoomsModel.fromJson(Map<String, dynamic> json) {
    return MainRoomsModel(
      version: json['version'],
      data: RoomsData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'data': data.toJson(),
    };
  }

  List<RoomData> getRoomsByVersion(String version) {
    switch (version) {
      case "v1":
        return data.v1;
      case "v2":
        return data.v2;
      default:
        return [];
    }
  }

  List<RoomData> getAllRooms() {
    return [...data.v1, ...data.v2];
  }
}
