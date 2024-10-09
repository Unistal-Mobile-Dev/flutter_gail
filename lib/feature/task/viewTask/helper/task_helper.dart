import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';

class TaskHelper {

  static Future<dynamic> fetchTask() async {
    try{
      String url =  APIs.getTaskApi;
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['data'] != null){
        return taskListResponse(res['data']);
      }
      return null;
    }catch(_){}
    return null;
  }
}