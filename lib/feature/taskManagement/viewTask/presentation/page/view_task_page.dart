import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/bloc/view_task_bloc.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_data_model.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/presentation/widget/task_day_calendar_widget.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/presentation/widget/task_filter_widget.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/presentation/widget/task_list_day_widget.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/presentation/widget/task_monthly_calendar_widget.dart';

class ViewTaskPage extends StatefulWidget {
  const ViewTaskPage({super.key});

  @override
  State<ViewTaskPage> createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage> {

  @override
  void initState() {
    BlocProvider.of<ViewTaskBloc>(context)
        .add(ViewTaskPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget("Task View", color: AppColor.white,),
        actions: [
          IconButton(onPressed: () {

          }, icon: Icon(Icons.add, color: AppColor.white,)),
        ],
      ),
      body: BlocBuilder<ViewTaskBloc, ViewTaskState>(
        builder: (context, state) {
          if(state is FetchViewTaskDataState)
          {
            return _itemBuilder(dataState: state);
          }
          else
          {
            return Container();
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchViewTaskDataState dataState})
  {
    return Column(
      children: [
        _calendarTypeDropDown(dataState: dataState),
        dataState.taskView == TaskView.days
            ? TaskDayCalendarWidget(dataState: dataState)
            : TaskMonthlyCalendarWidget(dataState: dataState),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TaskFilterWidget(dataState: dataState),
        ),
        Expanded(
         child: Padding(
           padding: const EdgeInsets.all(8.0), // TaskListDayWidget(dataState: dataState)
           child: ListView.builder(
               itemCount: dataState.taskList.length,
               shrinkWrap: true,
               itemBuilder: (context, index) {
               return dataState.taskList[index].list!.isNotEmpty ?
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   TextWidget(dataState.taskList[index].date.toString().replaceAll("00:00:00.000", ""),
                    color: AppColor.themeColor,
                    fontWeight: FontWeight.w700,
                   ),
                   TaskListDayWidget(
                     dataState: dataState,
                     taskList: dataState.taskList[index].list!
                   ),
                   SizedBox(
                     height: MediaQuery.of(context).size.width * 0.03,
                   ),
                 ],
               ) : const SizedBox.shrink();
           }),
         ))
      ],
    );
  }

  Widget _calendarTypeDropDown({required FetchViewTaskDataState dataState}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width/2.8,
          child: DropdownWidget(
            isRequired: false,
            isBoardRemoved: true,
            hint: "",
            dropdownValue: dataState.taskView == TaskView.days ? "Days"
                : dataState.taskView == TaskView.monthly ? "Monthly" : null,
            onChanged: (value) {
              BlocProvider.of<ViewTaskBloc>(context).add(ViewTaskSelectCalendarTypeEvent(context: context,
                  taskView: value.toString() == "Days"
                      ? TaskView.days
                      : TaskView.monthly));
            },
            items: ["Days", "Monthly"].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: TextWidget(value.toString()),
              );
            }).toList(),
          ),
        ),

        IconButton(
            onPressed: () {
              BlocProvider.of<ViewTaskBloc>(context)
                  .add(ViewTaskPageSelectDateEvent(context: context));
        }, icon: Icon(Icons.calendar_month, color: AppColor.themeColor,)),

      ],
    );
  }
}
