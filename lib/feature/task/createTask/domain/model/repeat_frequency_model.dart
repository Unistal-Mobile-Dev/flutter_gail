List<RepeatFrequencyModel> repeatFrequencyListResponse(var json) {
  return List<RepeatFrequencyModel>.from(json.map((x) => RepeatFrequencyModel.fromJson(x)));
}

class RepeatFrequencyModel {

  dynamic id;
  String? name;

  RepeatFrequencyModel({
   this.name,
   this.id,
});

  factory RepeatFrequencyModel.fromJson(Map<String, dynamic> json) {
    return RepeatFrequencyModel(
      id: json[''] ?? "",
      name: json[''] ?? "",
    );
  }
}