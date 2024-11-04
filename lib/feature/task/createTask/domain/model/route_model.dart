List<RouteModel> routeListResponse(var json) {
  return List<RouteModel>.from(json.map((x) => RouteModel.fromJson(x)));
}

class RouteModel {

  dynamic id;
  String? name;
  dynamic length;

  RouteModel({
   this.id,
   this.name,
   this.length,
});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['patrollroute_id'] ?? "",
      name: json['route_name'] ?? "",
      length: json['route_length'] ?? "",
    );
  }
}