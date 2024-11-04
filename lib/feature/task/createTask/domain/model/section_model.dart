List<SectionModel> sectionListResponse(var json) {
  return List<SectionModel>.from(json.map((x) => SectionModel.fromJson(x)));
}

class SectionModel {

  dynamic id;
  String? name;
  String? code;

  SectionModel({
   this.name,
   this.id,
   this.code,
});

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] ?? "",
      name: json['section_name'] ?? "",
      code: json['section_code'] ?? "",
    );
  }
}