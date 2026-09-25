import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/maintenance_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/pipeline_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/region_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/section_model.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/model/tlp_connection_model.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/model/tlp_number_model.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/model/tlp_task_model.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/model/tlp_task_period_model.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/model/tlp_type_model.dart';

class AddTLPSurveyHelper {
  static Future<dynamic> fetchArea() async {
    try {
      String url = APIs.areaStructureApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['regionData'] != null) {
        return regionTypeListResponse(res['regionData']);
      }
    } catch (_) {}
    return null;
  }

  static Future<dynamic> fetchMaintenance(
      {required RegionTypeModel regionData}) async {
    try {
      String url = APIs.areaStructureApi + "?region_code=${regionData.code}";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['maintBaseData'] != null) {
        return maintenanceTypeListResponse(res['maintBaseData']);
      }
    } catch (_) {}
    return null;
  }

  static Future<dynamic> fetchPipeline(
      {required RegionTypeModel regionData,
      required MaintenanceTypeModel maintenanceTypeData}) async {
    try {
      String url = APIs.areaStructureApi +
          "?region_code=${regionData.code}"
              "&maintenance_base_code=${maintenanceTypeData.code}";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['pipelineData'] != null) {
        return pipelineLIstResponse(res['pipelineData']);
      }
    } catch (_) {}
    return null;
  }

  static Future<dynamic> fetchSection(
      {required RegionTypeModel regionData,
      required MaintenanceTypeModel maintenanceTypeData,
      required PipelineModel pipelineData}) async {
    try {
      String url = APIs.areaStructureApi +
          "?region_code=${regionData.code}"
              "&maintenance_base_code=${maintenanceTypeData.code}&pipeline_code=${pipelineData.code}";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['sectionData'] != null) {
        return sectionListResponse(res['sectionData']);
      }
    } catch (_) {}
    return null;
  }

  static Future<dynamic> fetchTaskData(
      {required String startDate,
      required String endDate,
      required SectionModel sectionData}) async {
    try {
      String url = APIs.getTlpTaskApi +
          "?startDate=$startDate&endDate=$endDate&code=PSP001&assetGroup=52&sectionCode=${sectionData.code}";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null) {
        return tlpTaskListResponse(res);
      }
    } catch (_) {}
    return null;
  }

  static Future<bool> textFieldValidation({
    required BuildContext context,
    required RegionTypeModel regionData,
    required MaintenanceTypeModel maintenanceBaseData,
    required PipelineModel pipelineData,
    required SectionModel sectionData,
    required TlpTaskPeriodModel tlpTaskPeriodData,
    required TlpNumberModel tlpNumberData,
    required TlpTypeModel tlpTypeData,
    required TlpConnectionModel tlpConnectionData,
    required TextEditingController pspOnController,
    required TextEditingController pspOffController,
    required TextEditingController casingPspOnController,
    required TextEditingController casingPspOffController,
    required TextEditingController casingIntegrityController,
    required TextEditingController foreignPspOnController,
    required TextEditingController foreignPspOffController,
    required TextEditingController acPspVoltController,
    required TextEditingController ijOnController,
    required TextEditingController ijOffController,
    required TextEditingController ijIntegrityController,
    required TextEditingController surgeDiverterConditionController,
    required TextEditingController acCurrentDischargeController,
    required TextEditingController couponOnController,
    required TextEditingController couponOffController,
    required TextEditingController calibrationController,
    required TextEditingController mvAcrossTerminalController,
    required TextEditingController testStationCurrentController,
    required TextEditingController cellConditionController,
    required TextEditingController groundingResistanceController,
    required TextEditingController dateOfReadingController,
    required TextEditingController remarksController,
    required String allowedTLPType,
    required String allowedTLPCondition,
  }) async {
    try {
      if (regionData.code == null) {
        SnackBarErrorWidget(context).show(message: "Please select region");
        return false;
      }
      if (maintenanceBaseData.code == null) {
        SnackBarErrorWidget(context).show(message: "Please select maintenance base");
        return false;
      }
      if (pipelineData.code == null) {
        SnackBarErrorWidget(context).show(message: "Please select pipeline");
        return false;
      }
      if (sectionData.code == null) {
        SnackBarErrorWidget(context).show(message: "Please select section");
        return false;
      }
      if (tlpTaskPeriodData.name == null) {
        SnackBarErrorWidget(context).show(message: "Please select task period");
        return false;
      }
      if (tlpNumberData.assetId == null) {
        SnackBarErrorWidget(context).show(message: "Please select TLP number");
        return false;
      }
      if (tlpTypeData.name == null) {
        SnackBarErrorWidget(context).show(message: "Please select TLP type");
        return false;
      }
      if (tlpConnectionData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select TLP connection");
        return false;
      }
      if (pspOnController.text.trim().isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter PSP ON value");
        return false;
      }
      if (pspOffController.text.trim().isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter PSP OFF value");
        return false;
      }
      if (dateOfReadingController.text.trim().isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter Date of Reading");
        return false;
      }
      if (["C", "D"].contains(allowedTLPType) || ["C", "D"].contains(allowedTLPCondition)) {
        if (casingPspOnController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter Casing PSP ON value");
          return false;
        }
        if (casingPspOffController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter Casing PSP OFF value");
          return false;
        }
      }
      if (["C", "D", "F", "I"].contains(allowedTLPType) || ["C", "D", "F", "I"].contains(allowedTLPCondition)) {
        if (casingIntegrityController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter Casing Integrity");
          return false;
        }
      }
      if (["A", "C", "D", "I"].contains(allowedTLPType) || ["A", "C", "D", "I"].contains(allowedTLPCondition)) {
        if (foreignPspOnController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter Foreign PSP ON");
          return false;
        }
        if (foreignPspOffController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter Foreign PSP OFF");
          return false;
        }
      }
      if (acPspVoltController.text.trim().isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter AC PSP Voltage");
        return false;
      }
      if (["K", "P"].contains(allowedTLPType) || ["K", "P"].contains(allowedTLPCondition)) {
        if (ijOnController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter IJ ON value");
          return false;
        }
        if (ijOffController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter IJ OFF value");
          return false;
        }
        if (ijIntegrityController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter IJ Integrity");
          return false;
        }
        if (surgeDiverterConditionController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter Surge Diverter Condition");
          return false;
        }
        if (acCurrentDischargeController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter AC Current Discharge (Amps)");
          return false;
        }
      }
      if (["K"].contains(allowedTLPType) || ["K"].contains(allowedTLPCondition)) {
        if (couponOnController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter Coupon ON value");
          return false;
        }
        if (couponOffController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter Coupon OFF value");
          return false;
        }
      }
      if (["B"].contains(allowedTLPType) || ["B"].contains(allowedTLPCondition)) {
        if (calibrationController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter Calibration value");
          return false;
        }
        if (mvAcrossTerminalController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter mV Across Terminal");
          return false;
        }
        if (testStationCurrentController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter Test Station Current");
          return false;
        }
      }
      // if (cellConditionController.text.trim().isEmpty) {
      //   SnackBarErrorWidget(context).show(message: "Please enter Cell Condition");
      //   return false;
      // }
      if (["H"].contains(allowedTLPType) || ["H"].contains(allowedTLPCondition)) {
        if (groundingResistanceController.text.trim().isEmpty) {
          SnackBarErrorWidget(context).show(message: "Please enter Grounding Resistance");
          return false;
        }
      }
    } catch (_) {
      SnackBarErrorWidget(context).show(message: "Validation error occurred");
      return false;
    }
    return true;
  }

  static Future<dynamic> submit({
    required BuildContext context,
    required RegionTypeModel regionData,
    required MaintenanceTypeModel maintenanceBaseData,
    required PipelineModel pipelineData,
    required SectionModel sectionData,
    required TlpTaskPeriodModel tlpTaskPeriodData,
    required TlpNumberModel tlpNumberData,
    required TlpTypeModel tlpTypeData,
    required TlpConnectionModel tlpConnectionData,
    required TextEditingController pspOnController,
    required TextEditingController pspOffController,
    required TextEditingController casingPspOnController,
    required TextEditingController casingPspOffController,
    required TextEditingController casingIntegrityController,
    required TextEditingController foreignPspOnController,
    required TextEditingController foreignPspOffController,
    required TextEditingController acPspVoltController,
    required TextEditingController ijOnController,
    required TextEditingController ijOffController,
    required TextEditingController ijIntegrityController,
    required TextEditingController surgeDiverterConditionController,
    required TextEditingController acCurrentDischargeController,
    required TextEditingController couponOnController,
    required TextEditingController couponOffController,
    required TextEditingController calibrationController,
    required TextEditingController mvAcrossTerminalController,
    required TextEditingController testStationCurrentController,
    required TextEditingController cellConditionController,
    required TextEditingController groundingResistanceController,
    required TextEditingController dateOfReadingController,
    required TextEditingController remarksController,
    required TextEditingController taskIdController,
    required String allowedTLPType,
    required String allowedTLPCondition,
    required TextEditingController dcInterferenceController,
    required TextEditingController acceptableAcPspVoltController,
    required TextEditingController soilResistivityController,
    required TextEditingController couponDcCurrentDensityController,
    required TextEditingController couponAcCurrentDensityController,
    required TextEditingController remarks2Controller,
  }) async {
    try {
        String url =  APIs.addTlpApi;
        var json = [{
          "region": "${regionData.code}",
          "pipeline": "${pipelineData.code}",
          "section": "${sectionData.code}",
          "taskId": taskIdController.text.trim(),
          "tlpNo": "${tlpNumberData.assetId}",
          "typeOfTlp": "${tlpTypeData.name}",
          "addTlpConn": "${tlpConnectionData.name}",
          "locationDetails": "${tlpNumberData.locationDescription}",
          "chainage": "${tlpNumberData.engm}",
          "pspReadingOn": pspOnController.text.trim(),
          "pspReadingOff": pspOffController.text.trim(),
          "pspCasingOn": casingPspOnController.text.trim(),
          "pspCasingOff": casingPspOffController.text.trim(),
          "integrityCasingCarrierPipe": casingIntegrityController.text.trim(),
          "pspForeignPipelineOn": foreignPspOnController.text.trim(),
          "pspForeignPipelineOff": foreignPspOffController.text.trim(),
          "acPsp": acPspVoltController.text.trim(),
          "ijReadingOn": ijOnController.text.trim(),
          "ijReadingOff": ijOffController.text.trim(),
          "integrityIj": ijIntegrityController.text.trim(),
          "conditionSurgeDiverter": surgeDiverterConditionController.text.trim(),
          "pspPolarisationCouponOn": couponOnController.text.trim(),
          "pspPolarisationCouponOff": couponOffController.text.trim(),
          "calibrationSpan": calibrationController.text.trim(),
          "mvAcrossTerminals": mvAcrossTerminalController.text.trim(),
          "currentFromTestStation": testStationCurrentController.text.trim(),
          "physicalCondition": cellConditionController.text.trim(),
          "groundingResistance": groundingResistanceController.text.trim(),
          "acCurrentDischarge": acCurrentDischargeController.text.trim(),
          "dateOfReading": dateOfReadingController.text.trim(),
          "remarks": remarksController.text.trim(),
          "fromDate_toDate": "${DateTime.now()}",

          // ✅ NEW parameters
          "maintbaseCode": "${maintenanceBaseData.code}",
          "acceptableAcPsp": acceptableAcPspVoltController.text.trim(),
          "soilResistivity": soilResistivityController.text.trim(),
          "couponsDcCurrentDensity": couponDcCurrentDensityController.text.trim(),
          "couponsAcCurrentDensity": couponAcCurrentDensityController.text.trim(),
          "dcInterference": dcInterferenceController.text.trim(),
          "remarks2": remarks2Controller.text.trim(),
        }];
        var res  =  await ServerRequest.postData(urlEndPoint: url, body: jsonEncode(json), context: context);
        if(res != null && res['message'] != null) {
          SnackBarSuccessWidget(!context.mounted ? context : context).show(message: res['message'].toString());
          return res;
        }
    } catch (e) {
      SnackBarErrorWidget(!context.mounted ? context : context).show(message: e.toString());
    }
    return null;
  }
}
