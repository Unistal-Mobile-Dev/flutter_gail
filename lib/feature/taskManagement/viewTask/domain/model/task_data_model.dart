import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_model.dart';

class TaskDataModel {

  dynamic id;
  int? day;
  int? weekday;
  String? dayName;
  String? monthName;
  String? year;
  String? name;
  String? title;
  String? date;

  TaskDataModel({
   this.name,
   this.id,
   this.day,
   this.year,
   this.weekday,
   this.dayName,
   this.monthName,
   this.title,
   this.date,
});

}