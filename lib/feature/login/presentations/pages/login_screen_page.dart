import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/login/presentations/Widgets/phone_login_widget.dart';
import 'package:flutter_gail/feature/login/presentations/Widgets/tablet_login_widget.dart';

import '../../domain/bloc/login_event.dart';
import '../../domain/bloc/login_state.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  @override
  void initState() {
    BlocProvider.of<LoginBloc>(context).add(LoginPageLoadingEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColor.appBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    AppColor.themeLightColor,
                    AppColor.themeColor,
                  ])
          ),
        ),
        elevation: 0,
        title: Theme(data:  theme.copyWith(
          brightness: Brightness.light,
        ), child: const SizedBox.shrink()),
      ),
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is FetchLoginStateData) {
            return Center(
              child: AppConfig.getDeviceType(context: context) == DeviceType.phone
                      ? PhoneLoginWidget(dataState: state)
                      : TabletLoginWidget(
                          dataState: state,
                        ),
            );
          } else {
            return const Center(
              child: CenterLoaderWidget(),
            );
          }
        },
      ),
    );
  }
}
