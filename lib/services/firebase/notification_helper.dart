import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/home/domain/model/firebase_device_model.dart';

class NotificationHelper {
  static Future<dynamic> sendNotification({
    required List<FirebaseDeviceModel> firebaseDeviceList,
    required String title,
    required String body,
    required String pageId,
    required String complaintId,
    required String dateTime,
  }) async {
    try {
      String url = APIs.sendNotificationApi;
      List<String> deviceIdToke = [];
      for (var firebaseToken in firebaseDeviceList) {
        deviceIdToke.add(firebaseToken.firebaseId.toString());
      }
      var toke = deviceIdToke.toSet().toList();
      var json = {
        "registration_ids": toke,
        "priority": "high",
        "notification": {
          "title": title,
          "body": body,
          "sound": "mario.wav",
          "android_channel_id": "notifications_priority"
        },
        "data": {
          "title": title,
          "body": body,
          "pageIntent": {
            "pageId": pageId,
            "complaintId": complaintId,
            "dateTime": dateTime,
          },
          "sound": "mario"
        },
        "content_available": true,
        "apns": {
          "payload": {
            "aps": {"mutable-content": 1, "content-available": 1}
          }
        }
      };
      await ServerRequest.firebasePushNotification(url: url, body: json);
    } catch (_) {}
  }
}
