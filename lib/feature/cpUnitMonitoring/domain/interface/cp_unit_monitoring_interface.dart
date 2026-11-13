import 'package:flutter/material.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/domain/model/cp_option_model.dart';

abstract class CpUnitMonitoringInterface {
  Future<List<CpOptionModel>> fetchRegions();

  Future<List<CpOptionModel>> fetchMaintenanceBases({required CpOptionModel regionData});

  Future<List<CpOptionModel>> fetchPipelines({required CpOptionModel maintenanceBaseData});

  Future<List<CpOptionModel>> fetchSections({required CpOptionModel pipelineData});

  Future<List<CpOptionModel>> fetchRectifiers({required CpOptionModel sectionData});

  Future<Map<String, dynamic>?> fetchRectifierDetails({required CpOptionModel rectifierData});

  /// Task for the selected section/year/month: id = task_id, name = task name
  Future<CpOptionModel?> fetchTask({
    required CpOptionModel regionData,
    required CpOptionModel maintenanceBaseData,
    required CpOptionModel pipelineData,
    required CpOptionModel sectionData,
    required String year,
    required String month,
  });

  Future<dynamic> submit({required BuildContext context, required Map<String, dynamic> body});
}
