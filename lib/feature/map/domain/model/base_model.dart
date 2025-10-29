import 'package:hive/hive.dart';

part 'base_model.g.dart';

@HiveType(typeId: 0)
class BaseModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  DateTime? createdAt;

  @HiveField(2)
  DateTime? updatedAt;

  @HiveField(3)
  bool isSynced = false; // Indicates if data synced to server

  BaseModel({
    this.id,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isSynced = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "isSynced": isSynced,
    };
  }

  void markSynced() {
    isSynced = true;
    save();
  }
}
