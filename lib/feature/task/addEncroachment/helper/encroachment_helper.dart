import 'package:flutter_gail/ExportFile/app_export_file.dart';

class EncroachmentHelper {

  static Future<dynamic> fetchEncroachmentTypes() async {

      try {
        String url =  APIs.getEncroachmentTypeApi;
        var res =  await ServerRequest.getData(urlEndPoint: url);
        if(res != null){
          return res;
        }
      }catch(_){}
      return null;
  }

}