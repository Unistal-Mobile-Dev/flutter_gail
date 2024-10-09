import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CenterLoaderWidget extends StatelessWidget {
  const CenterLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double size = AppConfig.getDeviceType(context: context) == DeviceType.phone
        ? MediaQuery.of(context).size.width * 0.10
        : MediaQuery.of(context).size.width * 0.05;
    return Center(
      child: SpinKitFadingCube(
        color: const Color(0xFFFFC107),
        size: size,
      ),
    );
  }
}
