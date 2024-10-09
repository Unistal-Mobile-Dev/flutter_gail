import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/commonClass/user_info.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({super.key});

  final LoginDataModel _userData = UserInfo.instance!.userData!;

  LoginDataModel get userData => _userData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: AppColor.themeColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.height * 0.09,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColor.themeLightColor,
                ),
              ),
              child: Icon(
                Icons.perm_identity,
                color: AppColor.grey,
                size: MediaQuery.of(context).size.height * 0.05,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    userData.name.toString(),
                    color: AppColor.black,
                    fontSize: AppFont.font_15,
                    fontWeight: FontWeight.w700,
                  ),
                  TextWidget(
                    userData.email.toString(),
                    color: AppColor.grey,
                    fontSize: AppFont.font_13,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
