class StructureBoundaryFeature {
  final StructureBoundaryAttributes attributes;
  final StructureBoundaryGeometry geometry;

  StructureBoundaryFeature({required this.attributes, required this.geometry});

  factory StructureBoundaryFeature.fromJson(Map<String, dynamic> json) {
    return StructureBoundaryFeature(
      attributes: StructureBoundaryAttributes.fromJson(json['attributes']),
      geometry: StructureBoundaryGeometry.fromJson(json['geometry']),
    );
  }
}

class StructureBoundaryAttributes {
  final dynamic objectId;
  final String stationName;
  final dynamic ownedBy;
  final dynamic lifecycleStatus;
  final String? notes;
  final String contRouteName;
  final String engRouteName;
  final String? realArrangement;
  final String? responsibleContactName;
  final String? responsiblePartyPhone;
  final String gailRefDocument;
  final String description;
  final dynamic engM;
  final dynamic contM;
  final dynamic areaSqM;
  final String comments;
  final String newType;
  final dynamic newLevel;

  StructureBoundaryAttributes({
    required this.objectId,
    required this.stationName,
    required this.ownedBy,
    required this.lifecycleStatus,
    this.notes,
    required this.contRouteName,
    required this.engRouteName,
    this.realArrangement,
    this.responsibleContactName,
    this.responsiblePartyPhone,
    required this.gailRefDocument,
    required this.description,
    this.engM,
    this.contM,
    this.areaSqM,
    required this.comments,
    required this.newType,
    required this.newLevel,
  });

  factory StructureBoundaryAttributes.fromJson(Map<String, dynamic> json) {
    return StructureBoundaryAttributes(
      objectId: json['OBJECTID'].toString() ?? "",
      stationName: json['stationname'].toString() ?? "",
      ownedBy: json['ownedby'].toString() ?? "",
      lifecycleStatus: json['lifecyclestatus'].toString() ?? "",
      notes: json['notes'].toString() ?? "",
      contRouteName: json['continroutename'].toString() ?? "",
      engRouteName: json['engroutename'].toString() ?? "",
      realArrangement: json['gnrealarrangment'].toString() ?? "",
      responsibleContactName: json['responsiblecontactname'].toString() ?? "",
      responsiblePartyPhone: json['responsiblepartyphone'].toString() ?? "",
      gailRefDocument: json['gailrefdocument'].toString() ?? "",
      description: json['description'].toString() ?? "",
      engM: json['engm'].toString() ?? "",
      contM: json['continm'].toString() ?? "",
      areaSqM: json['Area_SqM_Station'].toString() ?? "",
      comments: json['comments'].toString() ?? "",
      newType: json['newType'].toString() ?? "",
      newLevel: json['newLevel'].toString() ?? "0.0",
    );
  }
}

class StructureBoundaryGeometry {
  final double x;
  final double y;

  StructureBoundaryGeometry({required this.x, required this.y});

  factory StructureBoundaryGeometry.fromJson(Map<String, dynamic> json) {
    return StructureBoundaryGeometry(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }
}
