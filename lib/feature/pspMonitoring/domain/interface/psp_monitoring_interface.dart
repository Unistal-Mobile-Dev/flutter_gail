import 'package:flutter/material.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/domain/model/cp_option_model.dart';
import 'package:flutter_gail/feature/pspMonitoring/domain/model/psp_field_model.dart';

abstract class PspMonitoringInterface {
  Future<List<CpOptionModel>> fetchRegions();

  Future<List<CpOptionModel>> fetchMaintenanceBases({required CpOptionModel regionData});

  Future<List<CpOptionModel>> fetchPipelines({required CpOptionModel maintenanceBaseData});

  Future<List<CpOptionModel>> fetchSections({required CpOptionModel pipelineData});

  /// TLP No list of the section
  Future<List<CpOptionModel>> fetchTlpNumbers({required CpOptionModel sectionData});

  /// Chainage / Location Details of the TLP
  Future<Map<String, dynamic>?> fetchTlpDetails({required CpOptionModel tlpNumberData});

  /// Task for the selected section/year/month: id = task_id, name = task name
  Future<CpOptionModel?> fetchTask({
    required CpOptionModel regionData,
    required CpOptionModel maintenanceBaseData,
    required CpOptionModel pipelineData,
    required CpOptionModel sectionData,
    required String year,
    required String month,
  });

  /// Dynamic reading fields for Type Of TLP + Additional TLP Connection
  Future<List<PspFieldModel>> fetchFields({required String tlpType, required String additionalTlpConnection});

  Future<dynamic> submit({required BuildContext context, required Map<String, dynamic> body});
}
