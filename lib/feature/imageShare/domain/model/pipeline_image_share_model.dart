import 'package:flutter_gail/feature/imageShare/domain/model/station_model.dart';

List<PipelineImageShareModel> pipelineImageShareListResponse(var json) {
   return List<PipelineImageShareModel>.from(json.map((x) => PipelineImageShareModel.fromJson(x)));
}

class PipelineImageShareModel {
  String? pipelineCode;
  String? pipelineName;


  PipelineImageShareModel({
    this.pipelineCode,
    this.pipelineName,
  });


  factory PipelineImageShareModel.fromJson(Map<String, dynamic> json) {
    return PipelineImageShareModel(
        pipelineCode: json['pipeline_code'] ?? "",
        pipelineName: json['pipeline_name'] ?? "",
    );
  }
}

