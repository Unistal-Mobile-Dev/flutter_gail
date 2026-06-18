import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/bloc/view_task_bloc.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_data_model.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class TaskMonthlyCalendarWidget extends StatelessWidget {
  final FetchViewTaskDataState dataState;
  const TaskMonthlyCalendarWidget({super.key,
    required this.dataState});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.23,
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
                  ? EnvironmentConfig.of(context)!.primaryTheme
                  : AppColor.white,
              child: InkWell(
                onTap:  () {
                  BlocProvider.of<ViewTaskBloc>(context)
                      .add(ViewTaskSelectedMonthEvent(
                      context: context, selectedIndex: index));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextWidget("${card.monthName}",
                            color: index == dataState.selectedDay
                                ? AppColor.white
                                : AppColor.black,
                            fontWeight: FontWeight.w700,),
                        ),
                        TextWidget("${card.year}",
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
