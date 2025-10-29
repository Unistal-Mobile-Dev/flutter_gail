LocationModel responseLocationData(var json) {
  return LocationModel.fromJson(json);
}

class LocationModel {
  String? address;
  double? lat;
  double? long;
  String? city;
  String? accuracy;
  String? speed;

  LocationModel({this.address, this.long, this.lat, this.city, this.accuracy, this.speed});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['address'] ?? "",
      lat: json['lat'] ?? 0.0,
      long: json['long'] ?? 0.0,
      city: json['city'] ?? "",
      accuracy: json['accuracy'] ?? "",
      speed: json['speed'] ?? "0",
    );
  }
}
