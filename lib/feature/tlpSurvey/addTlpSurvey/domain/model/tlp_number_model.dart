List<TlpNumberModel> tlpNumberListResponse(var json) {
   return List<TlpNumberModel>.from(json.map((x) => TlpNumberModel.fromJson(x)));
}

class TlpNumberModel {
  String? assetId;
  dynamic engm;
  String? station;
  dynamic gpsx;
  dynamic gpsy;
  String? typeOfTlp;
  String? addTlpConn;
  String? locationDescription;
  String? anodeType;
  String? agbConfig;

  TlpNumberModel(
      {this.assetId,
        this.engm,
        this.station,
        this.gpsx,
        this.gpsy,
        this.typeOfTlp,
        this.addTlpConn,
        this.locationDescription,
        this.anodeType,
        this.agbConfig});

  TlpNumberModel.fromJson(Map<String, dynamic> json) {
    assetId = json['assetid'] ?? "";
    engm = json['engm'] ?? "";
    station = json['station'] ?? "";
    gpsx = json['gpsx'] ?? "";
    gpsy = json['gpsy'] ?? "";
    typeOfTlp = json['typeOfTlp'] ?? "";
    addTlpConn = json['addTlpConn'] ?? "";
    locationDescription = json['locationdescription'] ?? "";
    anodeType = json['anodeType'] ?? "";
    agbConfig = json['agbConfig'] ?? "";
  }

}