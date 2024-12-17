List<PermissionsModel> permissionsListResponse(var json) {
  return List<PermissionsModel>.from(json.map((x) => PermissionsModel.fromJson(x)));
}

class PermissionsModel {
  String? name;
  bool? value;

  PermissionsModel({this.value, this.name});

  factory PermissionsModel.fromJson(Map<String, dynamic> json) {
    return PermissionsModel(
      name: json['name'] ?? "",
      value: json['value'] ?? false,
    );
  }
}