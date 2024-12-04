import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/bloc/view_task_bloc.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_data_model.dart';

class TaskDayCalendarWidget extends StatelessWidget {
  final FetchViewTaskDataState dataState;
  const TaskDayCalendarWidget({super.key,
    required this.dataState});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.25,
      child: PageView.builder(
        itemCount: dataState.taskDataList.length,
        scrollDirection: Axis.horizontal,
        controller: dataState.pageController,
        itemBuilder: (context, index) {
          TaskDataModel card =  dataState.taskDataList[index];
          return card.id.toString() != "0" ?
          SizedBox(
            width: MediaQuery.of(context).size.width/2,
            child: Card(
              elevation: 2,
              shadowColor: Colors.black,
              color: index == dataState.selectedDay
                  ? AppColor.themeColor
                  : AppColor.white,
              child: InkWell(
                onTap:  () {
                  BlocProvider.of<ViewTaskBloc>(context)
                      .add(ViewTaskSelectedDayEvent(
                      context: context, selectedIndex: index));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget("${card.monthName}",
                          color: index == dataState.selectedDay
                              ? AppColor.white
                              : AppColor.black,
                          fontSize: AppFont.font_11,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextWidget("${card.day}",
                            color: index == dataState.selectedDay
                                ? AppColor.white
                                : AppColor.black,
                            fontWeight: FontWeight.w700,),
                        ),
                        TextWidget("${card.dayName}",
                          color: index == dataState.selectedDay
                              ? AppColor.white
                              : AppColor.black,
                          fontSize: AppFont.font_11,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ): const SizedBox.shrink();
        },
      ),
    );
  }
}
