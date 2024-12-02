import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/bloc/view_task_bloc.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_data_model.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/presentation/widget/task_filter_widget.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/presentation/widget/task_list_day_widget.dart';

class ViewTaskPage extends StatefulWidget {
  const ViewTaskPage({super.key});

  @override
  State<ViewTaskPage> createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage> {

  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.10);
    BlocProvider.of<ViewTaskBloc>(context)
        .add(ViewTaskPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
    _pageController = PageController(viewportFraction: 0.2);
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.25,
          child: PageView.builder(
              itemCount: dataState.taskDataList.length,
              scrollDirection: Axis.horizontal,
              controller: _pageController,
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
                        _pageController.animateToPage(index, duration: const Duration(
                          milliseconds: 250,
                        ), curve: Curves.easeInOutBack);
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
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TaskFilterWidget(dataState: dataState),
        ),

        Expanded(
         child: Padding(
           padding: const EdgeInsets.all(8.0),
           child: TaskListDayWidget(
             dataState: dataState,
             taskList: [],
           ),
         )
        )
      ],
    );
  }
}
