List<TaskTypeModel> taskTypeListResponse(var json) {
  return List<TaskTypeModel>.from(json.map((x) => TaskTypeModel.fromJson(x)));
}

class TaskTypeModel {

  dynamic id;
  String? name;

  TaskTypeModel({
   this.id,
   this.name,
});

  factory TaskTypeModel.fromJson(Map<String, dynamic> json) {
    return TaskTypeModel(
      id: json[''] ?? "",
      name : json[''] ?? "",
    );
  }
}