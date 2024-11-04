import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirectoryUtil {
  DirectoryUtil();

  static Future<File> getDirPath(String filename) async {
    try {
      File? file;
      if (Platform.isAndroid) {
        // Directory downloadDir = await getApplicationDocumentsDirectory();
        final Directory downloadDir =
        Directory('/storage/emulated/0/Documents');
        final bool isPathExist = downloadDir.existsSync();
        if (isPathExist) {
          file = File('${downloadDir.path}/$filename');
        } else {
          final List<Directory> output = await getExternalStorageDirectories(
              type: StorageDirectory.downloads) ??
              <Directory>[];
          if (output.isNotEmpty) {
            final Directory absoluteDir = output.firstWhere(
                    (Directory directory) => directory.path.contains('emulated'));
            const String r =
                r'Android\/data\/com\.hrms\.lead\/files\/[Dd]ownloads';
            file = File(
                "${absoluteDir.path.replaceAll(RegExp(r), "Download")}/$filename");
                    } else {
            throw Exception('Unable to create file.');
          }
        }
      } else if (Platform.isIOS) {
        final Directory output = await getApplicationDocumentsDirectory();
        file = File('${output.path}/$filename');
      }
      print("File Path ---- " + file!.path.toString());
      return file;
    } catch (e) {
      log('$e');
      throw Exception('Unable to create file.');
    }
  }
}
