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

  static get getTaskApi => "patrolling-surveillance/patrollman-task/taskList";

  static get addMarkerPointApi => "patrolling-surveillance/marker/add-marker";

  static get addCrossingPointApi =>
      "patrolling-surveillance/crossing/add-crossing";

  static get getIncidentTypeApi => "patrolling-surveillance/route-observer/incident-types";

  static get addIncidentDataApi =>
      "patrolling-surveillance/incident/add-incident";

  static get updateTaskApi =>
      "patrolling-surveillance/patrollman-task/update-task-status";

  static get createTaskValuesListApi =>
      "patrolling-surveillance/patrollman-task/task-form-details";

  static get areaStructureApi =>
      "common-apis/area-structure";

  static get getsupervisorUserApi =>
      "patrolling-surveillance/patrollman-task/supervisor-users";

  static get assignTaskApi =>
      "patrolling-surveillance/patrollman-task/assign-task";

  static get getDailyTaskTrackingApi =>
      "patrolling-surveillance/patrollman-task/taskList";

  static get createDailyTaskApi =>
      "patrolling-surveillance/daily-task-tracking/create";

  static get saveLocationDataApi =>
      "patrolling-surveillance/device-location/add-device-location";

  static get getMarkerApi => "patrolling-surveillance/marker/details";

  static get getMovingPointApi => "patrolling-surveillance/mis/covered-points";

  static get getRouteApi => "patrolling-surveillance/patrollman-route/gps-coordinates/";

  static get addRouteObserveApi => "patrolling-surveillance/route-observer/add-type";

  static get addDeviceApi => "patrolling-surveillance/device/add-user-device";

  static get getMarkerCrossingInidentTypePointsApi => "patrolling-surveillance/route-observer/point-details";

  static get getEncroachmentTypeApi => "encroachment/types";

  static get getConfigurationApi => "patrolling-surveillance/mis/configuration";

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

  static get pipelineQuery => "server/rest/services/gail_production/MobApp/MapServer/210052/query?";
  static get stationQuery => "server/rest/services/gail_production/MobApp/MapServer/910001/query?";
  static get stationObject => "server/rest/services/gail_production/MobApp/MapServer/910001";
  static get tlpQuery => "server/rest/services/gail_production/MobApp/MapServer/200052/query?";
  static get tlpObject => "server/rest/services/gail_production/MobApp/MapServer/200052";

  static get forgotPasswordApi => "";
}