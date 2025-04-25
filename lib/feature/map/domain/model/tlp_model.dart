List<TlpModel> tlpListResponse(var json) {
  return List<TlpModel>.from(json.map((x) => TlpModel.fromJson(x)));
}

class TlpModel {
  dynamic id;
  dynamic type;
  double? gpsx;
  double? gpsy;

  TlpModel({this.id, this.type, this.gpsx, this.gpsy});

  factory TlpModel.fromJson(Map<String, dynamic> json) {
    return TlpModel(
       id: json['id'] ?? "",
       type: json['type'] ?? "",
       gpsx: json['gpsx'] ?? "",
       gpsy: json['gpsy'] ?? "",
    );
  }
}