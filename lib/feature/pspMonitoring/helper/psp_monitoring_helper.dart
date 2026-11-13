import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/domain/model/cp_option_model.dart';
import 'package:flutter_gail/feature/pspMonitoring/domain/interface/psp_monitoring_interface.dart';
import 'package:flutter_gail/feature/pspMonitoring/domain/model/psp_field_model.dart';

class PspMonitoringHelper implements PspMonitoringInterface {

  @override
  Future<List<CpOptionModel>> fetchRegions() async {
    return _fetchOptions(url: APIs.getRegionsApi);
  }

  @override
  Future<List<CpOptionModel>> fetchMaintenanceBases({required CpOptionModel regionData}) async {
    return _fetchOptions(url: "${APIs.pspMonitoringOptionsApi}?region_id=${regionData.id}");
  }

  @override
  Future<List<CpOptionModel>> fetchPipelines({required CpOptionModel maintenanceBaseData}) async {
    return _fetchOptions(url: "${APIs.pspMonitoringOptionsApi}?maintenancebase_id=${maintenanceBaseData.id}");
  }

  @override
  Future<List<CpOptionModel>> fetchSections({required CpOptionModel pipelineData}) async {
    return _fetchOptions(url: "${APIs.pspMonitoringOptionsApi}?pipeline_id=${pipelineData.id}");
  }

  @override
  Future<List<CpOptionModel>> fetchTlpNumbers({required CpOptionModel sectionData}) async {
    return _fetchOptions(url: "${APIs.pspMonitoringOptionsApi}?section_id=${sectionData.id}");
  }

  @override
  Future<Map<String, dynamic>?> fetchTlpDetails({required CpOptionModel tlpNumberData}) async {
    try {
      var res = await ServerRequest.getData(
          urlEndPoint: "${APIs.pspMonitoringOptionsApi}?tag_id=${tlpNumberData.id}");
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
      debugPrint("TLP details error: $e");
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
      String url = "${APIs.pspMonitoringTaskApi}?region_id=${regionData.id}"
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
  Future<List<PspFieldModel>> fetchFields({
    required String tlpType,
    required String additionalTlpConnection,
  }) async {
    try {
      var res = await ServerRequest.getData(
          urlEndPoint: "${APIs.pspMonitoringFieldsApi}?tlp_type=${Uri.encodeQueryComponent(tlpType)}"
              "&add_tlp_conn=${Uri.encodeQueryComponent(additionalTlpConnection)}");
      if (res is List || res is Map) {
        return pspFieldListResponse(res);
      }
    } catch (e) {
      debugPrint("Fields error: $e");
    }
    return [];
  }

  @override
  Future<dynamic> submit({required BuildContext context, required Map<String, dynamic> body}) async {
    try {
      // store API takes form-data
      var res = await ServerRequest.postDataWithFile(
        urlEndPoint: APIs.pspMonitoringSubmitApi,
        body: body.map((key, value) => MapEntry(key, value?.toString() ?? "")),
        context: context,
      );
      // Response: {"success": true, "message": "...", "pspm_id": "3"}
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
    required CpOptionModel taskData,
    required CpOptionModel tlpNumberData,
    required CpOptionModel tlpTypeData,
    required TextEditingController dateOfReadingController,
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
    } else if (taskData.id == null) {
      message = "Task not found for the selected Section, Year and Month";
    } else if (tlpNumberData.id == null) {
      message = "Please select TLP No";
    } else if (tlpTypeData.id == null) {
      message = "Please select Type Of TLP";
    } else if (dateOfReadingController.text.trim().isEmpty) {
      message = "Please select Date of Reading";
    }

    if (message != null) {
      SnackBarErrorWidget(context).show(message: message);
      return false;
    }
    return true;
  }

  /// Reading fields must be numbers (server: "must contain only numbers").
  /// Empty values are allowed. Returns false and shows the message for the first wrong field.
  static bool numberFieldValidation({
    required BuildContext context,
    required Map<String, TextEditingController> fields,
  }) {
    final number = RegExp(r'^[-+]?\d*\.?\d+$');
    for (final entry in fields.entries) {
      final value = entry.value.text.trim();
      if (value.isNotEmpty && !number.hasMatch(value)) {
        SnackBarErrorWidget(context).show(message: "${entry.key} must contain only numbers");
        return false;
      }
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
