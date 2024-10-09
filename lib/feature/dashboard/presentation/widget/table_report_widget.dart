import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/presentation/widget/card_backgound.dart';

class TabletReportWidget extends StatelessWidget {
  const TabletReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double boxHeight = MediaQuery.of(context).size.height * 0.25;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: boxHeight,
                child: Card(
                  elevation: 3,
                  shadowColor: AppColor.themeLightColor,
                  color: AppColor.themeLightColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: CardBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextWidget(
                          "All Orders",
                          color: AppColor.white,
                          fontSize: AppFont.font_16,
                          fontWeight: FontWeight.w700,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: AppColor.white,
                              size: MediaQuery.of(context).size.height * 0.05,
                            ),
                            TextWidget(
                              "86",
                              color: AppColor.white,
                              fontSize: AppFont.font_22,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Expanded(
              child: SizedBox(
                height: boxHeight,
                child: Card(
                  elevation: 3,
                  shadowColor: AppColor.cardBlue,
                  color: AppColor.cardBlue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: CardBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextWidget(
                          "Daily average",
                          color: AppColor.white,
                          fontSize: AppFont.font_16,
                          fontWeight: FontWeight.w700,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.card_travel,
                              color: AppColor.white,
                              size: MediaQuery.of(context).size.height * 0.05,
                            ),
                            TextWidget(
                              "75",
                              color: AppColor.white,
                              fontSize: AppFont.font_22,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.01,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: boxHeight,
                child: Card(
                  elevation: 3,
                  shadowColor: AppColor.cardGreen,
                  color: AppColor.cardGreen,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: CardBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextWidget(
                          "Lead",
                          color: AppColor.white,
                          fontSize: AppFont.font_16,
                          fontWeight: FontWeight.w700,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.person,
                              color: AppColor.white,
                              size: MediaQuery.of(context).size.height * 0.05,
                            ),
                            TextWidget(
                              "45",
                              color: AppColor.white,
                              fontSize: AppFont.font_22,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Expanded(
              child: SizedBox(
                height: boxHeight,
                child: Card(
                  elevation: 3,
                  shadowColor: AppColor.cardLightGreen,
                  color: AppColor.cardLightGreen,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: CardBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextWidget(
                          "Annual Deals",
                          color: AppColor.white,
                          fontSize: AppFont.font_16,
                          fontWeight: FontWeight.w700,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: AppColor.white,
                              size: MediaQuery.of(context).size.height * 0.05,
                            ),
                            TextWidget(
                              "93",
                              color: AppColor.white,
                              fontSize: AppFont.font_22,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
