import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/commonWidgets/email_validation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class LoginHelper {
  static const platform = MethodChannel('com.gail.app/channel');

  static Future<void> openDevSettings() async {
    try {
      await platform.invokeMethod('openDevSettings');
    } on PlatformException catch (e) {
      print("Failed to open developer settings: ${e.message}");
    }
  }

  // static Future<bool> isDeveloperModeEnabled() async {
  //   try {
  //     final bool result = await platform.invokeMethod('isDevMode');
  //     return result;
  //   } on PlatformException catch (e) {
  //     print("Failed to check dev mode: ${e.message}");
  //     return false;
  //   }
  // }

  static Future<bool> isDeveloperModeEnabled() async {
    // iOS par is custom native channel ki zarurat nahi hai
    if (Platform.isIOS) {
      return false;
    }

    try {
      final bool? result = await platform.invokeMethod<bool>('isDevMode');
      return result ?? false;
    } on MissingPluginException catch (e) {
      debugPrint("isDevMode plugin not available: $e");
      return false;
    } on PlatformException catch (e) {
      debugPrint("Failed to check dev mode: ${e.message}");
      return false;
    } catch (e) {
      debugPrint("Unexpected isDevMode error: $e");
      return false;
    }
  }

  static Future<dynamic> textFieldValidation(
      {required String emilId,
      required String password,
      required String loginType,
      required BuildContext context}) async {
    try {
      if (loginType.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please select user type");
        return false;
      } else if (emilId.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter email id");
        return false;
      }
      // else if (await EmailValidation.checkEmailValidation(emailId: emilId) == false && loginType == "2") {
      //   SnackBarErrorWidget(context).show(message: "Please enter correct email id");
      //   return false;
      // }
      else if (password.isEmpty) {
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

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("baseUrl", APIs.baseUrl);

        print("Fetch Base Url =  ${prefs.getString("baseUrl")}");

        String url = APIs.login;
        var res = await ServerRequest.postData(
            urlEndPoint: url,
            body: jsonEncode(json),
            context: !context.mounted ? context : context);
        if (res != null && res['users'] != null) {
          if (Platform.isAndroid) {
            // await deleteCacheDir();
            // await deleteAppDir();
          }
          return res;
        }
      }
      return null;
    } catch (e) {
      if (!context.mounted) return null;
      SnackBarErrorWidget(context).show(message: "Internal server error");
      return null;
    }
  }

  static Future<dynamic> getLoginOTPData(
      {required String userId,
        required String otp,
        required String loginType,
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
        var json = LoginOTPScreenRequestModel(
          userId: userId,
          otp: otp,
          loginType: loginType,
          firebaseId: firebaseToken.toString(),
          deviceId: deviceId,
        ).toJson();

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("baseUrl", APIs.baseUrl);
        String url = APIs.login;
        var res = await ServerRequest.postData(
            urlEndPoint: url,
            body: jsonEncode(json),
            context: !context.mounted ? context : context);
        if (res != null && res['users'] != null) {
          if (Platform.isAndroid) {
            // await deleteCacheDir();
            // await deleteAppDir();
          }
          return res;
        }
      }
      return null;
    } catch (e) {
      if (!context.mounted) return null;
      SnackBarErrorWidget(context).show(message: "Internal server error");
      return null;
    }
  }

  static Future<dynamic> checkLogin({required BuildContext context}) async {
    try {
      if (await isInternetConnected() == true) {
        var json = {};
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("baseUrl", APIs.baseUrl);

        print("Fetch Base Url =  ${prefs.getString("baseUrl")}");

        String url = APIs.checkLogin;
        var res = await ServerRequest.postData(
            urlEndPoint: url,
            body: jsonEncode(json),
            context: !context.mounted ? context : context);
        if (res != null && res['users'] != null) {
          if (Platform.isAndroid) {
            // await deleteCacheDir();
            // await deleteAppDir();
          }
          return res;
        }
      }
      return null;
    } catch (e) {
      if (!context.mounted) return null;
      SnackBarErrorWidget(context).show(message: "Internal server error");
      return null;
    }
 }

  static Future<dynamic> addDevice(
      {required String userId, required BuildContext context}) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      var deviceId = await getUniqueDeviceId();
      String brand = "";
      String model = "";
      String deviceVersion = "";
      String deviceType = "";
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        brand = androidInfo.brand.toString();
        model = androidInfo.model.toString();
        deviceVersion = androidInfo.version.release;
        deviceType = "Android";
      }
      String url = APIs.addDeviceApi;
      var json = {
        "user_id": userId,
        "device_id": deviceId.toString(),
        "device_name": model,
        "device_platform": deviceType,
        "device_brand": brand,
        "device_version": deviceVersion,
        "device_status": "Active"
      };
      await ServerRequest.postData(
          urlEndPoint: url,
          body: jsonEncode(json),
          context: !context.mounted ? context : context);
    } catch (_) {}
  }

  static Future<dynamic> sendOtp(
      {required String emailId,
        required String password,
        required String loginType,
        required BuildContext context}) async {

     try {
         String url =  APIs.generateOtpApi;
         var json = {
           "email" : emailId,
           "password" : password,
           "userType": loginType == "1" ? "internal" :"external"
         };
         var res =  await ServerRequest.postData(urlEndPoint: url, body: jsonEncode(json), context: context);
         if(res != null && res['success'] != null && res['success'] == true){
            return res['userId'].toString();
         }
     }catch(_){}
    return null;

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
