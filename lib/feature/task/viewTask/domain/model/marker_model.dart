List<MarkerModel> markerListResponse(var json) {
  return List<MarkerModel>.from(json.map((x) => MarkerModel.fromJson(x)));
}


class MarkerModel {
  dynamic markerNumber;
  double? gpsX;
  double? gpsY;
  dynamic markerType;
  String? engRouteName;
  String? markerName;

  MarkerModel(
      {this.markerNumber,
        this.gpsX,
        this.gpsY,
        this.markerType,
        this.engRouteName,
        this.markerName});

  MarkerModel.fromJson(Map<String, dynamic> json) {
    markerNumber = json['markernumber'] ?? 0;
    gpsX = json['gpsx'] ?? 0.0;
    gpsY = json['gpsy'] ?? 0.0;
    markerType = json['markertype'] ?? 0;
    engRouteName = json['engroutename'] ?? "";
    markerName = json['markername'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['markernumber'] = markerNumber;
    data['gpsx'] = gpsX;
    data['gpsy'] = gpsY;
    data['markertype'] = markerType;
    data['engroutename'] = engRouteName;
    data['markername'] = markerName;
    data['type']  = "marker";
    return data;
  }

}