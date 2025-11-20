import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/home/presentation/widget/home_drawer_widget.dart';
import 'package:flutter_gail/feature/login/presentations/Widgets/header_widget.dart';
import 'package:flutter_gail/services/app_control_helper.dart';
import 'package:flutter_gail/services/app_lifecycle_channel.dart';
import 'package:flutter_gail/services/background_location_service.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';
import 'package:flutter_gail/utils/commonWidgets/message_box_two_button_pop.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final double _headerHeight = 150;
  bool isAssignTask = false;

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(HomePageLoadEvent(context: context));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        final backNavigationAllowed = await _onWillPop();
        if (backNavigationAllowed) {
          SystemNavigator.pop();
        } else {
          // User is still on the same page, do whatever you want
        }
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          key: scaffoldKey,
          drawer: HomeDrawerWidget(),
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
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is FetchHomeDataState) {
                      return TextWidget(
                        "${state.title}\nApp Version : ${state.appVersion}",
                        fontSize: AppFont.font_16,
                        color: AppColor.white,
                        fontWeight: FontWeight.w700,
                      );
                    }
                    return TextWidget(
                      "Patrolling",
                      fontSize: AppFont.font_16,
                      color: AppColor.white,
                      fontWeight: FontWeight.w700,
                    );
                  },
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
            ],
          )),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (BuildContext mContext) => MessageBoxTwoButtonPopWidget(
                message: "Do you want to exit an App?",
                okButtonText: "Exit",
                onPressed: () => Navigator.of(context).pop(true)))) ??
        false;
  }
}
