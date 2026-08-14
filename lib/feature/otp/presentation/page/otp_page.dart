import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/otp/domain/domain/bloc/otp_bloc.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpPage extends StatefulWidget {
  final String emailId;
  final String password;
  const OtpPage({super.key, required this.emailId, required this.password});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {

  late List<TextStyle?> otpTextStyles;
  late List<TextEditingController?> controls;
  int numberOfFields = 6;
  Timer? _timer;

  @override
  void initState() {
    BlocProvider.of<OtpBloc>(context).add(OtpPageLoadEvent(context: context,
           email: widget.emailId, password: widget.password));
    startTimer();
    super.initState();
  }

  void startTimer() {
    int count = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(timer.tick < 30){
        BlocProvider.of<OtpBloc>(context).add(OtpUpdateTimeEvent(count: count - _timer!.tick));
      } else {
        _timer!.cancel();
        BlocProvider.of<OtpBloc>(context).add(const OtpUpdateTimeEvent(count: 0));
      }
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<OtpBloc, OtpState>(
        builder: (context, state) {
          if(state is FetchOtpDataState) {
            return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.08),
              child: _itemBuilder(dataState: state),
            );
          } else {
            return const Center(child: CenterLoaderWidget());
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchOtpDataState dataState}) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.06,
        right: MediaQuery.of(context).size.width * 0.06,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            _logo(),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.10,
            ),
            TextWidget(
              "Verification Code",
              fontSize: AppFont.font_12,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            TextWidget(
              "Enter the OTP received on your registered email Id",
              textAlign: TextAlign.center,
              fontSize: AppFont.font_14,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.08,
            ),
            OtpTextField(
              numberOfFields: numberOfFields,
              borderColor: EnvironmentConfig.of(context)!.primaryTheme,
              focusedBorderColor: EnvironmentConfig.of(context)!.primaryTheme,
              clearText: dataState.clearText,
              showFieldAsBox: true,
              textStyle: theme.textTheme.titleMedium,
              onCodeChanged: (String value) {
                List<String> value = [];
                for(var data in controls){
                  if(data!.text.toString().isNotEmpty){
                    value.add(data.text.toString());
                  }
                }
                String otp = value.toString().replaceAll("[", "").toString().replaceAll("]", "").replaceAll(",", "").replaceAll(" ", "");

                BlocProvider.of<OtpBloc>(context).add(
                    OtpValueEvent(otpValue: otp.toString()));
              },
              handleControllers: (controllers) {
                controls = controllers;
              },
              onSubmit: (String verificationCode) {},
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.08,
            ),

            dataState.isLoader == false ?
            dataState.isResendOtp == false ?
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    "Didn't get code?",
                    fontSize: AppFont.font_14,
                    fontWeight: FontWeight.w700,
                  ),
                  dataState.timer.isEmpty ?
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<OtpBloc>(context).add(OtpResendEvent(context: context));
                      if(_timer!.isActive == true){
                        _timer!.cancel();
                      }
                      startTimer();
                      BlocProvider.of<OtpBloc>(context).add(
                          const OtpValueEvent(otpValue: ""));
                    },
                    child: TextWidget(
                      "Re-send",
                      fontSize: AppFont.font_14,
                      color: EnvironmentConfig.of(context)!.primaryTheme,
                      textDecoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                    ),) : TextWidget(" Wait.. ${dataState.timer}", fontSize: AppFont.font_14)
                ],
              ),
            ) : const DottedLoaderWidget() : const SizedBox.shrink(),

            SizedBox(
              height: MediaQuery.of(context).size.width * 0.08,
            ),
            _submitButton(dataState: dataState),
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return Hero(
      tag: 'logo',
      child: Image.asset(
        AppIcon.logo(),
         height: 100,
      ),
    );
  }



  Widget _submitButton({required FetchOtpDataState dataState}) {
    return dataState.isResendOtp == false ?
    dataState.isLoader == false ?
    ButtonWidget(
        text: AppString.submit,
        onPressed: () {
          BlocProvider.of<OtpBloc>(context).add(OtpSubmitEvent(context: context));
        }
    ) : const DottedLoaderWidget() : const SizedBox.shrink();
  }
}
