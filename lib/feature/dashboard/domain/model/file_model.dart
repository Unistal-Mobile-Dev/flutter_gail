import 'dart:io';

class FileModel {
  File file;
  String name;
  String keyName;
  double? lat;
  double? long;

  FileModel({required this.name, required this.file, required this.keyName, this.lat, this.long});
}
