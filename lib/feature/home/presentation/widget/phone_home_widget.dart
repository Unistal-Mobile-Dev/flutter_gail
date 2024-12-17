import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/home/presentation/widget/home_drawer_widget.dart';
import 'package:flutter_gail/feature/login/presentations/Widgets/header_widget.dart';
import 'package:flutter_gail/feature/task/createTask/presentation/page/create_task_page.dart';
import 'package:flutter_gail/feature/task/viewTask/domain/bloc/task_bloc.dart';
import 'package:flutter_gail/utils/commonClass/fade_route.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';
import 'package:flutter_gail/utils/commonWidgets/dotted_line_widget.dart';

class PhoneHomeWidget extends StatefulWidget {
  const PhoneHomeWidget({super.key});

  @override
  State<PhoneHomeWidget> createState() => _PhoneHomeWidgetState();
}

class _PhoneHomeWidgetState extends State<PhoneHomeWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final double _headerHeight = 150;
  bool isAssignTask =  false;

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    for(var moduleData in userData.modules!) {
      if(moduleData.permissionList != null && moduleData.moduleName.toString() == "pipeline_patrolling_suervielliance"){
        for(var permissionData in moduleData.permissionList!){
          if(permissionData.name.toString().toLowerCase() == "write"){
            isAssignTask =  permissionData.value ?? false;
          }
        }
      }
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: scaffoldKey,
        drawer: HomeDrawerWidget(),
        floatingActionButton: isAssignTask == true ? _addFloatingButton() : null,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  AppColor.themeLightColor,
                  AppColor.themeColor,
                ])),
          ),
          elevation: 0,
          title: Theme(
              data: ThemeData().copyWith(
                brightness: Brightness.light,
              ),
              child: TextWidget(
                "Task List",
                fontSize: AppFont.font_16,
                color: AppColor.white,
                fontWeight: FontWeight.w700,
              )),
          actions: [
            Image.asset(
              AppIcon.gailLogo,
              height: MediaQuery.of(context).size.width * 0.08,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
          ],
        ),
        bottomNavigationBar:
            BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is FetchHomeDataState) {
            return state.bottomNavigationBarItemList.isNotEmpty
                ? BottomNavigationBar(
                    currentIndex: state.bottomTabIndex,
                    onTap: (index) {
                      BlocProvider.of<HomeBloc>(context).add(
                          HomeChangeBottomNavigationItemEvent(
                              index: index, context: context));
                    },
                    items: state.bottomNavigationBarItemList,
                  )
                : const SizedBox.shrink();
          } else {
            return const SizedBox.shrink();
          }
        }),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: _headerHeight,
                  child: HeaderWidget(_headerHeight, true, Icons.person),
                ),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                    if (state is FetchHomeDataState) {
                      return state.childWidget;
                    } else {
                      return const Center(
                        child: CenterLoaderWidget(),
                      );
                    }
                  }),
                ),
              ],
            ),
            _filterWidget(context: context),
          ],
        ));
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

  Widget _filterWidget({required BuildContext context}) {
    return Positioned(
        right: 10,
        top: 90,
        child: IconButton(
            onPressed: () {
              BlocProvider.of<TaskBloc>(context)
                  .add(TaskPageSelectDateEvent(context: context));
            },
            icon: Icon(
              Icons.filter_alt_outlined,
              color: AppColor.white,
    )));
  }
}
