class StationModel {
  final int objectId;
  final String stationName;
  final String engRouteName;

  StationModel({
    required this.objectId,
    required this.stationName,
    required this.engRouteName,
  });

  @override
  String toString() {
    return '$engRouteName($stationName)';
  }
}
