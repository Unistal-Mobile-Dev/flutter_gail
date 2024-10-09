import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:path_provider/path_provider.dart';

class LoginHelper {
  static Future<dynamic> textFieldValidation(
      {required String emilId,
      required String password,
      required BuildContext context}) async {
    try {
      if (emilId.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter email id");
        return false;
      } else if (password.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter password");
        return false;
      }
      return true;
    } catch (e) {
      SnackBarErrorWidget(context).show(message: e.toString());
      return false;
    }
  }

  static getUniqueDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }

  static Future<dynamic> getLoginData(
      {required String emilId,
      required String password,
      required BuildContext context}) async {
    var deviceId = await getUniqueDeviceId();
    String? firebaseToken;
    try {
      firebaseToken = await FirebaseMessaging.instance.getToken();
      if (kDebugMode) {
        print(firebaseToken.toString());
      }
    } catch (_) {
      firebaseToken = "";
    }

    try {
      if (await isInternetConnected() == true) {
        var json = LoginScreenRequestModel(
          userEmailId: emilId,
          password: password,
          firebaseId: firebaseToken.toString(),
          deviceId: deviceId,
        ).toJson();
        String url = APIs.login;
        var res = await ServerRequest.postData(
            urlEndPoint: url, body: jsonEncode(json));
        if (res != null &&
            res["status"] != null &&
            res['user_id'] != null) {
          if (Platform.isAndroid) {
            await deleteCacheDir();
            await deleteAppDir();
          }
          return res;
        } else if (res != null &&
            res["status"] != null &&
            res['status'] == 401 &&
            res['messages'] != null) {
          if (!context.mounted) return null;
          SnackBarErrorWidget(context).show(message: res['messages'].toString().replaceAll("{", "").toString().replaceAll("}", ""));
          return null;
        } else {
          if (!context.mounted) return null;
          SnackBarErrorWidget(context).show(message: "Internal Server Error");
          return null;
        }
      }
      if (!context.mounted) return null;
      SnackBarErrorWidget(context).show(message: "No internet Connection");
      return null;
    } catch (e) {
      print(e.toString());
      if (!context.mounted) return null;
      SnackBarErrorWidget(context).show(message: "Internal server error");
      return null;
    }
  }

  static Future<bool> isInternetConnected() async {
    bool isConnect = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnect = true;
      }
    } on SocketException catch (_) {}

    return isConnect;
  }

  static Future<void> deleteCacheDir() async {
    var tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  static Future<void> deleteAppDir() async {
    var appDocDir = await getApplicationDocumentsDirectory();
    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }
  }
}
