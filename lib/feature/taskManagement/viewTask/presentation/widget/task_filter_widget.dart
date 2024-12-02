import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/bloc/view_task_bloc.dart';

class TaskFilterWidget extends StatelessWidget {
  final FetchViewTaskDataState dataState;
  const TaskFilterWidget({super.key,
  required this.dataState
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.13,
      child: ListView.builder(
          itemCount: dataState.taskFilterList.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
           return ButtonWidget(
               isSideBoard: dataState.taskFilterList[index].isSelected == true ? false : true,
               fontSize: AppFont.font_11,
               backgroundColor: dataState.taskFilterList[index].isSelected == true
                   ? AppColor.themeColor : AppColor.white,
               height: MediaQuery.of(context).size.width * 0.10,
               text: dataState.taskFilterList[index].name.toString(),
               onPressed: () {
                   BlocProvider.of<ViewTaskBloc>(context)
                   .add(ViewTaskSelectedFilterStatusEvent(context: context, selectedIndex: index));
                 }
               );
         }),
    );
  }
}
