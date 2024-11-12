List<PointsModel> pointsListResponse(var json) {
  return List<PointsModel>.from(json.map((x) => PointsModel.fromJson(x)));
}

class PointsModel {
  dynamic x;
  dynamic y;
  dynamic z;
  dynamic m;

  PointsModel({this.x, this.y, this.z, this.m});

  PointsModel.fromJson(Map<String, dynamic> json) {
    x = json['x'] ?? 0.0;
    y = json['y'] ?? 0.0;
    z = json['z'] ?? 0.0;
    m = json['m'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    data['z'] = z;
    data['m'] = m;
    return data;
  }
}