List<MaintenanceBaseModel> maintenanceBaseListResponse(var json) {
   return List<MaintenanceBaseModel>.from(json.map((x) => MaintenanceBaseModel.fromJson(x)));
}

class MaintenanceBaseModel {
  String? name;
  String? code;

  MaintenanceBaseModel({this.code, this.name});

  factory MaintenanceBaseModel.fromJson(Map<String, dynamic> json) {
     return MaintenanceBaseModel(
        name: json['maintenance_base_name'] ?? "",
        code: json['maintenance_base_code'] ?? ""
     );
  }
}