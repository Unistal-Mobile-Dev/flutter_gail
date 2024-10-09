List<MarkerTypeModel> markerTypeListResponse(var json) {
  return List<MarkerTypeModel>.from(json((x) => MarkerTypeModel.fromJson(x)));
}

class MarkerTypeModel {

  dynamic id;
  String? name;
  String? markerUrl;
  bool? isSelected;

  MarkerTypeModel({
    this.name,
    this.id,
    this.markerUrl,
    this.isSelected,
});

  factory MarkerTypeModel.fromJson(Map<String, dynamic> json) {
    return MarkerTypeModel(
       id: json[''] ?? "",
       name: json[''] ?? "",
       markerUrl: json[''] ?? "",
      isSelected:  false,
    );
  }
}