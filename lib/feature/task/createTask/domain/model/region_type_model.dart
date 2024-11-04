List<RegionTypeModel> regionTypeListResponse(var json) {
  return List<RegionTypeModel>.from(json.map((x) => RegionTypeModel.fromJson(x)));
}

class RegionTypeModel {

  dynamic id;
  String? name;
  String? code;

  RegionTypeModel({
   this.name,
   this.id,
   this.code,
});

  factory RegionTypeModel.fromJson(Map<String, dynamic> json) {
    return RegionTypeModel(
      name: json['region_name'] ?? "",
      id: json['id'] ?? "",
      code: json['region_code'] ?? "",
    );
  }
}