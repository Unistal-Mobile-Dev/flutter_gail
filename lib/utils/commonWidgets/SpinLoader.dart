import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class SpinLoader extends StatelessWidget {
  const SpinLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitCubeGrid(color: AppColor.themeColor);
  }
}
