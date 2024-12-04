class TaskModel {

  dynamic id;
  String? date;
  int? month;
  List<Task>? list;

  TaskModel({
    this.id,
    this.date,
    this.list,
    this.month,
 });

}

class Task {
  String? name;
  String? date;

  Task({this.name, this.date});
}