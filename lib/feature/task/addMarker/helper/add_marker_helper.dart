import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_gail/feature/task/addMarker/domain/model/marker_type_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/services/location/location_helper.dart';
import 'package:flutter_gail/services/location/location_model.dart';

class AddMarkerHelper {

  static Future<dynamic> textFieldValidation({
    required BuildContext context,
    required MarkerTypeModel  markerTypeData,
   }) async {

     try{
        if(markerTypeData.id == null){
          SnackBarErrorWidget(context).show(message: "Please select marker type");
          return false;
        }
        return true;
     }catch(_){
       return false;
     }
  }

  static Future<dynamic> fetchMarkerType() async {
    try{
      List<MarkerTypeModel> markerTypeList = [];

      markerTypeList.add(MarkerTypeModel(
        id: "1",
        markerUrl: AppIcon.wmIcon,
        name: "WM"
      ));

      markerTypeList.add(MarkerTypeModel(
          id: "2",
          markerUrl: AppIcon.kmIcon,
          name: "KM"
      ));

      markerTypeList.add(MarkerTypeModel(
          id: "3",
          markerUrl: AppIcon.dmIcon,
          name: "DM"
      ));

      markerTypeList.add(MarkerTypeModel(
          id: "4",
          markerUrl: AppIcon.tlpIcon,
          name: "TLP"
      ));

      markerTypeList.add(MarkerTypeModel(
          id: "5",
          markerUrl: AppIcon.bpIcon,
          name: "BP"
      ));
      return markerTypeList;
    }catch(_){}
    return null;
  }

  static Future<dynamic> addMarkerData({
     required BuildContext context,
     required TaskModel taskData,
     required MarkerTypeModel markerTypeData,
     required String condition,
     required String painting,
     required String remark,
     required File cameraFile,
     required File voiceFile,
     required File videoFile,
 }) async {
      try{
        String url =  APIs.addMarkerPointApi;
        List<FileModel> fileList = [];
        if(cameraFile.path.isNotEmpty){
          fileList.add(FileModel(
              name: cameraFile.path.split('/').last,
              file: cameraFile,
              keyName: "photo_link"));
        }
        if(voiceFile.path.isNotEmpty){
          fileList.add(FileModel(
              name: voiceFile.path.split('/').last,
              file: voiceFile,
              keyName: "voice_link"));
        }
        if(videoFile.path.isNotEmpty){
          fileList.add(FileModel(
              name: videoFile.path.split('/').last,
              file: videoFile,
              keyName: "video_link"));
        }

        var locationRes =  await LocationHelper.getLocationOfflineMode(context: context);
        LocationModel locationData =  LocationModel();
        if(locationRes != null){
          locationData =  locationRes;
        }
        var json = {
          "task_id" : taskData.taskId.toString(),
          "inspectiondate" : DateTime.now().toString(),
          "featuretype" : markerTypeData.name.toString(),
          "featuresubtype" : "",
          "comments" : remark.toString(),
          "marker_condition" : condition.toString(),
          "marker_paint" : painting.toString(),
          "latitude": locationData.lat != null ? locationData.lat.toString() : "0.0",
          "longitude": locationData.long != null
              ? locationData.long.toString()
              : "0.0",
        };
        var res =  await ServerRequest.postDataWithFile(urlEndPoint: url,
            body: json, context: !context.mounted ? context :context, fileList: fileList);
        if(res != null &&  res['message'] != null){
          SnackBarSuccessWidget(!context.mounted ? context :context).show(message: res['message'].toString());
          return res;
        }
        return null;
      }catch(_){
        return null;
      }
   }

}