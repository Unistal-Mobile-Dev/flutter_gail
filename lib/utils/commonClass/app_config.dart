import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  static AppConfig? instance;
  RoleType? roleType;
  Client? client;
  String? appVersion;
  LoginDataModel userData = LoginDataModel();
  GroupRoles groupRoles = GroupRoles();


  static AppConfig? instanceInit() {
    instance ??= AppConfig();
    return instance;
  }

  setClient({required Client client}) {
    this.client = client;
  }

  setUserInfo({required LoginDataModel newData}) {
    this.userData = newData;
  }

  setGroupRoles({required GroupRoles newVal}) {
    this.groupRoles = newVal;
  }

  Future<dynamic> getPackageInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      // String code = packageInfo.buildNumber;
      appVersion = version;
    } catch (e) {
      return null;
    }
  }

  static DeviceType getDeviceType({BuildContext? context}) {
    var isPortrait = true;
    if (context != null) {
      isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    }

  /*  final MediaQueryData data = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
       return data.size.shortestSide <= 600
        ? DeviceType.phone
        : DeviceType.tablet;*/

    return isPortrait == true ? DeviceType.phone : DeviceType.phone;
  }
}
