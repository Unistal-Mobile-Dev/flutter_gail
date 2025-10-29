import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/services/firebase/notification_service.dart';
import 'package:flutter_gail/services/location/location_helper.dart';
import 'package:flutter_gail/services/location/location_model.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';

class TaskHelper {
  static Future<dynamic> fetchTask(
      {required String startDate, required String endDate}) async {
    try {
      return fetchDailyTask(startDate: startDate, endDate: endDate);
    } catch (e) {
      print("Error ===================== ${e.toString()}");
    }
    return null;
  }

  static Future<dynamic> fetchDailyTask(
      {required String startDate, required String endDate}) async {
    try {
      LoginDataModel userData = UserInfo.instance!.userData!;
      String url = APIs.getDailyTaskTrackingApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['data'] != null) {
        return taskListResponse(res['data']);
      }
      return null;
    } catch (e) {
      print("Error 1 ===================== ${e.toString()}");
    }
    return null;
  }

  static Future<dynamic> updateTask({
    required TaskModel taskData,
    required int taskStatus,
    required BuildContext context,
    required int pointsCount,
  }) async {
    try {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String currentDate = formatter.format(DateTime.now());

      var location = await LocationHelper.getLocation(context: context);
      LocationModel locationModel = LocationModel();
      if (location != null) {
        locationModel = location;
      }
      final String currentTime =
          "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
      String url =
          APIs.updateTaskApi;
      var json = {"data" : [{
        "patrollman_status": taskStatus,
        "task_id" : taskData.taskId.toString(),
        "timing_data": {
          "event_type": taskStatus == 1
              ? "start"
              : taskStatus == 2
              ? "pause"
              : taskStatus == 5
              ? "resume"
              : taskStatus == 3
              ? "end"
              : "",
          "event_time": currentTime,
          "inspected_datetime": "${DateTime.now()}",
          "gpsx": locationModel.long ?? "",
          "gpsy": locationModel.lat ?? "",
          "no_of_points": taskData.noOfPoints.toString(),
          "no_of_points_covered": "",
        }
      }]};
      var res = await ServerRequest.putData(
          urlEndPoint: url, body: jsonEncode(json), context: context);
      if (res != null && res['message'] != null) {
        SnackBarSuccessWidget(!context.mounted ? context : context)
            .show(message: res['message'].toString());
        return res;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

}
