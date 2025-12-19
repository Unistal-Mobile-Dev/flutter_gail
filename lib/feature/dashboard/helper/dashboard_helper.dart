import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/PiggabilityDataModel.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/PipelineMasterModel.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/PipelineSection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

import '../../../utils/commonWidgets/message_box_pop_button_widget.dart' show MessageBoxPopButtonWidget;

class DashboardHelper {

  static Future<dynamic> getSummaryApi() async {
    try {
       String url =  APIs.summary;
       var res =  await ServerRequest.getData(urlEndPoint: url);
       if(res != null){
         return pipelineSectionListResponse(res);
       }
    } catch (_) {}
    return null;
  }
  static Future<DashboardStatusModel?> getPipelineSummaryApi({
    required BuildContext context,
  }) async {
    try {
      Map<String, String> para = {
        "region": "",
        "section": "",
        "pipeline": "",
        "lifecycleStatuses": "8,256",
      };
      String url =  APIs.pipelineSummary;
      String query = Uri(queryParameters: para).query;
      var res = await ServerRequest.getData(urlEndPoint: url+ query,);
      log("getPipelineSummaryApi response → ${url+ query}");
      log("getPipelineSummaryApi response → $res");
      if (res != null && res is Map<String, dynamic>) {
        DashboardStatusModel dashboardStatusModel =
        DashboardStatusModel.fromJson(res);
        return dashboardStatusModel;
      } else {
        log("Unexpected response type: ${res.runtimeType}");
      }
    } catch (_) {}
    return null;
  }

  static Future<PiggabilityDataModel?> getPipelineMasterApi({
    required BuildContext context,
  }) async {
    try {
      Map<String, String> para = {
        "region": "",
        "lifecycleStatuses": "8,256",
      };
      String url =  APIs.pipelineMaster;
      String query = Uri(queryParameters: para).query;
      var res = await ServerRequest.getData(urlEndPoint: url+ query,);

      if (res != null && res is Map<String, dynamic>) {
        return PiggabilityDataModel.fromMap(res);
      } else {
        log("Unexpected response type: ${res.runtimeType}");
      }
    } catch (_) {}
    return null;
  }

  static Future<dynamic> imagePiker({required BuildContext context}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 60,
          maxHeight: 1200,
          maxWidth: 950
      );
      if (photo != null) {
        return File(photo.path);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> cameraPiker({required BuildContext context}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 60,
          maxHeight: 1200,
          maxWidth: 950,
          preferredCameraDevice: CameraDevice.rear);
      if (photo != null) {
        return File(photo.path);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> videoPiker({required BuildContext context}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickVideo(
          source: ImageSource.camera,
          maxDuration: const Duration(seconds: 10),
          preferredCameraDevice: CameraDevice.rear);
      if (photo != null) {
        return File(photo.path);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> filePiker({required BuildContext context}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', "png"],
      );
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        return files[0];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }

  static Future<void> requestMandatoryLocationPermission(BuildContext context) async {

    await [
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse
    ].request();

    if(Platform.isAndroid) {
      // Step 1: Request Foreground Location
      var status = await Permission.location.status;

      if (status.isDenied) {
        await _showReasonDialog(
          context,
          "Location Required",
          "This app needs your location to function properly.",
        );
        status = await Permission.location.request();
      }

      if (!status.isGranted) {
        await _showSettingsDialog(
          context,
          "Permission Required",
          "You must grant location access to continue using this app.",
        );
        return;
      }

      // Step 2: Request Background Location
      var bgStatus = await Permission.locationAlways.status;

      if (!bgStatus.isGranted) {
        await _showReasonDialog(
          context,
          "Background Location Required",
          "To track your location even when app is closed, please enable 'Allow all the time'.",
        );

        bgStatus = await Permission.locationAlways.request();
      }

      if (!bgStatus.isGranted) {
        await _showSettingsDialog(
          context,
          "Mandatory Background Permission",
          "You need to enable 'Allow all the time' for location in app settings.",
        );
      }
    }
    else if(Platform.isIOS){
      LocationPermission permission =  await Geolocator.checkPermission();
      if(permission == LocationPermission.denied){
        await _showSettingsDialog(
          context,
          "Permission Required",
          "You must grant location access to continue using this app.",
        );
        return;
      }
    }
  }

  static Future<void> _showReasonDialog(
      BuildContext context, String title, String msg) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false, // ❌ Disable back button
        child: AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _showSettingsDialog(
      BuildContext context, String title, String msg) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
            child: const Text("Open Settings"),
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  static Future<void> checkAppVersion(BuildContext context) async {
      try {
          String baseUrl = "https://dev.indiait360.com:8441/unistalchat";
           String url = "$baseUrl/api/gail-app?id=1";
           var res =  await ServerRequest.getGoogleData(url: Uri.parse(url));
           if(res != null && res['download'] != null){
              if(res['download'].toString().isNotEmpty){
                String downloadUrl  =  baseUrl+res['download'].toString();
                String version  =    res['version'].toString();
                String versionCode  =  res['versionCode'].toString();

                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                String appVersion       = packageInfo.version;        // 1.0.0
                String buildNumber   = packageInfo.buildNumber;    // versionCode (Android)

                if(version.toString() != appVersion.toString()
                     && buildNumber.toString() != versionCode.toString()){

                  var result =  await showDialog(
                    barrierDismissible: false,
                    context: !context.mounted ? context : context,
                    builder: (context) {
                      return WillPopScope(
                        onWillPop: () async => false, // Disable back button
                        child: MessageBoxPopButtonWidget(
                          title: "New Update Available",
                          message: "A new mandatory update is available. You must update the app to continue using its services.",
                          buttonText: "Update",
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      );
                    },
                  );
                  if(result == true){
                    downloadAndInstallApk(downloadUrl, !context.mounted ? context : context);
                  }
                }
              }
           }
      }catch(_){}
  }

  static Future<void> downloadAndInstallApk(String url, BuildContext context) async {
    // Ask for storage permission
    if(await requestPermission() == false){
      return;
    }

    // Get download directory
    Directory directory = await getTemporaryDirectory();
    String fileName = url.split("/").last;
    String filePath = "${directory.path}/$fileName";

    // Download APK
    Dio dio = Dio();

    showDialog(
        barrierDismissible: false,
        context: !context.mounted ? context : context,
        builder: (_) => WillPopScope(
          onWillPop: () async => false, // Disable back button
          child: const Center(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CenterLoaderWidget(),
              TextWidget("Please wait.. app downloading", color: Colors.black,),
            ],
          )),
        ));

    await dio.download(url, filePath);
    Navigator.pop(!context.mounted ? context : context); // close progress dialog

    // Install APK
    try {
      await InstallPlugin.installApk(filePath);
      await checkAppVersion(!context.mounted ? context : context);
    } catch (e) {
      ScaffoldMessenger.of(!context.mounted ? context : context)
          .showSnackBar(SnackBar(content: Text("Install error: $e")));
    }
  }

  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      // For Android 11+ (Scoped Storage)
      var status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        return true;
      }

      // For Android < 11
      status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      }
      print("Permission denied");
      return false;
    }
    return true;
  }


}

mediaType({required BuildContext context,
  required VoidCallback onPressedCamera,
  required VoidCallback onPressedGallery}) {
  showModalBottomSheet(
    context: context, // Also default
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.18,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextButton(
                onPressed: onPressedCamera,
                child: TextWidget(
                  "Camera",
                  fontSize: AppFont.font_16,
                )),
            const Divider(),
            TextButton(
                onPressed: onPressedGallery,
                child: TextWidget(
                  "Gallery",
                  fontSize: AppFont.font_16,
                )),
          ],
        ),
      );
    },
  );
}
