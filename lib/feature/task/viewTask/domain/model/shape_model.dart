import 'package:flutter_gail/feature/task/viewTask/domain/model/point_model.dart';

class ShapeModel {
  int? srid;
  int? version;
  List<PointsModel>? pointsList;

  ShapeModel(
      {this.srid,
        this.version,
        this.pointsList,});

  ShapeModel.fromJson(Map<String, dynamic> json) {
    srid = json['srid'];
    version = json['version'];
    if (json['points'] != null) {
      pointsList = <PointsModel>[];
      json['points'].forEach((v) {
        pointsList!.add( PointsModel.fromJson(v));
      });
    }
  }
}