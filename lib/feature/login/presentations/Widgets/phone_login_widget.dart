import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/login/domain/bloc/login_event.dart';
import 'package:flutter_gail/feature/login/domain/bloc/login_state.dart';
import 'package:flutter_gail/feature/login/presentations/Widgets/header_widget.dart';
import 'package:flutter_gail/feature/task/createTask/domain/bloc/create_task_bloc.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true, Icons.person),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.08,
                  left: 0.0,
                  right: 0.0,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.28,
                    child: _logo(context),
                  )),
            ],
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: TextWidget(
                 AppIcon.loginTitle(),
                fontSize: AppFont.font_22,
                fontWeight: FontWeight.w800,
                color: EnvironmentConfig.of(context)!.primaryTheme,
              ),
            ),
            _verticalSpace(),
            _verticalSpace(),
           /* _loginTypeWidget(context: context, loginType: dataState.loginType),
            _verticalSpace(),*/

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
                BlocProvider.of<LoginBloc>(context).add(
                    LoginPasswordHideShowEvent(
                        isPassword:
                            dataState.isPassword == true ? false : true));
              },
            ),
            _verticalSpace(),
            _verticalSpace(),
            dataState.isLoader == false
                ? ButtonWidget(
                    text: "Submit",
                    onPressed: () {
                      BlocProvider.of<LoginBloc>(context).add(
                          LoginSubmitDataEvent(
                              context: context, isLoginPage: true));
                    },
                  )
                : const DottedLoaderWidget(),
          ],
        ),
      ),
    );
  }

  Widget _loginTypeWidget(
      {required BuildContext context, required String loginType}) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            title: TextWidget(
              "Internal User",
              color: AppColor.black,
              fontSize: AppFont.font_12,
            ),
            value: "1",
            groupValue: loginType,
            onChanged: (value) {
              BlocProvider.of<LoginBloc>(context)
                  .add(SelectLoginTypeEvent(loginType: value.toString()));
            },
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            title: TextWidget(
              "External User",
              color: AppColor.black,
              fontSize: AppFont.font_12,
            ),
            value: "2",
            groupValue: loginType,
            onChanged: (value) {
              BlocProvider.of<LoginBloc>(context)
                  .add(SelectLoginTypeEvent(loginType: value.toString()));
            },
          ),
        ),
      ],
    );
  }

  Widget _logo(BuildContext context) {
    final logoWidth = MediaQuery.of(context).size.width * 0.28;

    return Hero(
      tag: 'logo',
      child: Image.asset(
        AppIcon.logo(),
        width: logoWidth,
        fit: BoxFit.contain,
      ),
    );
  }

  _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.07,
    );
  }
}
