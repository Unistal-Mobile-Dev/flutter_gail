List<LineWalkerUsersModel> lineWalkerUsersFromJson(List<dynamic> jsonList) {
  return jsonList.map((e) => LineWalkerUsersModel.fromJson(e)).toList();
}

class LineWalkerUsersModel {
  dynamic userId;
  String? name;
  String? loginId;
  dynamic vendor;

  LineWalkerUsersModel({
    this.userId,
    this.name,
    this.loginId,
    this.vendor,
  });

  factory LineWalkerUsersModel.fromJson(Map<String, dynamic> json) {
    return LineWalkerUsersModel(
      userId: json['userId'] ?? 0,
      name: json['name'] ?? '',
      loginId: json['login_id'] ?? '',
      vendor: json['vendor'] ?? 0,
    );
  }

}
