class TLPModel {
  final int objectId;
  final String tlpno;
  final String tlpType;
  final String engRouteName;

  TLPModel({
    required this.objectId,
    required this.tlpno,
    required this.tlpType,
    required this.engRouteName,
  });

  @override
  String toString() {
    return '$engRouteName($tlpno-$tlpType)';
  }
}


class TLPObjectModel {
  TLPFeature? feature;

  TLPObjectModel({this.feature});

  TLPObjectModel.fromJson(Map<String, dynamic> json) {
    feature =
    json['feature'] != null ? new TLPFeature.fromJson(json['feature']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.feature != null) {
      data['feature'] = this.feature!.toJson();
    }
    return data;
  }
}

class TLPFeature {
  TLPAttributes? attributes;
  TLPGeometry? geometry;

  TLPFeature({this.attributes, this.geometry});

  TLPFeature.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? new TLPAttributes.fromJson(json['attributes'])
        : null;
    geometry = json['geometry'] != null
        ? new TLPGeometry.fromJson(json['geometry'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    return data;
  }
}

class TLPAttributes {
  int? oBJECTID;
  int? aSSETGROUP;
  int? aSSETTYPE;
  int? maintby;
  String? notes;
  double? gpsx;
  double? gpsy;
  String? engroutename;
  double? engm;
  String? continroutename;
  double? continm;
  String? tLPType;
  int? tLPoldch;
  String? tlpno;

  TLPAttributes(
      {this.oBJECTID,
        this.aSSETGROUP,
        this.aSSETTYPE,
        this.maintby,
        this.notes,
        this.gpsx,
        this.gpsy,
        this.engroutename,
        this.engm,
        this.continroutename,
        this.continm,
        this.tLPType,
        this.tLPoldch,
        this.tlpno});

  TLPAttributes.fromJson(Map<String, dynamic> json) {
    oBJECTID = json['OBJECTID'];
    aSSETGROUP = json['ASSETGROUP'];
    aSSETTYPE = json['ASSETTYPE'];
    maintby = json['maintby'];
    notes = json['notes'];
    gpsx = json['gpsx'];
    gpsy = json['gpsy'];
    engroutename = json['engroutename'];
    engm = json['engm'];
    continroutename = json['continroutename'];
    continm = json['continm'];
    tLPType = json['TLPType'];
    tLPoldch = json['TLPoldch'];
    tlpno = json['tlpno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OBJECTID'] = this.oBJECTID;
    data['ASSETGROUP'] = this.aSSETGROUP;
    data['ASSETTYPE'] = this.aSSETTYPE;
    data['maintby'] = this.maintby;
    data['notes'] = this.notes;
    data['gpsx'] = this.gpsx;
    data['gpsy'] = this.gpsy;
    data['engroutename'] = this.engroutename;
    data['engm'] = this.engm;
    data['continroutename'] = this.continroutename;
    data['continm'] = this.continm;
    data['TLPType'] = this.tLPType;
    data['TLPoldch'] = this.tLPoldch;
    data['tlpno'] = this.tlpno;
    return data;
  }
}

class TLPGeometry {
  double? x;
  double? y;

  TLPGeometry({this.x, this.y});

  TLPGeometry.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}
