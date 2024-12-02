import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/model/task_model.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/bloc/view_task_bloc.dart';

class TaskListDayWidget extends StatelessWidget {
  final FetchViewTaskDataState dataState;
  final List<TaskModel> taskList;
  const TaskListDayWidget({super.key,
  required this.dataState,
  required this.taskList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 6,
        shrinkWrap: true,
        itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          shadowColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextWidget("HRM Mitra Task Management", color: AppColor.grey,
                  fontSize: AppFont.font_11,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                TextWidget("Create Task Page With Api", color: AppColor.black,
                 fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.watch_later, color: AppColor.themeColor,
                      size:  MediaQuery.of(context).size.width * 0.05,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Expanded(
                      child: TextWidget("${DateTime.now()}", color: AppColor.grey,
                        fontSize: AppFont.font_11,
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color:  AppColor.themeColor,
                          border: Border.all(
                            color:  AppColor.themeColor,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: TextWidget("In Progress", color: AppColor.white,
                            fontSize: AppFont.font_10,
                          ),
                        ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
    });
  }
}
