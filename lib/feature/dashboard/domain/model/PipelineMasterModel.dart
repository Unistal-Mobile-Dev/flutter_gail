

class DashboardStatusModel {
  final List<PipelineStatus> pipelineStatuses;
  final List<CpSystemStatus> cpSystemStatuses;

  DashboardStatusModel({
    required this.pipelineStatuses,
    required this.cpSystemStatuses,
  });

  factory DashboardStatusModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatusModel(
      pipelineStatuses: (json['pipelineStatuses'] as List)
          .map((e) => PipelineStatus.fromJson(e))
          .toList(),
      cpSystemStatuses: (json['cpSystemStatuses'] as List)
          .map((e) => CpSystemStatus.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pipelineStatuses': pipelineStatuses.map((e) => e.toJson()).toList(),
      'cpSystemStatuses': cpSystemStatuses.map((e) => e.toJson()).toList(),
    };
  }
}

class PipelineStatus {
  final String pipelineStatus;
  final int statusCount;

  PipelineStatus({
    required this.pipelineStatus,
    required this.statusCount,
  });

  factory PipelineStatus.fromJson(Map<String, dynamic> json) {
    return PipelineStatus(
      pipelineStatus: json['pipelineStatus'] ?? "",
      statusCount: json['StatusCount'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pipelineStatus': pipelineStatus,
      'StatusCount': statusCount,
    };
  }
}

class CpSystemStatus {
  final String pipelineStatus;
  final int statusCount;

  CpSystemStatus({
    required this.pipelineStatus,
    required this.statusCount,
  });

  factory CpSystemStatus.fromJson(Map<String, dynamic> json) {
    return CpSystemStatus(
      pipelineStatus: json['pipelineStatus'] ?? "",
      statusCount: json['StatusCount'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pipelineStatus': pipelineStatus,
      'StatusCount': statusCount,
    };
  }
}
