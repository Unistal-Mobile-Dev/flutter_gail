List<MarkerPointsModel> markerPointListResponse(var json) {
  return List<MarkerPointsModel>.from(json.map((x) => MarkerPointsModel.fromJson(x)));
}

class MarkerPointsModel {

    dynamic markerNumber;
    dynamic gpsx;
    dynamic gpsy;
    dynamic markerType;
    dynamic engRouteName;
    dynamic markerName;

    MarkerPointsModel({this.engRouteName,
      this.gpsx,
      this.gpsy,
      this.markerName,
      this.markerNumber,
      this.markerType});

    factory MarkerPointsModel.fromJson(Map<String, dynamic> json) {
      return MarkerPointsModel(
        gpsx: json['gpsx'] ?? "0.0",
        gpsy: json['gpsy'] ?? "0.0",
        markerType: json['markertype'] ?? "",
        engRouteName: json['engroutename'] ?? "",
        markerName: json['markername'] ?? "",
      );
    }
}