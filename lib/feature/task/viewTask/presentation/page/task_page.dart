import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/map/domain/bloc/map_bloc.dart';
import 'package:flutter_gail/feature/map/presentation/page/map_page.dart';
import 'package:flutter_gail/feature/task/createTask/presentation/page/create_task_page.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/feature/task/viewTask/presentation/widget/tab_item.dart';
import 'package:flutter_gail/feature/task/viewTask/presentation/widget/task_item_box_widget.dart';
import 'package:flutter_gail/utils/commonClass/fade_route.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class TaskPage extends StatefulWidget {
  final bool isAssignTask;

  const TaskPage({
    super.key,
    required this.isAssignTask,
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    BlocProvider.of<TaskBloc>(context).add(TaskPageLoadEvent(context: context));

    super.initState();
  }

  bool get _canCreateTask {
    final groups = UserInfo.instanceInit()?.userData?.groups ?? [];
    if (groups.isEmpty) return false;

    final isOnlyLineWalker = groups.length == 1 &&
        (groups.first.groupId == 16 ||
            groups.first.groupName?.toLowerCase() == 'line walker');

    return !isOnlyLineWalker;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is FetchTaskDataState) {
          return _tabView(dataState: state);
        } else {
          return _loader();
        }
      },
    );
  }

  Widget _loader() {
    return const Center(child: CenterLoaderWidget());
  }

  Widget _tabView({required FetchTaskDataState dataState}) {

    return Stack(
      children: [
        Column(
          children: [
            Container(
              color: Colors.grey[200],
              height: 40,
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: EnvironmentConfig.of(context)!.primaryTheme,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  TabItem(
                    title: AppString.assigned,
                    count:
                        dataState.searchTaskList
                            .where(
                              (taskData) =>
                                  taskData.taskStatus == TaskStatus.notStarted,
                            )
                            .toList()
                            .length,
                  ),
                  TabItem(
                    title: AppString.onGoing,
                    count:
                        dataState.searchTaskList
                            .where(
                              (taskData) =>
                                  taskData.taskStatus == TaskStatus.started ||
                                  taskData.taskStatus == TaskStatus.pause,
                            )
                            .toList()
                            .length,
                  ),
                  TabItem(
                    title: AppString.completed,
                    count:
                        dataState.searchTaskList
                            .where(
                              (taskData) =>
                                  taskData.taskStatus == TaskStatus.completed,
                            )
                            .toList()
                            .length,
                  ),
                ],
                onTap: (index) {
                  BlocProvider.of<TaskBloc>(
                    context,
                  ).add(TaskTabIndexEvent(tabIndex: index));
                },
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  _itemWidget(dataState: dataState),
                  _itemWidget(dataState: dataState),
                  _itemWidget(dataState: dataState),
                ],
              ),
            ),
          ],
        ),
        if (widget.isAssignTask && _canCreateTask)
          Positioned(bottom: 20, right: 20, child: _addFloatingButton()),
      ],
    );
  }

  Widget _itemWidget({required FetchTaskDataState dataState}) {
    return dataState.taskList.isNotEmpty
        ? RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: dataState.taskList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (dataState.taskList[index].taskStatus !=
                      TaskStatus.completed) {
                    BlocProvider.of<TaskBloc>(
                      context,
                    ).add(TaskPageSelectDataEvent(index: index));
                    BlocProvider.of<MapBloc>(
                      context,
                    ).add(MapPageLoadEvent(context: context));
                    Navigator.push(
                      !context.mounted ? context : context,
                      FadeRoute(page: const MapPage()),
                    );
                  }
                },
                child: TaskItemBoxWidget(taskData: dataState.taskList[index]),
              );
            },
          ),
        )
        : Center(child: TextWidget("No Data", color: AppColor.black));
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    BlocProvider.of<TaskBloc>(!context.mounted ? context : context).add(
      TaskPagRefreshDataEvent(context: !context.mounted ? context : context),
    );
  }

  Widget _addFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          !context.mounted ? context : context,
          FadeRoute(page: const CreateTaskPage()),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
