import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

class TabletDashboardWidget extends StatefulWidget {
  const TabletDashboardWidget({super.key});

  @override
  State<TabletDashboardWidget> createState() => _TabletDashboardWidgetState();
}

class _TabletDashboardWidgetState extends State<TabletDashboardWidget> {
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
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    Icons.comment_bank_outlined,
                    color: AppColor.themeColor,
                  ),
                  label: const TextWidget("Report Equipment Complaint"),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    Icons.report_gmailerrorred,
                    color: AppColor.themeColor,
                  ),
                  label: const TextWidget("Report Civil Complaint"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
