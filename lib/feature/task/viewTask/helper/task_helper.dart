import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/services/firebase/notification_service.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
      String url = APIs.getDailyTaskTrackingApi;
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
      String url = APIs.updateTaskApi+"?task_id=${taskData.taskId.toString()}&subtask_id=${taskData.subTaskId.toString()}";
      var json = {
        "patrollman_status": taskStatus,
      };
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

  static Future<void> showNotificationWithNumber() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'notifications_priority', // id
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher_gail',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher_gail'),
      ongoing: false,
      color: Colors.red,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          "id",
          'View',
          icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher_gail'),
          cancelNotification: true,
          showsUserInterface: true,
          contextual: true,
          titleColor: Colors.green,
        ),
      ],
    );
    await flutterLocalNotificationsPlugin.show(
        1,
        'Patrolling Assigned Task',
        'We are found some assigned pending task.',
            const NotificationDetails(
              android: androidNotificationDetails,
            ),
        payload: 'item x');
  }


}
