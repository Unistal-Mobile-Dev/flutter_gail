List<EncroachmentModel> encroachmentListResponse(var json) {
  return List<EncroachmentModel>.from(json.map((x) => EncroachmentModel.fromJson(x)));
}

class EncroachmentModel {

  dynamic value;
  String? label;

  EncroachmentModel({this.value, this.label});

  factory EncroachmentModel.fromJson(Map<String, dynamic> json) {
    return EncroachmentModel(
      value: json['value'] ?? "",
      label: json['label'] ?? "",
    );
  }

}