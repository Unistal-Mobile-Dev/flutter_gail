import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

class AppBarWidget extends StatelessWidget {
  final String titleName;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AppBarWidget({super.key, required this.titleName, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      width: MediaQuery.of(context).size.width / 1.05,
      height: MediaQuery.of(context).size.width * 0.13,
      child: Card(
        elevation: 2,
        color: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  scaffoldKey!.currentState!.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: AppColor.grey,
                )),
            Expanded(
              child: TextWidget(
                titleName,
                textAlign: TextAlign.center,
                color: AppColor.themeColor,
                fontWeight: FontWeight.w600,
                fontSize: AppFont.font_16,
              ),
            ),
            IconButton(
                onPressed: () {
/*              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NotificationPage()));*/
                },
                icon: Icon(
                  Icons.notifications_none_sharp,
                  color: AppColor.grey,
                )),
          ],
        ),
      ),
    );
  }
}
