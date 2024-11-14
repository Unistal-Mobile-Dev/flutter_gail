import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';

class TaskHelper {

  static Future<dynamic> fetchTask(
      {required String startDate, required String endDate}) async {
    try {
      return fetchDailyTask(startDate: startDate, endDate: endDate);
      String url = APIs.getTaskApi+"?startDate=$startDate&endDate=$endDate";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['data'] != null) {
        return taskListResponse(res['data']);
      }
      return null;
    } catch (_) {}
    return null;
  }

  static Future<dynamic> fetchDailyTask(
      {required String startDate, required String endDate}) async {
    try {
      LoginDataModel userData =  UserInfo.instance!.userData!;
      String url = APIs.getDailyTaskTrackingApi+"?user_id=${userData.users!.securityId.toString()}&startDate=$startDate&endDate=$endDate";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['data'] != null) {
        return taskListResponse(res['data']);
      }
      return null;
    } catch (_) {
      print(_.toString());
    }
    return null;
  }

  static Future<dynamic> updateTask(
      {required TaskModel taskData,
      required int taskStatus,
      required BuildContext context}) async {
    try {
      String url = APIs.updateTaskApi;
      var json = {
        "task_id": taskData.subTaskId.toString().isEmpty ? taskData.taskId.toString() : taskData.subTaskId.toString(),
        "patrollman_status": taskStatus.toString(),
      };
      var res = await ServerRequest.postData(
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
