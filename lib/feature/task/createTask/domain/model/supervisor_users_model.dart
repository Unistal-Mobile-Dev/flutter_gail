List<SupervisorUsersModel> supervisorUsersListResponse(var json) {
   return List<SupervisorUsersModel>.from(json.map((x) => SupervisorUsersModel.fromJson(x)));
}

class SupervisorUsersModel {

     dynamic userId;
     String? name;
     String? loginIId;
     dynamic vendor;

     SupervisorUsersModel({this.userId, this.name, this.loginIId, this.vendor});

     factory SupervisorUsersModel.fromJson(Map<String, dynamic> json) {
        return SupervisorUsersModel(
            userId: json['userId'] ?? "",
            name: json['name'] ?? "",
            loginIId: json['login_id'] ?? "",
            vendor: json['vendor'] ?? "",
        );
     }
}