import 'package:flutter_gail/ExportFile/app_export_file.dart';

LoginDataModel loginResponse(Map<String, dynamic> json) {
  return LoginDataModel.fromJson(json);
}

class LoginDataModel {
  final bool? success;
  final Users? users;
  final String? role;
  final List<String>? userType;
  final List<GroupRoles>? groupRoles;
  final String? gid;
  final String? schema;
  final dynamic gaLatitude;
  final dynamic gaLongitude;
  final Tokens? tokens;

  LoginDataModel({
    this.success,
    this.users,
    this.role,
    this.userType,
    this.groupRoles,
    this.gid,
    this.schema,
    this.gaLatitude,
    this.gaLongitude,
    this.tokens,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      success: json['success'] ?? "",
      users: json['users'] != null ? Users.fromJson(json['users']) : null,
      role: json['role'] ?? "",
      userType:
          json['user_type'] != null ? List<String>.from(json['user_type']) : [],
      groupRoles:
          json['group_roles'] != null
              ? (json['group_roles'] as List)
                  .map((v) => GroupRoles.fromJson(v))
                  .toList()
              : [],
      gid: json['gid'] ?? "",
      schema: json['schema'] ?? "",
      gaLatitude: json['ga_latitude'] ?? "",
      gaLongitude: json['ga_longitude'] ?? "",
      tokens: json['tokens'] != null ? Tokens.fromJson(json['tokens']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'users': users?.toJson(),
      'role': role,
      'user_type': userType,
      'group_roles': groupRoles!.map((v) => v.toJson()).toList(),
      'gid': gid,
      'schema': schema,
      'ga_latitude': gaLatitude,
      'ga_longitude': gaLongitude,
      'tokens': tokens?.toJson(),
    };
  }
}

class Users {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;

  Users({this.id, this.fullName, this.email, this.phoneNumber});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id']?.toString(),
      fullName: json['full_name'] ?? "",
      email: json['email'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
    };
  }
}

class GroupRoles {
  final int? moduleId;
  final String? moduleName;
  final String? moduleAlias;
  final String? link;
  final String? moduleIconUrl;
  final String? dashboardReportIcon;
  final int? displayOrder;
  final bool? active;
  final List<Permissions>? permissions;
  final List<dynamic>? subModules;
  final List<dynamic>? groups;
  final AppModule appModule;

  GroupRoles({
    this.moduleId,
    this.moduleName,
    this.moduleAlias,
    this.link,
    this.moduleIconUrl,
    this.dashboardReportIcon,
    this.displayOrder,
    this.active,
    this.permissions,
    this.subModules,
    this.groups,
    this.appModule = AppModule.steelLinePatrolling,
  });

  factory GroupRoles.fromJson(Map<String, dynamic> json) {
    return GroupRoles(
      moduleId: json['module_id'] ?? "",
      moduleName: json['module_name'] ?? "",
      moduleAlias: json['module_alias'] ?? "",
      link: json['link'] ?? "",
      moduleIconUrl: json['module_icon_url'] ?? "",
      dashboardReportIcon: json['dashboard_report_icon'] ?? "",
      displayOrder: json['display_order'] ?? "",
      active: json['active'] ?? "",
      appModule: getAppModule(json['module_name'] ?? ""),
      permissions:
          json['permissions'] != null
              ? (json['permissions'] as List)
                  .map((v) => Permissions.fromJson(v))
                  .toList()
              : [],
      subModules:
          json['subModules'] != null
              ? List<dynamic>.from(json['subModules'])
              : [],
      groups: json['groups'] != null ? List<dynamic>.from(json['groups']) : [],
    );
  }

  static AppModule getAppModule(String appModule) {
    switch (appModule) {
      case "MDPE Line Patrolling":
        return AppModule.mdpLinePatrolling;
      default:
        return AppModule.steelLinePatrolling;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'module_id': moduleId,
      'module_name': moduleName,
      'module_alias': moduleAlias,
      'link': link,
      'module_icon_url': moduleIconUrl,
      'dashboard_report_icon': dashboardReportIcon,
      'display_order': displayOrder,
      'active': active,
      'permissions': permissions!.map((v) => v.toJson()).toList(),
      'subModules': subModules,
      'groups': groups,
    };
  }
}

class Permissions {
  final String? name;
  final bool? value;

  Permissions({this.name, this.value});

  factory Permissions.fromJson(Map<String, dynamic> json) {
    return Permissions(name: json['name'] ?? "", value: json['value'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}

class Tokens {
  final String? access;
  final int? expiresIn;

  Tokens({this.access, this.expiresIn});

  factory Tokens.fromJson(Map<String, dynamic> json) {
    return Tokens(
      access: json['access'] ?? "",
      expiresIn: json['expiresIn'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'access': access, 'expiresIn': expiresIn};
  }
}

//
// LoginDataModel loginResponse(var json) {
//   return LoginDataModel.fromJson(json);
// }
//
// class LoginDataModel {
//   Users? users;
//   List<Modules>? modules;
//   List<Roles>? roles;
//   List<dynamic>? groups;
//   List<dynamic>? verificationDetails;
//   Tokens? tokens;
//   String? name;
//
//
//   LoginDataModel(
//       {this.users,
//       this.modules,
//       this.roles,
//       this.groups,
//       this.verificationDetails,
//       this.name,
//       this.tokens});
//
//   LoginDataModel.fromJson(Map<String, dynamic> json) {
//     name =  json['user_name'] ?? "";
//     users = json['users'] != null ? Users.fromJson(json['users']) : null;
//     if (json['group_roles'] != null && json['group_roles'] != '') {
//       modules = <Modules>[];
//       json['group_roles'].forEach((v) {
//         modules!.add(Modules.fromJson(v));
//       });
//     }
//     if (json['roles'] != null) {
//       roles = <Roles>[];
//       json['roles'].forEach((v) {
//         roles!.add(Roles.fromJson(v));
//       });
//     }
//
//     tokens = json['tokens'] != null ? Tokens.fromJson(json['tokens']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (users != null) {
//       data['users'] = users!.toJson();
//     }
//     if (modules != null) {
//       data['modules'] = modules!.map((v) => v.toJson()).toList();
//     }
//     if (roles != null) {
//       data['roles'] = roles!.map((v) => v.toJson()).toList();
//     }
//     if (tokens != null) {
//       data['tokens'] = tokens!.toJson();
//     }
//     return data;
//   }
// }
//
//
// class Modules {
//   String? permissionMask;
//   String? moduleName;
//   dynamic moduleId;
//   List<PermissionsModel>? permissionList;
//
//   Modules({this.permissionMask, this.moduleName});
//
//   Modules.fromJson(Map<String, dynamic> json) {
//     permissionMask = json['permission_mask'] ?? "";
//     moduleName = json['module_name'] ?? "";
//     moduleId = json['module_id'] ?? "";
//     permissionList = json['permissions'] != null ? permissionsListResponse(json['permissions']) :[];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['permission_mask'] = permissionMask;
//     data['module_name'] = moduleName;
//     return data;
//   }
// }
//
//
// class Roles {
//   int? roleId;
//   String? roleName;
//
//   Roles({this.roleId, this.roleName});
//
//   Roles.fromJson(Map<String, dynamic> json) {
//     roleId = json['role_id'] ?? "";
//     roleName = json['role_name'] ?? "";
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['role_id'] = roleId;
//     data['role_name'] = roleName;
//     return data;
//   }
// }
//
// class Tokens {
//   String? access;
//   int? expiresIn;
//
//   Tokens({this.access, this.expiresIn});
//
//   Tokens.fromJson(Map<String, dynamic> json) {
//     access = json['access'] ?? "";
//     expiresIn = json['expiresIn'] ?? "";
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['access'] = access;
//     data['expiresIn'] = expiresIn;
//     return data;
//   }
// }

class LoginScreenRequestModel {
  final String userEmailId;
  final String password;
  final String firebaseId;
  final String deviceId;
  final String loginType;

  LoginScreenRequestModel({
    required this.userEmailId,
    required this.password,
    required this.firebaseId,
    required this.deviceId,
    required this.loginType,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "userId": userEmailId,
      "otp": "391095",
      "browserDetails": {
        "browserName": "",
        "browserVersion": "",
        "userAgent": "",
        "platform": "android",
      },
      "ipAddress": "",
      "location": {
        "city": "",
        "region": "",
        "country": "",
        "postal": "",
        "latitude": 0,
        "longitude": 0,
      },
      "userType": loginType == "1" ? "internal" : "external",
    };
    return map;
  }
}

class LoginOTPScreenRequestModel {
  final String userId;
  final String otp;
  final String firebaseId;
  final String deviceId;
  final String loginType;

  LoginOTPScreenRequestModel({
    required this.userId,
    required this.otp,
    required this.firebaseId,
    required this.deviceId,
    required this.loginType,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "userId": int.parse(userId.toString()),
      "otp": otp,
      "browserDetails": {
        "browserName": "",
        "browserVersion": "",
        "userAgent": "",
        "platform": "android",
      },
      "ipAddress": "",
      "location": {
        "city": "",
        "region": "",
        "country": "",
        "postal": "",
        "latitude": 0,
        "longitude": 0,
      },
      "userType": loginType == "1" ? "internal" : "external",
    };
    return map;
  }
}
