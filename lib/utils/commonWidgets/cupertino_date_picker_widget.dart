import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';
import 'package:vibration/vibration.dart';


class CupertinoDatePickerWidget extends StatelessWidget {
  final ValueChanged<DateTime> onDateTimeChanged;
  final DateTime initialDateTime;
  final DateTime? minimumDate;
  DateTime? selectDateTime ;

  CupertinoDatePickerWidget({super.key,
    required this.onDateTimeChanged,
    required this.initialDateTime,
    this.minimumDate
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
          child: CupertinoDatePicker(
            initialDateTime: initialDateTime,
            minimumDate: minimumDate,
            // maximumDate: DateTime.now(),
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            showDayOfWeek: true,
            onDateTimeChanged: (DateTime newDate) async {
              selectDateTime =  newDate;
              if (await Vibration.hasAmplitudeControl() != null) {
                Vibration.vibrate(duration: 5);
              }
              // final player = AudioPlayer();
              // player.play(AssetSource('chain_sound.mp3'));
            },
          ),
        ),
      ],
    );
  }
}

 showCupertinoDatePickerWidgetDialog({required Widget child, required BuildContext context}) {
  double size =  MediaQuery.of(context).size.height - MediaQuery.of(context).size.width;
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: size * 0.70,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: SafeArea(
        top: false,
        child: child,
      ),
    ),
  );
}
