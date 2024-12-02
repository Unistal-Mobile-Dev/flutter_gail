import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_model.dart';

class TaskDataModel {

  dynamic id;
  int? day;
  int? weekday;
  String? dayName;
  String? monthName;
  String? name;
  String? title;
  String? date;
  List<TaskModel>? taskList;

  TaskDataModel({
   this.name,
   this.id,
   this.day,
   this.weekday,
   this.dayName,
   this.monthName,
   this.title,
   this.date,
   this.taskList,
});

}