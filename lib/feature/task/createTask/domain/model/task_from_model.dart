import 'package:flutter_gail/feature/task/createTask/domain/model/route_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/shift_group_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/shift_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/user_name_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/user_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/vendor_model.dart';


TaskFromModel taskFromListResponse(var json) {
  return TaskFromModel.fromJson(json);
}


class TaskFromModel {
  List<ShiftTypeModel> shiftList;
  List<UserNameModel> userNameList;
  List<UserTypeModel> userTypeList;
  List<RouteModel> routeList;
  List<VendorModel> vendorList;

  TaskFromModel({
   required this.userNameList,
   required this.userTypeList,
   required this.vendorList,
   required this.routeList,
   required this.shiftList,
});

  factory TaskFromModel.fromJson(Map<String, dynamic> json) {
    return TaskFromModel(
        userNameList: json['userData'] !=  null ? List<UserNameModel>.from(json['userData'].map((x) => UserNameModel.fromJson(x))) : [],
        vendorList: json['vendorData'] !=  null ? List<VendorModel>.from(json['vendorData'].map((x) => VendorModel.fromJson(x))) : [],
        userTypeList: json['userType'] !=  null ? List<UserTypeModel>.from(json['userType'].map((x) => UserTypeModel.fromJson(x))) : [],
        routeList: json['routeData'] !=  null ? List<RouteModel>.from(json['routeData'].map((x) => RouteModel.fromJson(x))) : [],
      shiftList: json['shiftData'] !=  null ? List<ShiftTypeModel>.from(json['shiftData'].map((x) => ShiftTypeModel.fromJson(x))) : [],
    );
  }
}