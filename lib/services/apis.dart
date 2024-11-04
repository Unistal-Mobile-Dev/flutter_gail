import 'package:flutter/material.dart';
import 'package:flutter_gail/utils/commonClass/singleton.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class APIs {
  static BuildContext? context = Singleton.instance.context;

  static final String baseUrl =
      EnvironmentConfig.of(context!)!.generalUrlBaseOnFlavour;

  static get sendNotificationApi => "https://fcm.googleapis.com/fcm/send";

  static get googlePlaceAPI =>
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?";

  static get googlePlaceDetailsAPI =>
      "https://maps.googleapis.com/maps/api/place/details/json?";

  static get googleLatLongAPI =>
      "https://maps.googleapis.com/maps/api/geocode/json?";

  static get login => "auth/login";

  static get getTaskApi => "patrolling-surveillance/patrollman-task/taskList";

  static get addMarkerPointApi => "patrolling-surveillance/marker/add-marker";

  static get addCrossingPointApi => "patrolling-surveillance/crossing/add-crossing";

  static get getIncidentTypeApi => "patrolling-surveillance/incident/types";

  static get addIncidentDataApi => "patrolling-surveillance/incident/add-incident";

  static get updateTaskApi => "patrolling-surveillance/patrollman-task/update-task-status";

  static get createTaskValuesListApi => "patrolling-surveillance/patrollman-task/task-form-details";

  static get areaStructureApi => "patrolling-surveillance/patrollman-task/area-structure";

  static get assignTaskApi => "patrolling-surveillance/patrollman-task/assign-task";

  static get forgotPasswordApi => "";
}
