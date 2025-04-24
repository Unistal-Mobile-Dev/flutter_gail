

import 'package:flutter_gail/feature/login/domain/models/permissions_model.dart';

LoginDataModel loginResponse(var json) {
  return LoginDataModel.fromJson(json);
}

class LoginDataModel {
  Users? users;
  List<Modules>? modules;
  List<Roles>? roles;
  List<dynamic>? groups;
  List<dynamic>? verificationDetails;
  Tokens? tokens;
  String? name;


  LoginDataModel(
      {this.users,
      this.modules,
      this.roles,
      this.groups,
      this.verificationDetails,
      this.name,
      this.tokens});

  LoginDataModel.fromJson(Map<String, dynamic> json) {
    name =  json['user_name'] ?? "";
    users = json['users'] != null ? Users.fromJson(json['users']) : null;
    if (json['modules'] != null) {
      modules = <Modules>[];
      json['modules'].forEach((v) {
        modules!.add(Modules.fromJson(v));
      });
    }
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }

    tokens = json['tokens'] != null ? Tokens.fromJson(json['tokens']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (users != null) {
      data['users'] = users!.toJson();
    }
    if (modules != null) {
      data['modules'] = modules!.map((v) => v.toJson()).toList();
    }
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    if (tokens != null) {
      data['tokens'] = tokens!.toJson();
    }
    return data;
  }
}

class Users {
  dynamic id;
  String? firstName;
  String? surName;
  String? emailId;
  String? mobileNo;
  String? countryCode;
  String? companyName;
  String? department;
  String? designation;
  String? securityId;
  dynamic status;
  String? createdAt;
  String? updatedAt;
  dynamic updatedBy;
  dynamic createdBy;
  String? uuidUserId;
  dynamic type;

  Users(
      {this.id,
      this.firstName,
      this.surName,
      this.emailId,
      this.mobileNo,
      this.countryCode,
      this.companyName,
      this.department,
      this.designation,
      this.securityId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.updatedBy,
      this.createdBy,
      this.uuidUserId,
      this.type});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    firstName = json['first_name'] ?? "";
    surName = json['sur_name'] ?? "";
    emailId = json['email_id'] ?? "";
    mobileNo = json['mobile_no'] ?? "";
    countryCode = json['country_code'] ?? "";
    companyName = json['company_name'] ?? "";
    department = json['department'] ?? "";
    designation = json['designation'] ?? "";
    securityId = json['security_id'] ?? "";
    status = json['status'] ?? "";
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    updatedBy = json['updated_by'] ?? "";
    createdBy = json['created_by'] ?? "";
    uuidUserId = json['uuid_user_id'] ?? "";
    type = json['type'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['sur_name'] = surName;
    data['email_id'] = emailId;
    data['mobile_no'] = mobileNo;
    data['country_code'] = countryCode;
    data['company_name'] = companyName;
    data['department'] = department;
    data['designation'] = designation;
    data['security_id'] = securityId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['updated_by'] = updatedBy;
    data['created_by'] = createdBy;
    data['uuid_user_id'] = uuidUserId;
    data['type'] = type;
    return data;
  }
}

class Modules {
  String? permissionMask;
  String? moduleName;
  List<PermissionsModel>? permissionList;

  Modules({this.permissionMask, this.moduleName});

  Modules.fromJson(Map<String, dynamic> json) {
    permissionMask = json['permission_mask'] ?? "";
    moduleName = json['module_name'] ?? "";
    permissionList = json['permissions'] != null ? permissionsListResponse(json['permissions']) :[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['permission_mask'] = permissionMask;
    data['module_name'] = moduleName;
    return data;
  }
}


class Roles {
  int? roleId;
  String? roleName;

  Roles({this.roleId, this.roleName});

  Roles.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'] ?? "";
    roleName = json['role_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role_id'] = roleId;
    data['role_name'] = roleName;
    return data;
  }
}

class Tokens {
  String? access;
  int? expiresIn;

  Tokens({this.access, this.expiresIn});

  Tokens.fromJson(Map<String, dynamic> json) {
    access = json['access'] ?? "";
    expiresIn = json['expiresIn'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access'] = access;
    data['expiresIn'] = expiresIn;
    return data;
  }
}

class LoginScreenRequestModel {
  final String userEmailId;
  final String password;
  final String firebaseId;
  final String deviceId;

  LoginScreenRequestModel(
      {required this.userEmailId,
      required this.password,
      required this.firebaseId,
      required this.deviceId});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "email": userEmailId,
      "password": password,
      "browserDetails": {
        "browserName": "",
        "browserVersion": "",
        "userAgent": "",
        "platform": "android"
      },
      "ipAddress": "",
      "location": {
        "city": "",
        "region": "",
        "country": "",
        "postal": "",
        "latitude": 0,
        "longitude": 0,
      }
    };
    return map;
  }
}
