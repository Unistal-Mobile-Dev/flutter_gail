import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

class InternetConnectivityPopWidget extends StatelessWidget {
  const InternetConnectivityPopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width / 1.7,
        margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              _closeButton(context: context),
              _centerImage(context: context),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _text(context: context),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _centerImage({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.09,
      child: Icon(
        Icons.signal_cellular_connected_no_internet_0_bar_sharp,
        size: MediaQuery.of(context).size.height * 0.09,
        color: AppColor.red,
      ),
    );
  }

  Widget _text({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: TextWidget(
        "No Internet Connection.",
        textAlign: TextAlign.center,
        color: AppColor.black,
        fontWeight: FontWeight.w500,
        fontSize: AppFont.font_12,
      ),
    );
  }

  Widget _closeButton({required BuildContext context}) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: Icon(
          Icons.close,
          color: AppColor.grey,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
