import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/services/firebase/notification_service.dart';
import 'package:flutter_gail/testing_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class Root extends StatefulWidget {
  final Client client;

  const Root({super.key, required this.client});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Singleton.instance.setContext(context);
    AppConfig.instanceInit()!.setClient(client: widget.client);
    return blocMultiProvider(
      child: MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Gail',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: '/',
      routes: {
        '/second': (context) => const TestPage(),
      },
      builder: (context, child) {
        return MediaQuery (
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
      home: const SplashScreen(),
        // home: const LoginScreenPage(),
    ));
  }
}