import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/domain/interface/cp_unit_monitoring_interface.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/domain/model/cp_option_model.dart';

class CpUnitMonitoringHelper implements CpUnitMonitoringInterface {

  @override
  Future<List<CpOptionModel>> fetchRegions() async {
    return _fetchOptions(url: APIs.getRegionsApi);
  }

  @override
  Future<List<CpOptionModel>> fetchMaintenanceBases({required CpOptionModel regionData}) async {
    return _fetchOptions(url: "${APIs.cpUnitMonitoringOptionsApi}?region_id=${regionData.id}");
  }

  @override
  Future<List<CpOptionModel>> fetchPipelines({required CpOptionModel maintenanceBaseData}) async {
    return _fetchOptions(url: "${APIs.cpUnitMonitoringOptionsApi}?maintenancebase_id=${maintenanceBaseData.id}");
  }

  @override
  Future<List<CpOptionModel>> fetchSections({required CpOptionModel pipelineData}) async {
    return _fetchOptions(url: "${APIs.cpUnitMonitoringOptionsApi}?pipeline_id=${pipelineData.id}");
  }

  @override
  Future<List<CpOptionModel>> fetchRectifiers({required CpOptionModel sectionData}) async {
    return _fetchOptions(url: "${APIs.cpUnitMonitoringOptionsApi}?section_id=${sectionData.id}");
  }

  @override
  Future<Map<String, dynamic>?> fetchRectifierDetails({required CpOptionModel rectifierData}) async {
    try {
      var res = await ServerRequest.getData(
          urlEndPoint: "${APIs.cpUnitMonitoringOptionsApi}?tag_id=${rectifierData.id}");
      if (res is Map) {
        // Response: {"device": {"chainage": "0", "location_detail": null, ...}}
        final data = res['device'] ?? res['data'];
        if (data is Map) return Map<String, dynamic>.from(data);
        if (data is List && data.isNotEmpty && data.first is Map) {
          return Map<String, dynamic>.from(data.first);
        }
        return Map<String, dynamic>.from(res);
      }
    } catch (e) {
      debugPrint("Rectifier details error: $e");
    }
    return null;
  }

  @override
  Future<CpOptionModel?> fetchTask({
    required CpOptionModel regionData,
    required CpOptionModel maintenanceBaseData,
    required CpOptionModel pipelineData,
    required CpOptionModel sectionData,
    required String year,
    required String month,
  }) async {
    try {
      String url = "${APIs.cpUnitMonitoringTaskApi}?region_id=${regionData.id}"
          "&maintenancebase_id=${maintenanceBaseData.id}"
          "&pipeline_id=${pipelineData.id}"
          "&section_id=${sectionData.id}"
          "&year=$year&month=$month";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res is Map) {
        dynamic data = res['task'] ?? res['data'] ?? res;
        if (data is List && data.isNotEmpty) data = data.first;
        if (data is Map) {
          final taskId = data['task_id'] ?? data['taskId'] ?? data['id'];
          if (taskId == null || taskId.toString().isEmpty) return null;
          final taskName = data['task_name'] ?? data['taskName'] ?? data['name'] ?? data['title'];
          return CpOptionModel(
            id: taskId.toString(),
            name: taskName != null && taskName.toString().isNotEmpty
                ? taskName.toString()
                : taskId.toString(),
            data: Map<String, dynamic>.from(data),
          );
        } else if (data != null && data.toString().isNotEmpty) {
          return CpOptionModel(id: data.toString(), name: data.toString());
        }
      }
    } catch (e) {
      debugPrint("Task error: $e");
    }
    return null;
  }

  @override
  Future<dynamic> submit({required BuildContext context, required Map<String, dynamic> body}) async {
    try {
      // store API takes form-data
      var res = await ServerRequest.postDataWithFile(
        urlEndPoint: APIs.cpUnitMonitoringSubmitApi,
        body: body.map((key, value) => MapEntry(key, value?.toString() ?? "")),
        context: context,
      );
      if (res is Map && res['success'] != false && res['status'] != false) {
        if (context.mounted) {
          SnackBarSuccessWidget(context).show(
              message: res['message']?.toString() ?? "Inspection submitted successfully");
        }
        return res;
      }
      if (res is Map && res['message'] != null && context.mounted) {
        SnackBarErrorWidget(context).show(message: ServerRequest.responseMessage(res));
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarErrorWidget(context).show(message: e.toString());
      }
    }
    return null;
  }

  /// Required field check. Returns false and shows the message if anything is missing.
  static bool textFieldValidation({
    required BuildContext context,
    required CpOptionModel regionData,
    required CpOptionModel maintenanceBaseData,
    required CpOptionModel pipelineData,
    required CpOptionModel sectionData,
    required CpOptionModel yearData,
    required CpOptionModel monthData,
    required TextEditingController taskIdController,
    required CpOptionModel rectifierData,
    required TextEditingController inspectionDateController,
  }) {
    String? message;
    if (regionData.id == null) {
      message = "Please select Region";
    } else if (maintenanceBaseData.id == null) {
      message = "Please select Maintenance Base";
    } else if (pipelineData.id == null) {
      message = "Please select Pipeline";
    } else if (sectionData.id == null) {
      message = "Please select Section";
    } else if (yearData.id == null) {
      message = "Please select Year";
    } else if (monthData.id == null) {
      message = "Please select Month";
    } else if (taskIdController.text.trim().isEmpty) {
      message = "Task not found for the selected Section, Year and Month";
    } else if (rectifierData.id == null) {
      message = "Please select Rectifier";
    } else if (inspectionDateController.text.trim().isEmpty) {
      message = "Please select Inspection Date";
    }

    if (message != null) {
      SnackBarErrorWidget(context).show(message: message);
      return false;
    }
    return true;
  }

  Future<List<CpOptionModel>> _fetchOptions({required String url}) async {
    try {
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res is Map || res is List) {
        return cpOptionListResponse(res);
      }
    } catch (e) {
      debugPrint("Options error ($url): $e");
    }
    return [];
  }
}
