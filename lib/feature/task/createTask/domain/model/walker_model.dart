List<WalkerModel> walkerListResponse(var json) {
  return List<WalkerModel>.from(json.map((x) => WalkerModel.fromJson(x)));
}

class WalkerModel {

  dynamic id;
  String? name;
  bool? isSelected;

  WalkerModel({
   this.id,
   this.name,
   this.isSelected
});

  factory WalkerModel.fromJson(Map<String, dynamic> json) {
    return WalkerModel(
      id: json[''] ?? "",
      name: json[''] ?? "",
      isSelected: false,
    );
  }

}