List<UserTypeModel> userTypeListResponse(var json) {
  return List<UserTypeModel>.from(json.map((x) => UserTypeModel.fromJson(x)));
}

class UserTypeModel {

  dynamic id;
  String? name;
  bool? isSelected;

  UserTypeModel({
   this.id,
   this.name,
   this.isSelected
});

  factory UserTypeModel.fromJson(Map<String, dynamic> json) {
    return UserTypeModel(
      id: json['id'] ?? "",
      name: json['type'] ?? "",
      isSelected: false,
    );
  }
}