import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_gail/feature/incident/add_incident/domain/model/incident_type_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/services/location/location_helper.dart';
import 'package:flutter_gail/services/location/location_model.dart';

class AddIncidentHelper {

  static Future<bool> textFieldValidation({
  required BuildContext context,
  required IncidentTypeModel incidentTypeData,
  required String incidentReport,
  }) async {
     try{
         if(incidentTypeData.id == null){
           SnackBarErrorWidget(context).show(message: "Please select incident type");
           return false;
         } else if(incidentReport.isEmpty){
           SnackBarErrorWidget(context).show(message: "Enter incident report");
           return false;
         }
         return true;
     }catch(_){}
    return false;
  }

  static Future<dynamic> fetchIncidentTypeData() async {
    try {
      String url = APIs.getIncidentTypeApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['data'] != null) {
        return incidentTypeListResponse(res['data']);
      }
    } catch (_) {
      return null;
    }
  }

  static Future<dynamic> saveIncidentData({
    required BuildContext context,
    required TaskModel taskData,
    required IncidentTypeModel incidentTypeData,
    required String incidentReport,
    required File imageFile,
    required File audioFile,
    required File videoFile,
  }) async {
       try{
         String url = APIs.addIncidentDataApi;
         List<FileModel> fileList = [];
         if (imageFile.path.isNotEmpty) {
           fileList.add(FileModel(
               name: imageFile.path
                   .split('/')
                   .last,
               file: imageFile,
               keyName: "photo_link"));
         }
         if (audioFile.path.isNotEmpty) {
           fileList.add(FileModel(
               name: audioFile.path
                   .split('/')
                   .last,
               file: audioFile,
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
           "task_id": taskData.subTaskId.toString().isEmpty ? taskData.taskId.toString() : taskData.subTaskId.toString(),
           "incident_report": incidentReport.toString(),
           "incident_type": incidentTypeData.id != null ? incidentTypeData.id.toString() : "",
           "latitude": locationData.lat != null ? locationData.lat.toString() : "0.0",
           "longitude": locationData.long != null
               ? locationData.long.toString()
               : "0.0"
         };
         var res = await ServerRequest.postDataWithFile(urlEndPoint: url,
             body: json,
             context: !context.mounted ? context : context,
             fileList: fileList);
         if (res != null && res['message'] != null) {
           SnackBarSuccessWidget(!context.mounted ? context : context).show(message: res['message'].toString());
           return res;
         }
         return null;
       }catch(_){}
       return null;
  }

}
