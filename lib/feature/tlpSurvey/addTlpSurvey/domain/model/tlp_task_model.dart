import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/model/tlp_number_model.dart';

List<TlpTaskModel> tlpTaskListResponse(var json) {
  return List<TlpTaskModel>.from(json.map((x) => TlpTaskModel.fromJson(x)));
}

class TlpTaskModel {
  String? dueDate;
  String? plannedDate;
  String? nextDue;
  String? engRouteName;
  String? currentTaskId;
  dynamic length;
  dynamic nPS;
  String? pipelineCode;
  String? pipelineName;
  List<TlpNumberModel>? tlpNumberList;

  TlpTaskModel(
      {this.dueDate,
        this.plannedDate,
        this.nextDue,
        this.engRouteName,
        this.currentTaskId,
        this.length,
        this.nPS,
        this.pipelineCode,
        this.pipelineName,
        this.tlpNumberList});

  TlpTaskModel.fromJson(Map<String, dynamic> json) {
    dueDate = json['duedate'] ?? "";
    plannedDate = json['planned_date'] ?? "";
    nextDue = json['nextDue'] ?? "";
    engRouteName = json['engroutename'] ?? "";
    currentTaskId = json['currenttaskid'] ?? "";
    length = json['Length'] ?? "";
    nPS = json['NPS'] ?? "";
    pipelineCode = json['pipelineCode'] ?? "";
    pipelineName = json['pipelineName'] ?? "";
    tlpNumberList =  json['engmData'] != null ? tlpNumberListResponse(json['engmData']) : [];
  }
}