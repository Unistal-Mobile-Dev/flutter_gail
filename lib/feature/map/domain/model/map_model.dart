import 'package:flutter_gail/feature/map/domain/model/coordinates_model.dart';

class MapModel {
  dynamic buffer;
  dynamic timeInterval;
  List<Data>? data;

    MapModel({this.buffer, this.data, this.timeInterval =  30});

  MapModel.fromJson(Map<String, dynamic> json) {
    buffer = json['buffer'] ?? "50";
    // A named constructor does not pick up the default above, so without
    // this timeInterval stayed null and the fallback in MapBloc was useless.
    timeInterval = json['time_interval'] ?? 30;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) { data!.add(Data.fromJson(v)); });
    }
  }
}

class Data {
  dynamic sectionCode;
  dynamic chargeAreaId;
  GeometryModel? geometry;

  Data({this.sectionCode, this.chargeAreaId, this.geometry});

  Data.fromJson(Map<String, dynamic> json) {
    sectionCode = json['section_code'] ?? "";
    chargeAreaId = json['charge_area_id'] ?? "";
    geometry = json['geometry'] != null ? GeometryModel.fromJson(json['geometry']) : null;
  }

}