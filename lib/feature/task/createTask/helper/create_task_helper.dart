import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/maintenance_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/pipeline_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/region_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/repeat_frequency_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/route_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/section_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/shift_group_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/shift_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/task_from_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/user_name_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/user_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/vendor_model.dart';

class CreateTaskHelper {

  static Future<dynamic> fetchRepeatFrequency() async {
    try{
       List<RepeatFrequencyModel> repeatFrequencyList = [];
/*       repeatFrequencyList.add(RepeatFrequencyModel(
          id: "0",
          name: "Every Day"
       ));*/
       repeatFrequencyList.add(RepeatFrequencyModel(
           id: "1",
           name: "Monday"
       ));
       repeatFrequencyList.add(RepeatFrequencyModel(
           id: "2",
           name: "Tuesday"
       ));
       repeatFrequencyList.add(RepeatFrequencyModel(
           id: "3",
           name: "Wednesday"
       ));
       repeatFrequencyList.add(RepeatFrequencyModel(
           id: "4",
           name: "Thursday"
       ));
       repeatFrequencyList.add(RepeatFrequencyModel(
           id: "5",
           name: "Friday"
       ));
       repeatFrequencyList.add(RepeatFrequencyModel(
           id: "6",
           name: "Saturday"
       ));
       repeatFrequencyList.add(RepeatFrequencyModel(
           id: "7",
           name: "Sunday"
       ));
       return repeatFrequencyList;
    }catch(_){}
    return null;
  }

  static Future<dynamic> fetchArea() async {
    try{
      String url =  APIs.areaStructureApi;
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['regionData'] != null){
        return regionTypeListResponse(res['regionData']);
      }
    }catch(_){}
    return null;
  }

  static Future<dynamic> fetchMaintenance({required RegionTypeModel regionData}) async {
    try{
      String url =  APIs.areaStructureApi+"?regionCode=${regionData.code}";
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['maintBaseData'] != null){
        return maintenanceTypeListResponse(res['maintBaseData']);
      }
    }catch(_){}
    return null;
  }

  static Future<dynamic> fetchPipeline({
    required RegionTypeModel regionData,
    required MaintenanceTypeModel maintenanceTypeData
  }) async {
    try{
      String url =  APIs.areaStructureApi+"?regionCode=${regionData.code}"
          "&maint_base_name=${maintenanceTypeData.name}";
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['pipelineData'] != null){
        return pipelineLIstResponse(res['pipelineData']);
      }
    }catch(_){}
    return null;
  }

  static Future<dynamic> fetchSection({
    required RegionTypeModel regionData,
    required MaintenanceTypeModel maintenanceTypeData,
    required PipelineModel pipelineData
  }) async {
    try{
      String url =  APIs.areaStructureApi+"?regionCode=${regionData.code}"
          "&maint_base_name=${maintenanceTypeData.name}&pipeline_code=${pipelineData.code}";
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['sectionData'] != null){
        return sectionListResponse(res['sectionData']);
      }
    }catch(_){}
    return null;
  }

  static Future<dynamic> fetchRoute({
    required SectionModel sectionData,
  }) async {
    try{
      String url =  APIs.createTaskValuesListApi+"?section=${sectionData.name}";
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['routeData'] != null){
        return routeListResponse(res['routeData']);
      }
    }catch(_){}
    return null;
  }

  static Future<TaskFromModel> fetchTaskDropDownValuesList() async {

    try{
      String url =  APIs.createTaskValuesListApi;
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null){
        return taskFromListResponse(res);
      }
    }catch(_){}
    TaskFromModel data = TaskFromModel(
      userNameList: [],
      vendorList: [],
      userTypeList: [],
      shiftList: [],
      routeList: [],
    );
    return data;
  }

  static Future<dynamic> fetchVendor(
      {required UserTypeModel userTypeData}) async {
    try{

      String url =  APIs.createTaskValuesListApi+"?user_type=${userTypeData.name}";
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['vendorData'] != null){
        print(res['vendorData']);
        return vendorListResponse(res['vendorData']);
      }
    }catch(_){}
    return null;
  }

  static Future<dynamic> fetchUserName(
      {required UserTypeModel userTypeData,
       required VendorModel vendorData,
      }) async {

    try{
      String url =  APIs.createTaskValuesListApi+"?user_type=${userTypeData.name}"
          "&vendor_name=${vendorData.name}";
      var res =  await ServerRequest.getData(urlEndPoint: url);
      if(res != null && res['userData'] != null){
        return userNameListResponse(res['userData']);
      }
    }catch(_){}
    return null;
  }

  static Future<dynamic> textFieldValidationCheck(
       {required BuildContext context,
        required RegionTypeModel regionData,
        required MaintenanceTypeModel maintenanceData,
        required PipelineModel pipelineData,
        required SectionModel sectionData,
        required RouteModel routeModel,
        required String routeLength,
        required ShiftTypeModel shiftData,
        required List<ShiftGroupModel> shiftGroupList,
        required List<UserNameModel> userNameList,
        required UserTypeModel userTypeModel,
        required String assignedStartDate,
        required String assignedEndDate,
        required List<RepeatFrequencyModel> repeatFrequencyList,
        required VendorModel vendorData,
      }) async {
    try{

      if(regionData.name == null){
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please select region");
        return false;
      }
      else if(maintenanceData.name == null){
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please select maintenance base");
        return false;
      }
      else if(pipelineData.name == null){
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please select pipeline name");
        return false;
      }
      else if(sectionData.name == null){
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please select section name");
        return false;
      }
      else if(routeModel.name == null){
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please select patrol route name");
        return false;
      }
      else if(shiftData.name == null){
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please select shift group");
        return false;
      }
      else if(assignedStartDate.isEmpty){
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please enter patrolling start date");
        return false;
      }
      else if(assignedEndDate.isEmpty){
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please enter patrolling end date");
        return false;
      }
      else if(repeatFrequencyList.isEmpty){
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please select repeat frequency");
        return false;
      }
      else if(userTypeModel.name == null){
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please select user type");
        return false;
      }
      else if(vendorData.name == null){
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please select vendor name");
        return false;
      }
      else if(userNameList.isEmpty){
        SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please select user name");
        return false;
      }

      for(var data in shiftGroupList){
        if(data.selectedValue.toString().isEmpty){
          SnackBarErrorWidget(!context.mounted ? context : context).show(message: "Please select user shift");
          return false;
        }
      }
      return true;
    } catch (e) {
      SnackBarErrorWidget(!context.mounted ? context : context).show(message: e.toString());
      return true;
    }
  }

  static Future<dynamic> submitData(
      {required BuildContext context,
        required RegionTypeModel regionData,
        required MaintenanceTypeModel maintenanceData,
        required PipelineModel pipelineData,
        required SectionModel sectionData,
        required RouteModel routeModel,
        required String routeLength,
        required ShiftTypeModel shiftData,
        required List<ShiftGroupModel> shiftGroupList,
        required List<UserNameModel> userNameList,
        required UserTypeModel userTypeModel,
        required String assignedStartDate,
        required String assignedEndDate,
        required List<RepeatFrequencyModel> repeatFrequencyList,
        required VendorModel vendorData,
      }) async {

    try{

      List<String> repeatFrequencyData = [];
      for(var data in repeatFrequencyList){
        repeatFrequencyData.add(data.name.toString().toLowerCase());
      }

      List<String> userNameData = [];
      for(var data in userNameList){
        userNameData.add(data.name.toString());
      }

      List<String> userIdData = [];
      for(var data in userNameList){
        userIdData.add(data.securityId.toString());
      }

      List<String> siftData = [];
      for(var data in shiftGroupList){
        siftData.add(data.selectedValue.toString());
      }

      String url =  APIs.assignTaskApi;
      var json = {
        "region_name": regionData.name.toString(),
        "region_code": regionData.code.toString(),
        "maintenance_base": maintenanceData.name.toString(),
        "maintenance_base_code": maintenanceData.code.toString(),
        "pipeline_name": pipelineData.name.toString(),
        "pipeline_code": pipelineData.code.toString(),
        "section_name": sectionData.name.toString(),
        "section_code": sectionData.code.toString(),
        "patrollroute_id": routeModel.id.toString(),
        "patrollroute_name": routeModel.name.toString(),
        "patrollroute_length": routeLength.toString(),
        "sg_code": shiftData.sgCode.toString(),
        "assigned_start_date": assignedStartDate.toString(),
        "assigned_end_date": assignedEndDate.toString(),
        "repeat_frequency": repeatFrequencyData,
        "user_type": userTypeModel.name.toString(),
        "user_name": userNameData,
        "user_id": userIdData,
        "shift_name": siftData,
        "vendor": vendorData.name.toString(),
      };
      var res =  await ServerRequest.postData(urlEndPoint: url,
          body: jsonEncode(json), context: context);
        await ServerRequest.postData(urlEndPoint: APIs.createDailyTaskApi,
          body: jsonEncode(json), context: !context.mounted ? context : context);
      if(res != null && res['message'] != null){
        SnackBarSuccessWidget(!context.mounted ? context : context)
            .show(message: res['message'].toString());
        return res;
      }
      return null;
    } catch(e) {
      SnackBarErrorWidget(!context.mounted ? context : context).show(message: e.toString());
    }
    return null;
  }

}