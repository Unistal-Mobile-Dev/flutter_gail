import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/login/domain/bloc/login_event.dart';
import 'package:flutter_gail/feature/login/domain/bloc/login_state.dart';

class TabletLoginWidget extends StatefulWidget {
  final FetchLoginStateData dataState;

  const TabletLoginWidget({super.key, required this.dataState});

  @override
  State<TabletLoginWidget> createState() => _TabletLoginWidgetState();
}

class _TabletLoginWidgetState extends State<TabletLoginWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
    );
  }

  _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.04,
    );
  }
}
