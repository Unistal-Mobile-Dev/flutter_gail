import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/PipelineSection.dart';

class DashboardHelper {

  static Future<dynamic> getSummaryApi() async {
    try {
       String url =  APIs.dashboardSummaryApi;
       var res =  await ServerRequest.getData(urlEndPoint: url);
       if(res != null){
         return pipelineSectionListResponse(res);
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
