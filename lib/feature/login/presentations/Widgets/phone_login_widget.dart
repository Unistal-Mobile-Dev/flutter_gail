import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/login/domain/bloc/login_event.dart';
import 'package:flutter_gail/feature/login/domain/bloc/login_state.dart';
import 'package:flutter_gail/feature/login/presentations/Widgets/header_widget.dart';

class PhoneLoginWidget extends StatefulWidget {
  final FetchLoginStateData dataState;

  const PhoneLoginWidget({super.key, required this.dataState});

  @override
  State<PhoneLoginWidget> createState() => _PhoneLoginWidgetState();
}

class _PhoneLoginWidgetState extends State<PhoneLoginWidget> {
  final double _headerHeight = 150;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: SizedBox(
            height: 190,
            child: Stack(
              children: [
                SizedBox(
                  height: _headerHeight,
                  child: HeaderWidget(_headerHeight, true, Icons.person),
                ),
                Positioned(
                    top: 70,
                    left: 0.0,
                    right: 0.0,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width * 0.28,
                      child: _logo(),
                    )),
              ],
            ),
          ),
        ),

        _itemBuilder(dataState: widget.dataState),
      ],
    );
  }

  Widget _itemBuilder({required FetchLoginStateData dataState}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: TextWidget(
              "Gail Login",
              fontSize: AppFont.font_22,
              fontWeight: FontWeight.w800,
              color: AppColor.themeColor,),
          ),
          _verticalSpace(),
          _verticalSpace(),
          TextFieldWidget(
             controller: dataState.userNameTextFiledController,
              isBoardRemove: false,
              labelText: AppString.userName,
            onChanged: (value) {
              BlocProvider.of<LoginBloc>(context)
                  .add(LoginSetEmailEvent(emailId: value));
            },
          ),
          _verticalSpace(),
          TextFieldPasswordWidget(
            textEditingController: dataState.passwordTextFieldController,
            isPasswordIcon: true,
            obscureText: dataState.isPassword,
            isBoardRemove: false,
            labelText: AppString.password,
            onChanged: (value) {
              BlocProvider.of<LoginBloc>(context)
                  .add(LoginSetPasswordEvent(password: value));
            },
            passwordOnPressed: () {
              BlocProvider.of<LoginBloc>(context)
                  .add(LoginPasswordHideShowEvent(isPassword: dataState.isPassword == true ? false : true));
            },
          ),
          _verticalSpace(),
          _verticalSpace(),
          dataState.isLoader == false ?
          ButtonWidget(
            text: "Submit",
            onPressed: () {
              BlocProvider.of<LoginBloc>(context)
                  .add(LoginSubmitDataEvent(context: context, isLoginPage: true));
            },
          ) : const DottedLoaderWidget(),
        ],
      ),
    );
  }

  Widget _logo() {
    return Hero(
      tag: 'logo',
      child: Image.asset(
        AppConfig.instanceInit()!.client == Client.gail
            ? AppIcon.gailLogo
            : AppIcon.gailLogo,
      ),
    );
  }


  _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.07,
    );
  }
}
