import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/home/presentation/widget/home_drawer_widget.dart';
import 'package:flutter_gail/feature/login/presentations/Widgets/header_widget.dart';
import 'package:flutter_gail/feature/task/createTask/presentation/page/create_task_page.dart';
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

  @override
  Widget build(BuildContext context) {
    LoginDataModel userData  =  UserInfo.instanceInit()!.userData!;
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: scaffoldKey,
        drawer: HomeDrawerWidget(),
        floatingActionButton: _addFloatingButton(),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      AppColor.themeLightColor,
                      AppColor.themeColor,
                    ])
              ),
          ),
          elevation: 0,
          title: Theme(data:  ThemeData().copyWith(
            brightness: Brightness.light,
          ), child: TextWidget("Task List",
            fontSize: AppFont.font_16,
            color: AppColor.white, fontWeight: FontWeight.w700,)),
          actions: [
            Image.asset(AppIcon.gailLogo,
              height:MediaQuery.of(context).size.width * 0.08,),
              SizedBox(width :MediaQuery.of(context).size.width * 0.03,),
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
                  ) : const SizedBox.shrink();
          } else {
            return const SizedBox.shrink();
          }
        }),
        body: Column(
          children: [
            SizedBox(
              height: _headerHeight,
              child:  HeaderWidget(_headerHeight, true, Icons.person),
            ),
            Expanded(
              child:
              BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
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
        ));
   }

   Widget _addFloatingButton() {
    return  FloatingActionButton(
      onPressed: () {
        Navigator.push(
          !context.mounted ? context : context,
          FadeRoute(
              page: const CreateTaskPage()),
        );
      },
      child: const Icon(Icons.add),
    );
   }
}
