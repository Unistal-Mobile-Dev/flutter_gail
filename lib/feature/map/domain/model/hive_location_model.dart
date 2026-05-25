import 'package:hive/hive.dart';

part 'hive_location_model.g.dart';

@HiveType(typeId: 1)
class HiveLocationModel extends HiveObject {
  @HiveField(0)
  String taskId;

  @HiveField(1)
  String subTaskId;

  @HiveField(2)
  double gpsX;

  @HiveField(3)
  double gpsY;

  @HiveField(4)
  double distance;

  @HiveField(5)
  double bearing;

  @HiveField(6)
  double speed;

  @HiveField(7)
  double gpsAccuracy;

  @HiveField(8)
  int battery;

  @HiveField(9)
  DateTime inspectedDateTime;

  @HiveField(10)
  bool isSynced;

  @HiveField(11)
  String schema;

  HiveLocationModel({
    required this.taskId,
    required this.subTaskId,
    required this.gpsX,
    required this.gpsY,
    required this.distance,
    required this.bearing,
    required this.speed,
    required this.gpsAccuracy,
    required this.battery,
    required this.inspectedDateTime,
    this.isSynced = false,
    required this.schema,
  });

  Map<String, dynamic> toServerJson() => {
    "task_id": taskId,
    "subtask_id": subTaskId,
    "schema": schema,
    "locations": [
      {
        "gpsx": gpsX.toString(),
        "gpsy": gpsY.toString(),
        "gpsaccuracy": gpsAccuracy.toString(),
        "speed": speed.toString(),
        "bearing": bearing.toString(),
        "distance": distance.toStringAsFixed(2),
        "battery": battery.toString(),
        "inspected_datetime": inspectedDateTime.toIso8601String(),
        "provider": "GPS1",
        "buffer": 15.0,
      }
    ]
  };
}
