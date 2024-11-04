import 'package:flutter_gail/ExportFile/app_export_file.dart';

List<TaskModel> taskListResponse(var json) {
  return List<TaskModel>.from(json.map((x) => TaskModel.fromJson(x)));
}

class TaskModel {
  dynamic objectId;
  dynamic taskId;
  String? maintenanceBase;
  String? pipeline;
  String? section;
  dynamic patrollRouteId;
  String? patrollRouteName;
  dynamic patrollRouteLength;
  dynamic sgCode;
  String? assignedStartDate;
  String? assignedEndDate;
  String? repeatFrequency;
  String? userType;
  String? userName;
  dynamic userId;
  String? shiftName;
  dynamic patrollManStatus;
  dynamic createdAt;
  dynamic updatedAt;
  String? vendorName;
  String? region;
  TaskStatus? taskStatus;

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
        this.patrollManStatus,
        this.taskStatus,
      });

  TaskModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectid'] ?? "";
    taskId = json['task_id'] ?? "";
    maintenanceBase = json['maintenance_base'] ?? "";
    pipeline = json['pipeline'] ?? "";
    section = json['section'] ?? "";
    patrollRouteId = json['patrollroute_id'] ?? "";
    patrollRouteName = json['patrollroute_name'] ?? "";
    patrollRouteLength = json['patrollroute_length'] ?? "";
    sgCode = json['sg_code'] ?? "";
    assignedStartDate = json['assigned_start_date'] ?? "";
    assignedEndDate = json['assigned_end_date'] ?? "";
    repeatFrequency = json['repeat_frequency'] ?? "";
    userType = json['user_type'] ?? "";
    userName = json['user_name'] ?? "";
    userId = json['user_id'] ?? "";
    shiftName = json['shift_name'] ?? "";
    patrollManStatus = json['patrollman_status'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    vendorName = json['vendor_name'] ?? "";
    region = json['region'] ?? "";
    taskStatus =  json['patrollman_status'] != null
        ? getTaskStatus(json['patrollman_status'].toString())
        : TaskStatus.notStarted;
  }

  getTaskStatus(String status) {
    switch(status){
      case "0" :
        return TaskStatus.notStarted;
      case "1" :
        return TaskStatus.started;
      case "2" :
        return TaskStatus.pause;
      case "3" :
        return TaskStatus.completed;
      default:
        return TaskStatus.notStarted;
    }
  }
}