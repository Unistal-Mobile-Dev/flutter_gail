List<MaintenanceTypeModel> maintenanceTypeListResponse(var json) {
  return List<MaintenanceTypeModel>.from(json.map((x) => MaintenanceTypeModel.fromJson(x)));
}

class MaintenanceTypeModel {

  dynamic id;
  String? name;
  String? code;


  MaintenanceTypeModel({
   this.id,
   this.name,
   this.code,
});

  factory MaintenanceTypeModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceTypeModel(
      id: json[''] ?? "",
      name: json['maintenance_base_name'] ?? "",
      code: json['maintenance_base_code'] ?? "",
    );
  }
}