import 'package:flutter_gail/feature/incident/add_incident/domain/model/incident_type_model.dart';
import 'package:flutter_gail/feature/map/domain/model/marker_point_model.dart';

List<RoutePointsModel> routePointsListResponse(var json, String sectionCode) {
  return List<RoutePointsModel>.from(json.map((x) => RoutePointsModel.fromJson(x, sectionCode)));
}

class RoutePointsModel {

  final String sectionCode;
  final List<MarkerPointsModel> markerList;
  final List<IncidentTypeModel> incidentTypeList;

  RoutePointsModel({required this.incidentTypeList, required this.markerList, required this.sectionCode});

  factory RoutePointsModel.fromJson(Map<String, dynamic> json, String sectionCode) {
    return RoutePointsModel(
        sectionCode :sectionCode,
        incidentTypeList: json['incidentTypes'] != null ? incidentTypeListResponse(json['incidentTypes']) : [],
        markerList: json['markerDetails'] != null ? markerPointListResponse(json['markerDetails']) : [],
    );
  }
}