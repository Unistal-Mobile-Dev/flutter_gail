import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class DateRangeWidget {
  static Future<DateTimeRange?> showDateRange(
      {required DateTime startDate,
      required DateTime endDate,
      required BuildContext context}) async {
    final picked = await showDateRangePicker(
      context: context,
      saveText: "Done",
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: EnvironmentConfig.of(context)!.primaryTheme),
            //.dialogBackgroundColor:Colors.blue[900],
          ),
          child: child!,
        );
      },
    );
    return picked;
  }
}
