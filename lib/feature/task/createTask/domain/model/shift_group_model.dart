import 'package:flutter_gail/feature/task/createTask/domain/model/lineWalker_user_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/shift_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/user_name_model.dart';

class ShiftGroupModel {

  List<ShiftTypeModel>? shiftList;
  LineWalkerUsersModel? userNameData;
  String? selectedValue;
  bool? isSelected;

  ShiftGroupModel({
    this.shiftList,
    this.userNameData,
    this.selectedValue,
    this.isSelected,
 });

}