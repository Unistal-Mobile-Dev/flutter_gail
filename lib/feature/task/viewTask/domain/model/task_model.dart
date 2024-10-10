List<TaskModel> taskListResponse(var json) {
  return List<TaskModel>.from(json.map((x) => TaskModel.fromJson(x)));
}

class TaskModel {
  dynamic objectId;
  String? taskId;
  String? patrollRouteId;
  String? patrollRouteName;
  dynamic patrollRouteLength;
  String? shiftName;
  String? sgCode;
  String? assignedStartDate;
  String? assignedEndDate;
  String? repeatFrequency;
  dynamic userId;
  dynamic patrollManStatus;

  TaskModel(
      {this.objectId,
        this.taskId,
        this.patrollRouteId,
        this.patrollRouteName,
        this.patrollRouteLength,
        this.shiftName,
        this.sgCode,
        this.assignedStartDate,
        this.assignedEndDate,
        this.repeatFrequency,
        this.userId,
        this.patrollManStatus});

  TaskModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectid'] ?? "";
    taskId = json['task_id'] ?? "";
    patrollRouteId = json['patrollroute_id'] ?? "";
    patrollRouteName = json['patrollroute_name'] ?? "";
    patrollRouteLength = json['patrollroute_length'] ?? "";
    shiftName = json['shift_name'] ?? "";
    sgCode = json['sg_code'] ?? "";
    assignedStartDate = json['assigned_start_date'] ?? "";
    assignedEndDate = json['assigned_end_date'] ?? "";
    repeatFrequency = json['repeat_frequency'] ?? "";
    userId = json['user_id'] ?? "";
    patrollManStatus = json['patrollman_status'] ?? "";
  }
}