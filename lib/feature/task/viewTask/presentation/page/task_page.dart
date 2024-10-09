import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/map/presentation/page/map_page.dart';
import 'package:flutter_gail/feature/task/addCrossing/domain/bloc/add_crossing_bloc.dart';
import 'package:flutter_gail/feature/task/addMarker/domain/bloc/add_marker_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/presentation/widget/tab_item.dart';
import 'package:flutter_gail/feature/task/viewTask/presentation/widget/task_item_box_widget.dart';
import 'package:flutter_gail/utils/commonClass/fade_route.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> with SingleTickerProviderStateMixin  {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    BlocProvider.of<TaskBloc>(context)
        .add(TaskPageLoadEvent(context: context));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if(state is FetchTaskDataState) {
           return _tabView(dataState: state);
        } else {
          return _loader();
        }
      },
    );
  }

  Widget _loader() {
    return const Center(child: CenterLoaderWidget(),);
  }

  Widget _tabView({required FetchTaskDataState dataState}) {
    return Column(
      children: [
        Container(
          color: Colors.grey[200],
          height: 40,
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator:  BoxDecoration(
              color: AppColor.themeColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black54,
            tabs:  [
              TabItem(title: 'Pending', count: dataState.searchTaskList.where((taskData) => taskData.patrollManStatus.toString() == "0").toList().length),
              TabItem(title: 'Ongoing', count: dataState.searchTaskList.where((taskData) => taskData.patrollManStatus.toString() != "0"
                  && taskData.patrollManStatus.toString() != "2").toList().length),
              TabItem(title: 'Completed', count: dataState.searchTaskList.where((taskData) => taskData.patrollManStatus.toString() == "2").toList().length),
            ],
            onTap: (index) {
              BlocProvider.of<TaskBloc>(context)
                  .add(TaskTabIndexEvent(tabIndex: index));
            },
          ),),
        // tab bar view here
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children:  [
              _itemWidget(dataState: dataState),
              _itemWidget(dataState: dataState),
              _itemWidget(dataState: dataState),
            ],
          ),
        ),
      ],
    );
  }

  Widget _itemWidget({required FetchTaskDataState dataState}) {
    return dataState.taskList.isNotEmpty ?
    ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: dataState.taskList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
       return InkWell(
           onTap: () {
             if(dataState.taskList[index].patrollManStatus.toString() != "2"){
               BlocProvider.of<TaskBloc>(context).add(TaskPageSelectDataEvent(index: index));
               Navigator.push(
                 !context.mounted ? context : context,
                 FadeRoute(
                     page: const MapPage()),
               );
             }
           },
           child: TaskItemBoxWidget(taskData: dataState.taskList[index]));
    }) : Center(child: TextWidget("No Data", color: AppColor.black,),);
  }

}
