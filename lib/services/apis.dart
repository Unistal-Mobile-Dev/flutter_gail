import 'package:flutter/material.dart';
import 'package:flutter_gail/utils/commonClass/singleton.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class APIs {
  static BuildContext? get context => Singleton.instance.context;

  static String get baseUrl {
    if (context == null) {
      debugPrint("⚠️ APIs.context is null — EnvironmentConfig not initialized yet.");
      return ""; // or a default URL
    }
    final env = EnvironmentConfig.of(context!);
    if (env == null) {
      debugPrint("⚠️ EnvironmentConfig.of(context) returned null.");
      return "";
    }
    final url = env.generalUrlBaseOnFlavour;
    debugPrint("🌐 Base URL: $url");
    return url;
  }

  static String get baseGailUrl {
    if (context == null) {
      return ""; // or a default URL
    }
    final env = EnvironmentConfig.of(context!);
    if (env == null) {
      return "";
    }
    final url = env.generalGailUrlBaseOnFlavour;
    return url;
  }

  static get sendNotificationApi => "https://fcm.googleapis.com/fcm/send";

  static get googleDirectionsApi =>
      "https://maps.googleapis.com/maps/api/directions/json";

  static get login => "auth/login";

  static get checkLogin => "auth/token-login";

  static get getTaskApi => "api/patrollman-task/taskList";

  static get addMarkerPointApi => "api/marker/add-marker";

  static get addCrossingPointApi =>
      "api/crossing/add-crossing";

  static get getIncidentTypeApi => "api/route-observer/incident-types";

  static get addIncidentDataApi =>
      "api/incident/add-incident";

  static get updateTaskApi =>
      "api/patrollman-task/update-task-status";

  static get createTaskValuesListApi =>
      "api/patrollman-task/task-form-details";

  static get areaStructureApi =>
      "common-apis/area-structure";

  static get getsupervisorUserApi =>
      "api/patrollman-task/supervisor-users";

  static get assignTaskApi =>
      "api/patrollman-task/assign-task";

  static get getDailyTaskTrackingApi =>
      "api/patrollman-task/taskList";

  static get createDailyTaskApi =>
      "api/daily-task-tracking/create";

  static get saveLocationDataApi =>
      "api/device-location/add-device-location";

  static get getMarkerApi => "api/marker/details";

  static get getMovingPointApi => "api/mis/covered-points";

  static get getRouteApi => "api/patrollman-route/gps-coordinates/";

  static get addRouteObserveApi => "api/route-observer/add-type";

  static get addDeviceApi => "api/device/add-user-device";

  static get getMarkerCrossingInidentTypePointsApi => "api/route-observer/point-details";

  static get getEncroachmentTypeApi => "encroachment/types";

  static get getConfigurationApi => "api/mis/configuration";

  static get getCategoryApi => "image-sharing/category";

  static get getSubCategoryApi => "image-sharing/sub-category";

  static get getPipelineApi => "common-apis/area-structure-sections-stations";

  static get saveImageSharingApi => "image-sharing/summary";

  static get summary => "dashboard/summary";
  static get pipelineSummary => "pipeline-master/summary/summary?";
  static get pipelineMaster => "pipeline-master/master-data/assetManagementValues?";

  static get getTlpTaskApi => "cp-system/short-interval/tasks";

  static get addTlpApi => "cp-system/short-interval/soil/create-tlp";

  static get generateOtpApi => "auth/2fa/generate-otp";

  static get verifyOtpApi => "auth/2fa/verify-otp";


  static get pipelineLayerUrl => "server/rest/services/UPIMS/MobileApp/MapServer";
  static get pipelineQuery => "server/rest/services/UPIMS/MobileApp/MapServer/210052/query?";
  static get stationQuery => "server/rest/services/UPIMS/MobileApp/MapServer/910001/query?";
  static get stationObject => "server/rest/services/UPIMS/MobileApp/MapServer/910001";
  static get tlpQuery => "server/rest/services/UPIMS/MobileApp/MapServer/200052/query?";
  static get tlpObject => "server/rest/services/UPIMS/MobileApp/MapServer/200052";

  static get forgotPasswordApi => "";
}