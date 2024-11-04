import 'package:flutter_gail/feature/task/createTask/domain/model/shift_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/user_name_model.dart';

class ShiftGroupModel {

  List<ShiftTypeModel>? shiftList;
  UserNameModel? userNameData;
  String? selectedValue;

  ShiftGroupModel({
    this.shiftList,
    this.userNameData,
    this.selectedValue,
 });

}