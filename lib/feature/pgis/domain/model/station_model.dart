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



class StructureBoundaryPoint {
  final int objectId;
  final String stationName;
  final String engRouteName;
  final double x;
  final double y;

  StructureBoundaryPoint({
    required this.objectId,
    required this.stationName,
    required this.engRouteName,
    required this.x,
    required this.y,
  });

  factory StructureBoundaryPoint.fromJson(Map<String, dynamic> json) {
    final attr = json['attributes'];
    final geom = json['geometry'];

    return StructureBoundaryPoint(
      objectId: attr['OBJECTID'],
      stationName: attr['stationname'] ?? '',
      engRouteName: attr['engroutename'] ?? '',
      x: geom['x'].toDouble(),
      y: geom['y'].toDouble(),
    );
  }
}


