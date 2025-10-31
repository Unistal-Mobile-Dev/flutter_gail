import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/map/domain/model/hive_location_model.dart';
import 'package:flutter_gail/root.dart';
import 'package:flutter_gail/services/background_location_service.dart';
import 'package:flutter_gail/services/firebase/notification_service.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Hive.registerAdapter(HiveLocationModelAdapter());
  // await Hive.openBox<HiveLocationModel>('location_box');
  await FirebaseService.instance.initializeService();

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
  }

  try {
    final backgroundManager = BackgroundManager();
    if(!await backgroundManager.isRunning()){
      backgroundManager.initializeService();
    }
    BackgroundManager.isServiceRunning.addListener(() {
      debugPrint(
        "Service State Changed → ${BackgroundManager.isServiceRunning.value ? 'RUNNING' : 'STOPPED'}",
      );
    });
  }catch(e){}

  var apiKey = const String.fromEnvironment('API_KEY');
  if (apiKey.isEmpty) {
    throw Exception('apiKey undefined');
  } else {
    ArcGISEnvironment.apiKey = apiKey;
  }

  var configuredApp = const EnvironmentConfig(
      flavours: EnvironmentFlavours.productionIglCng,
      child: Root(
        client: Client.gail,
      ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(configuredApp);
}
