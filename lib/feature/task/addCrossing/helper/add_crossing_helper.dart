import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_gail/feature/task/addCrossing/domain/model/crossing_type_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/services/location/location_helper.dart';
import 'package:flutter_gail/services/location/location_model.dart';

class AddCrossingHelper {

  static Future<dynamic> textFieldValidation({
    required BuildContext context,
    required CrossingTypeModel crossingTypeData,
  }) async {

    try{
      if(crossingTypeData.id == null){
        SnackBarErrorWidget(context).show(message: "Please select crossing type");
        return false;
      }
      return true;
    }catch(_){}
    return false;
  }

  static Future<dynamic> fetchCrossingType() async {
    try{
      List<CrossingTypeModel> crossingTypeList = [];
      crossingTypeList.add(CrossingTypeModel(
        id: "1",
        crossingUrl: AppIcon.roadCrossingIcon,
        name: "Road"
      ));
      crossingTypeList.add(CrossingTypeModel(
          id: "2",
          crossingUrl: AppIcon.riverCrossingIcon,
          name: "River"
      ));
      crossingTypeList.add(CrossingTypeModel(
          id: "3",
          crossingUrl: AppIcon.railCrossingIcon,
          name: "Railway"
      ));
      return crossingTypeList;
    }catch(_){}
    return null;
  }


  static Future<dynamic> saveCrossingData({
    required BuildContext context,
    required TaskModel taskData,
    required CrossingTypeModel crossingTypeData,
    required String markerCondition,
    required String drainCondition,
    required String bankCondition,
    required String remark,
    required File cameraFile,
    required File voiceFile,
    required File videoFile,
  }) async {
    try {
      String url = APIs.addCrossingPointApi;
      List<FileModel> fileList = [];
      if (cameraFile.path.isNotEmpty) {
        fileList.add(FileModel(
            name: cameraFile.path
                .split('/')
                .last,
            file: cameraFile,
            keyName: "photo_link"));
      }
      if (voiceFile.path.isNotEmpty) {
        fileList.add(FileModel(
            name: voiceFile.path
                .split('/')
                .last,
            file: voiceFile,
            keyName: "voice_link"));
      }
      if (videoFile.path.isNotEmpty) {
        fileList.add(FileModel(
            name: videoFile.path
                .split('/')
                .last,
            file: videoFile,
            keyName: "video_link"));
      }

      var locationRes = await LocationHelper.getLocationOfflineMode(
          context: context);
      LocationModel locationData = LocationModel();
      if (locationRes != null) {
        locationData = locationRes;
      }
      var json = {
        "task_id": taskData.objectId.toString(),
        "inspectiondate": DateTime.now().toString(),
        "featuretype": crossingTypeData.name.toString(),
        "featuresubtype": "",
        "comments": remark.toString(),
        "marker_condition": markerCondition.toString(),
        "vent_drain": drainCondition.toString(),
        "bank_condition": bankCondition.toString(),
        "latitude": locationData.lat != null ? locationData.lat.toString() : "",
        "longitude": locationData.long != null
            ? locationData.long.toString()
            : "",
      };
      var res = await ServerRequest.postDataWithFile(urlEndPoint: url,
          body: json,
          context: !context.mounted ? context : context,
          fileList: fileList);
      if (res != null) {
        return res;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}