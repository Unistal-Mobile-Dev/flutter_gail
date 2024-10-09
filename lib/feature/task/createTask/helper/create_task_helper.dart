import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/line_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/shift_model.dart';

class CreateTaskHelper {

  static Future<dynamic> textFieldValidation({
    required BuildContext context,
    required LineModel lineData,
    required String startPatrollingDate,
    required String startPatrollingTime,
    required String endPatrollingDate,
    required String endPatrollingTime,
    required ShiftModel shiftData,
    required String taskDate,
  }) async {
     try{
        if(lineData.name == null){
          SnackBarErrorWidget(context).show(message: "Please select line name");
          return false;
        }
        else if(startPatrollingDate.isEmpty){
          SnackBarErrorWidget(context).show(message: "Please select start patrolling date");
          return false;
        }
        else if(startPatrollingTime.isEmpty){
          SnackBarErrorWidget(context).show(message: "Please select start patrolling time");
          return false;
        }
        else if(endPatrollingDate.isEmpty){
          SnackBarErrorWidget(context).show(message: "Please select end patrolling date");
          return false;
        }
        else if(endPatrollingTime.isEmpty){
          SnackBarErrorWidget(context).show(message: "Please select end patrolling time");
          return false;
        }
        else if(shiftData.name == null){
          SnackBarErrorWidget(context).show(message: "Please select shift name");
          return false;
        }
        else if(taskDate.isEmpty){
          SnackBarErrorWidget(context).show(message: "Please select task date");
          return false;
        }
        return true;
     }catch(_){
       return false;
     }
  }

  static Future<dynamic> fetchLineData() async {
    try{

    }catch(_){}
  }

  static Future<dynamic> fetchShiftData() async {
    try{

    }catch(_){}
  }

}