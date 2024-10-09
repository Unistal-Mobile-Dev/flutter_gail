import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/root.dart';
import 'package:flutter_gail/services/firebase/notification_service.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.instance.initializeService();
  // AppColor(themeColor: 0xFF1269AC, themeLightColor: 0xFF278AD7);
  var configuredApp = const EnvironmentConfig(
      flavours: EnvironmentFlavours.productionIglCng,
      child: Root(
        client: Client.gail,
      ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(configuredApp);
}
