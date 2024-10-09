List<ShiftModel> shiftListResponse(var json) {
  return List<ShiftModel>.from(json((x) => ShiftModel.fromJson(x)));
}

class ShiftModel {

  dynamic id;
  String? name;
  dynamic startTime;
  dynamic endTime;

  ShiftModel({
   this.name,
   this.id,
   this.endTime,
   this.startTime,
 });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      name: json[''] ?? "",
      id: json[''] ?? "",
      endTime: json[''] ?? "",
      startTime: json[''] ?? "",
    );
  }
}