List<UserNameModel> userNameListResponse(var json) {
  return List<UserNameModel>.from(json.map((x) => UserNameModel.fromJson(x)));
}

class UserNameModel {
  dynamic id;
  String? name;
  String? emailId;
  String? securityId;
  String? companyName;

  UserNameModel({
   this.id,
   this.name,
   this.emailId,
   this.companyName,
   this.securityId,
});

  factory UserNameModel.fromJson(Map<String, dynamic> json) {
    return UserNameModel(
      id: json[''] ?? "",
      name: json['name'] ?? "",
      emailId: json['email_id'] ?? "",
      companyName: json['company_name'] ?? "",
      securityId: json['security_id'] ?? "",
    );
  }
}