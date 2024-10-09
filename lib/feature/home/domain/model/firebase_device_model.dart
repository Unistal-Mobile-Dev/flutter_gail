List<FirebaseDeviceModel> firebaseDeviceListResponse(var json) {
  return List<FirebaseDeviceModel>.from(
      json.map((x) => FirebaseDeviceModel.fromJson(x)));
}

class FirebaseDeviceModel {
  dynamic id;
  String? deviceId;
  String? userId;
  String? firebaseId;

  FirebaseDeviceModel({this.id, this.firebaseId, this.deviceId, this.userId});

  factory FirebaseDeviceModel.fromJson(Map<String, dynamic> json) {
    return FirebaseDeviceModel(
      id: json['id'] ?? "",
      firebaseId: json['firebase_id'] ?? "",
      deviceId: json['device_id'] ?? "",
      userId: json['user_id'] ?? "",
    );
  }
}
