import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DottedLoaderWidget extends StatelessWidget {
  final double? size;
  final Color? color;
  const DottedLoaderWidget({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    double loaderSize = AppConfig.getDeviceType(context: context) == DeviceType.phone
        ? size ?? MediaQuery.of(context).size.width * 0.12
        : MediaQuery.of(context).size.width * 0.05;
    return SpinKitThreeInOut(
      color: color ?? EnvironmentConfig.of(context)!.primaryTheme,
      size: loaderSize,
    );
  }
}
