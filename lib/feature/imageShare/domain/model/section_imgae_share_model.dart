import 'package:flutter_gail/feature/imageShare/domain/model/station_model.dart';

List<SectionImageShareModel> sectionImageShareListResponse(var json) {
  return List<SectionImageShareModel>.from(json.map((x) => SectionImageShareModel.fromJson(x)));
}

class SectionImageShareModel {
  String? sectionCode;
  String? sectionName;
  dynamic fromChainage;
  dynamic toChainage;
  List<StationModel>? stationList;


  SectionImageShareModel({this.fromChainage,
    this.sectionCode,
    this.sectionName,
    this.toChainage,
    this.stationList,
  });


  factory SectionImageShareModel.fromJson(Map<String, dynamic> json) {
    return SectionImageShareModel(
        sectionCode: json['sectionCode'] ?? "",
        sectionName: json['sectionName'] ?? "",
        fromChainage: json['fromChainage'] ?? "",
        toChainage: json['toChainage'] ?? "",
        stationList: json['stations'] != null
            ? (json['stations'] as List).map((e) => StationModel(name: e)).toList()
            : []

    );
  }
}