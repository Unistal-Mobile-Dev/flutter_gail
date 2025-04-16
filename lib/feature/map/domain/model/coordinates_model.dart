class GeometryModel {
  late String type;
  late List<CoordinatesModel> coordinates;

  GeometryModel.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? '';
    List<dynamic> rawCoordinates = json['coordinates'] ?? [];
    coordinates = rawCoordinates.map((data) {
      if (data is List && data.length >= 2) {
        return CoordinatesModel(
          longitude: data[0].toDouble(),
          latitude: data[1].toDouble(),
        );
      } else {
        return CoordinatesModel(latitude: 0.0, longitude: 0.0); // default or handle error
      }
    }).toList();
  }
}
class CoordinatesModel {
   double latitude;
   double longitude;
   CoordinatesModel({required this.latitude, required this.longitude});
}