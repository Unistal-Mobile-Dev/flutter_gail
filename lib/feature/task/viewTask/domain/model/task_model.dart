import 'dart:convert';

import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/point_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/shape_model.dart';

List<TaskModel> taskListResponse(var json) {
  return List<TaskModel>.from(json.map((x) => TaskModel.fromJson(x)));
}

class TaskModel {
  dynamic objectId;
  dynamic taskId;
  dynamic subTaskId;
  String? maintenanceBase;
  String? pipeline;
  String? section;
  dynamic sectionCode;
  dynamic patrollRouteId;
  String? patrollRouteName;
  dynamic patrollRouteLength;
  dynamic sgCode;
  String? assignedStartDate;
  String? assignedEndDate;
  String? assignedDate;
  String? repeatFrequency;
  String? userType;
  String? userName;
  dynamic userId;
  String? shiftName;
  dynamic patrollManStatus;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic vendorName;
  String? region;
  TaskStatus? taskStatus;
  ShapeModel? shapeData;
  dynamic noOfPoints;

  TaskModel(
      {this.objectId,
        this.taskId,
        this.subTaskId,
        this.patrollRouteId,
        this.patrollRouteName,
        this.patrollRouteLength,
        this.shiftName,
        this.sgCode,
        this.assignedStartDate,
        this.assignedEndDate,
        this.assignedDate,
        this.repeatFrequency,
        this.userId,
        this.patrollManStatus,
        this.taskStatus,
        this.shapeData,
        this.sectionCode,
        this.section,
        this.noOfPoints,
      });

  TaskModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectid'] ?? json['object_id'] ?? "";
    taskId = json['task_id'] ?? "";
    subTaskId = json['subtask_id'] ?? "";
    maintenanceBase = json['maintenance_base'] ?? "";
    pipeline = json['pipeline'] ?? "";
    section = json['section'] ?? "";
    sectionCode =  json['section_code'] ?? "";
    patrollRouteId = json['patrollroute_id'] ?? "";
    patrollRouteName = json['patrollroute_name'] ?? "";
    patrollRouteLength = json['patrollroute_length'] ?? "";
    sgCode = json['sg_code'] ?? "";
    assignedStartDate = json['assigned_start_date'] ?? "";
    assignedEndDate = json['assigned_end_date'] ?? "";
    assignedDate = json['assigned_date'] ?? "";
    repeatFrequency = json['repeat_frequency'] ?? "";
    userType = json['user_type'] ?? "";
    userName = json['user_name'] ?? "";
    userId = json['user_id'] ?? "";
    shiftName = json['shift_name'] ?? "";
    patrollManStatus = json['patrollman_status'] ?? json['status'] ?? "0";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    vendorName = json['vendor_name'] ?? "";
    region = json['region'] ?? "";
    noOfPoints = json['noOfPoints'] ?? "";
    shapeData =  json['shape'] != null ? ShapeModel.fromJson(json['shape']) :  ShapeModel();
    taskStatus =  json['patrollman_status'] != null
        ? getTaskStatus(json['patrollman_status'].toString())
        :  json['status'] != null
        ? getTaskStatus(json['status'].toString())
        :  TaskStatus.notStarted;
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
      case "5" :
        return TaskStatus.resume;
      default:
        return TaskStatus.notStarted;
    }
  }
}