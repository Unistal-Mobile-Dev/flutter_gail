List<LineModel> lineListResponse(var json) {
  return List<LineModel>.from(json.map((x) => LineModel.fromJson(x)));
}

class LineModel {

  dynamic id;
  String? name;
  String? length;


  LineModel({
   this.length,
   this.id,
   this.name,
 });

  factory LineModel.fromJson(Map<String, dynamic> json) {
    return LineModel(
      length: json[''] ?? "",
      id: json[''] ?? "",
      name: json[''] ?? "",
    );
  }
}