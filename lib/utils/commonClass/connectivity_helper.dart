import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gail/utils/commonWidgets/gps_setting_permission_pop_widget.dart';
import 'package:flutter_gail/utils/commonWidgets/internet_connectivity_pop_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class ConnectivityHelper {
  static Future<dynamic> checkGPSPermission(
      {required BuildContext context}) async {
    try {
      bool isLocationEnable = await Geolocator.isLocationServiceEnabled();
      if (isLocationEnable == false) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services')));
        return false;
      }
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
          return false;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> checkPermissions({required BuildContext context}) async {
    await [
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse
    ].request();

    if (Platform.isAndroid) {
      final status = await Permission.locationAlways.status;
      if (status == PermissionStatus.denied) {
        if (!context.mounted) return false;
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                const GPSSettingPermissionPopWidget());
        return false;
      }
      if (status == PermissionStatus.permanentlyDenied) {
        if (!context.mounted) return false;
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                const GPSSettingPermissionPopWidget());
        return false;
      }
    } else if (Platform.isIOS) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        if (!context.mounted) return false;
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                const GPSSettingPermissionPopWidget());
        return false;
      }
    }
    return true;
  }

  static Future<dynamic> allConnectivityCheck(
      {required BuildContext context}) async {
    bool isConnected = await checkInterNetConnect();
    if (isConnected == false) {
      if (!context.mounted) return false;
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              const InternetConnectivityPopWidget());
      return false;
    }
    return true;
  }

  static Future<bool> checkInterNetConnect() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }
}
