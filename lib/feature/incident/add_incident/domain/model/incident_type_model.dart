List<IncidentTypeModel>  incidentTypeListResponse(var json) {
  return List<IncidentTypeModel>.from(json.map((x) => IncidentTypeModel.fromJson(x)));
}

class IncidentTypeModel {

  dynamic id;
  String? name;

  IncidentTypeModel({
   this.id,
   this.name,
 });

  factory IncidentTypeModel.fromJson(Map<String, dynamic> json) {
    return IncidentTypeModel(
      id: json['id'] ?? "",
      name: json['type'] ?? "",
    );
  }
}