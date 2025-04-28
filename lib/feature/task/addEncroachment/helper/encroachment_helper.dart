import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_gail/feature/login/helper/login_helper.dart';
import 'package:flutter_gail/feature/task/addEncroachment/domain/model/encroachment_model.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/services/location/location_helper.dart';
import 'package:flutter_gail/services/location/location_model.dart';

class EncroachmentHelper {

  static Future<dynamic> fetchEncroachmentTypes() async {

      try {
        String url =  APIs.getEncroachmentTypeApi;
        var res =  await ServerRequest.getData(urlEndPoint: url);
        if(res != null && res['data'] != null){
          return encroachmentListResponse(res['data']);
        }
      }catch(_){}
      return null;
  }

  static Future<dynamic> textFiledValidation(
         {required BuildContext context, required String chainage,
            required EncroachmentModel encroachmentData,
            required LocationModel locationData, required File file}) async {
       try{
            if(chainage.isEmpty){
              SnackBarErrorWidget(context).show(message: "Please enter chainage");
              return false;
            }
            else if(encroachmentData.value == null){
              SnackBarErrorWidget(context).show(message: "Please select encroachment");
              return false;
            }
            else if(file.path.isEmpty){
              SnackBarErrorWidget(context).show(message: "Upload photo");
              return false;
            }
            return true;
       }catch(_){}
      return false;
  }

  static Future<dynamic> submit(
      { required BuildContext context, required String chainage,
        required EncroachmentModel encroachmentData,
        required TaskModel taskData,
        required LocationModel locationData, required File file}) async {
    try{

      String url = APIs.addRouteObserveApi;
      List<FileModel> fileList = [];
      if (file.path.isNotEmpty) {
        fileList.add(FileModel(
            name: file.path
                .split('/')
                .last,
            file: file,
            keyName: "photo_link"));
      }
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String currentDate = formatter.format(DateTime.now());
      var deviceId = await LoginHelper.getUniqueDeviceId();
      var json = {
        "task_id" : taskData.taskId.toString(),
        "patrollroute_id" : taskData.patrollRouteId.toString(),
        "observation_type" : "Encroachment",
        "sectionCode " : taskData.sectionCode.toString(),
        "description" : chainage,
        "condition" : "",
        "crossing_marker": "",
        "bank_condition": "",
        "inspection_date" : currentDate.toString(),
        "gpsx": locationData.lat != null ? locationData.lat.toString() : "0.0",
        "gpsy": locationData.long != null ? locationData.long.toString(): "0.0",
        "gps_accuracy" : locationData.accuracy.toString(),
        "observation_subtype" : encroachmentData.value != null ? encroachmentData.value.toString() : "",
        "device_id" : deviceId.toString(),
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