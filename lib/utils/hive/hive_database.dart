import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveDataBase {
/*  static Box<InsertLiveLocalData>? liveLocationBox;*/

  Future<void> init() async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    Directory filesDir = Directory(tempDir.path)..createSync(recursive: true);
    Hive.init(filesDir.path);

/*    Hive.registerAdapter(InsertLiveLocalDataAdapter());
    liveLocationBox =  await Hive.openBox<InsertLiveLocalData>(HiveBoxName.liveLocationBoxName);*/
  }
}
