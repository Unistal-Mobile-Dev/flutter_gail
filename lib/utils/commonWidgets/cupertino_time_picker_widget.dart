import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';
import 'package:vibration/vibration.dart';


class CupertinoTimePickerWidget extends StatelessWidget {
  final ValueChanged<Duration> onDateTimeChanged;
  final Duration initialDateTime;
  Duration? selectDateTime ;

  CupertinoTimePickerWidget({super.key,
    required this.onDateTimeChanged,
    required this.initialDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () {
              onDateTimeChanged.call( selectDateTime ??= initialDateTime);
              Navigator.pop(context);
            },
            child: TextWidget("Done",
              color: EnvironmentConfig.of(context)!.primaryTheme,
              fontWeight: FontWeight.w700,),
          ),
        ),
        Expanded(
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hms,
            initialTimerDuration: initialDateTime,
            onTimerDurationChanged: (Duration newDuration) {
              selectDateTime =  newDuration;
            },
          ),
        ),
      ],
    );
  }
}

