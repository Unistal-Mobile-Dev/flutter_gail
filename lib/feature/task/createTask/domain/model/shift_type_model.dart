List<ShiftTypeModel> shiftListResponse(var json) {
  return List<ShiftTypeModel>.from(json((x) => ShiftTypeModel.fromJson(x)));
}

class ShiftTypeModel {

  dynamic id;
  String? name;
  String? sgCode;
  dynamic startTime;
  dynamic endTime;

  ShiftTypeModel({
   this.name,
   this.id,
   this.endTime,
   this.startTime,
   this.sgCode,
 });

  static int tempId = 0;
  factory ShiftTypeModel.fromJson(Map<String, dynamic> json) {
    tempId++;
    return ShiftTypeModel(
      id: json['id'] ?? tempId.toString(),
      name: json['shift_group_name'] ?? "",
      endTime: json['end_time'] ?? "",
      startTime:  json['start_time'] ?? "",
      sgCode:  json['sg_code'] ?? "",
    );

  }
}