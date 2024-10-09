List<CrossingTypeModel> crossingTypeListResponse(var json) {
  return List<CrossingTypeModel>.from(json((x) => CrossingTypeModel.fromJson(x)));
}

class CrossingTypeModel {
  dynamic id;
  String? name;
  String? crossingUrl;
  bool? isSelected;

  CrossingTypeModel({
    this.name,
    this.id,
    this.crossingUrl,
    this.isSelected,
  });

  factory CrossingTypeModel.fromJson(Map<String, dynamic> json) {
    return CrossingTypeModel(
      id: json[''] ?? "",
      name: json[''] ?? "",
      crossingUrl: json[''] ?? "",
      isSelected:  false,
    );
  }
}