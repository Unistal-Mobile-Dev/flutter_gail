import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/root.dart';
import 'package:flutter_gail/services/firebase/notification_service.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.instance.initializeService();

  var apiKey = const String.fromEnvironment('API_KEY');
  if (apiKey.isEmpty) {
    throw Exception('apiKey undefined');
  } else {
    ArcGISEnvironment.apiKey = apiKey;
  }

  var configuredApp = const EnvironmentConfig(
      flavours: EnvironmentFlavours.developmentIglCng,
      child: Root(
        client: Client.gail,
      ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(configuredApp);
}
