class GoogleRouteModel {
  List<GeocodedWaypoints>? geocodedWaypoints;
  List<Routes>? routes;
  String? status;

  GoogleRouteModel({this.geocodedWaypoints, this.routes, this.status});

  GoogleRouteModel.fromJson(Map<String, dynamic> json) {
    if (json['geocoded_waypoints'] != null) {
      geocodedWaypoints = <GeocodedWaypoints>[];
      json['geocoded_waypoints'].forEach((v) {
        geocodedWaypoints!.add( GeocodedWaypoints.fromJson(v));
      });
    }
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes!.add( Routes.fromJson(v));
      });
    }
    status = json['status'];
  }
}

class GeocodedWaypoints {
  String? geocoderStatus;
  String? placeId;
  List<String>? types;

  GeocodedWaypoints({this.geocoderStatus, this.placeId, this.types});

  GeocodedWaypoints.fromJson(Map<String, dynamic> json) {
    geocoderStatus = json['geocoder_status'];
    placeId = json['place_id'];
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['geocoder_status'] = geocoderStatus;
    data['place_id'] = placeId;
    data['types'] = types;
    return data;
  }
}

class Routes {
  Bounds? bounds;
  String? copyrights;
  List<Legs>? legs;
  Polyline? overviewPolyline;
  String? summary;
  List<Null>? warnings;
  List<Null>? waypointOrder;

  Routes(
      {this.bounds,
        this.copyrights,
        this.legs,
        this.overviewPolyline,
        this.summary,
        this.warnings,
        this.waypointOrder});

  Routes.fromJson(Map<String, dynamic> json) {
    bounds =
    json['bounds'] != null ?  Bounds.fromJson(json['bounds']) : null;
    copyrights = json['copyrights'];
    if (json['legs'] != null) {
      legs = <Legs>[];
      json['legs'].forEach((v) {
        legs!.add( Legs.fromJson(v));
      });
    }
    overviewPolyline = json['overview_polyline'] != null
        ?  Polyline.fromJson(json['overview_polyline'])
        : null;
    summary = json['summary'];
  }
}

class Bounds {
  Northeast? northeast;
  Northeast? southwest;

  Bounds({this.northeast, this.southwest});

  Bounds.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null
        ?  Northeast.fromJson(json['northeast'])
        : null;
    southwest = json['southwest'] != null
        ?  Northeast.fromJson(json['southwest'])
        : null;
  }
}

class Northeast {
  double? lat;
  double? lng;

  Northeast({this.lat, this.lng});

  Northeast.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }
}

class Legs {
  Distance? distance;
  Distance? duration;
  String? endAddress;
  Northeast? endLocation;
  String? startAddress;
  Northeast? startLocation;
  List<Steps>? steps;
  List<Null>? trafficSpeedEntry;
  List<Null>? viaWaypoint;

  Legs(
      {this.distance,
        this.duration,
        this.endAddress,
        this.endLocation,
        this.startAddress,
        this.startLocation,
        this.steps,
        this.trafficSpeedEntry,
        this.viaWaypoint});

  Legs.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ?  Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ?  Distance.fromJson(json['duration'])
        : null;
    endAddress = json['end_address'];
    endLocation = json['end_location'] != null
        ?  Northeast.fromJson(json['end_location'])
        : null;
    startAddress = json['start_address'];
    startLocation = json['start_location'] != null
        ?  Northeast.fromJson(json['start_location'])
        : null;
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add( Steps.fromJson(v));
      });
    }
  }
}

class Distance {
  String? text;
  int? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }
}

class Steps {
  Distance? distance;
  Distance? duration;
  Northeast? endLocation;
  String? htmlInstructions;
  Polyline? polyline;
  Northeast? startLocation;
  String? travelMode;
  String? maneuver;

  Steps(
      {this.distance,
        this.duration,
        this.endLocation,
        this.htmlInstructions,
        this.polyline,
        this.startLocation,
        this.travelMode,
        this.maneuver});

  Steps.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ?  Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ?  Distance.fromJson(json['duration'])
        : null;
    endLocation = json['end_location'] != null
        ?  Northeast.fromJson(json['end_location'])
        : null;
    htmlInstructions = json['html_instructions'];
    polyline = json['polyline'] != null
        ?  Polyline.fromJson(json['polyline'])
        : null;
    startLocation = json['start_location'] != null
        ?  Northeast.fromJson(json['start_location'])
        : null;
    travelMode = json['travel_mode'];
    maneuver = json['maneuver'];
  }
}

class Polyline {
  String? points;

  Polyline({this.points});

  Polyline.fromJson(Map<String, dynamic> json) {
    points = json['points'];
  }
}