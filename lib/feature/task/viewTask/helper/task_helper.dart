import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';

class TaskHelper {

  static Future<dynamic> fetchTask() async {
    try {
      String url = APIs.getTaskApi;
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
        "task_id": taskData.taskId.toString(),
        "patrollman_status": taskStatus.toString(),
      };
      var res = await ServerRequest.postData(
          urlEndPoint: url, body: json, context: context);
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
