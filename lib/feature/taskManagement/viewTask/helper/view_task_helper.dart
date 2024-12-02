import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_data_model.dart';

class ViewTaskHelper {

  static Future<dynamic> fetchTaskData({required DateTime dateTime}) async
  {
    List<TaskDataModel> taskDataList = [];
    try{
      var beginningNextMonth = (dateTime.month < 12)
          ? DateTime(dateTime.year, dateTime.month + 1, 1)
          : DateTime(dateTime.year + 1, 1, 1);
      var lastDay = beginningNextMonth.subtract(const Duration(days: 1)).day;
      DateTime firstDayDate =  DateTime(dateTime.year, dateTime.month, 1);
/*      for(int i = 0; i < firstDayDate.weekday-1; i++)
      {
        taskDataList.add(TaskDataModel(
          id: "0",
          day: 0,
          dayName: "",
        ));
      }*/
      for(int i = 0; i < lastDay; i++)
      {
        DateTime weekDays =  DateTime(dateTime.year, dateTime.month, 1+i);
        int day = 1+i;
        taskDataList.add(TaskDataModel(
          id: day,
          day: day,
          date: weekDays.toString(),
          weekday: weekDays.weekday,
          dayName: getDays(weekDays.weekday),
          monthName: getMonth(weekDays.month),
        ));
      }
      return taskDataList;
    }catch(_){}
    return taskDataList;
  }

   static String getDays(int day) {
       switch(day)
       {
         case 1:
           return "Mon";
         case 2:
           return "Tue";
         case 3:
           return "Wed";
         case 4:
           return "Thu";
         case 5:
           return "Fri";
         case 6:
           return "Sat";
         case 7:
           return "Sun";
         default :
           return "";
       }
  }

  static String getMonth(int month) {
    switch(month)
    {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default :
        return "";
    }
  }
}