List<PipelineModel> pipelineLIstResponse(var json) {
  return List<PipelineModel>.from(json.map((x) => PipelineModel.fromJson(x)));
}

class PipelineModel {

  dynamic id;
  String? name;
  String? code;

  PipelineModel({
    this.name,
    this.id,
    this.code,
});

  factory PipelineModel.fromJson(Map<String, dynamic> json) {
    return PipelineModel(
      name: json['pipeline_name'] ?? "",
      id: json['id'] ?? "",
      code: json['pipeline_code'] ?? "",
    );
  }
}