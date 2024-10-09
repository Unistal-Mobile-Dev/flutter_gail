import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/viewTask/presentation/page/task_page.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';

class PhoneDashboardWidget extends StatefulWidget {
  const PhoneDashboardWidget({
    super.key,
  });

  @override
  State<PhoneDashboardWidget> createState() => _PhoneDashboardWidgetState();
}

class _PhoneDashboardWidgetState extends State<PhoneDashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is FetchHomeDataState) {
        return _listBuilder(dataState: state);
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _listBuilder({required FetchHomeDataState dataState}) {
    LoginDataModel userData = UserInfo.instanceInit()!.userData!;
    return const TaskPage();
  }
}
