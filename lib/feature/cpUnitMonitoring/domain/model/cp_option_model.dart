/// Common model for all CP Unit Monitoring dropdowns
/// (Region, Maintenance Base, Pipeline, Section, Rectifier).
class CpOptionModel {
  String? id;
  String? code;
  String? name;
  Map<String, dynamic> data;

  CpOptionModel({this.id, this.code, this.name, this.data = const {}});

  static const List<String> _nameKeys = [
    "name",
    "region_name",
    "maintenancebase_name",
    "maintenance_base_name",
    "maint_base_name",
    "pipeline_name",
    "section_name",
    "tag_name",
    "tag_no",
    "rectifier_name",
    "asset_id",
  ];

  static const List<String> _idKeys = [
    "id",
    "region_id",
    "maintenancebase_id",
    "maintenance_base_id",
    "pipeline_id",
    "section_id",
    "tag_id",
  ];

  factory CpOptionModel.fromJson(Map<String, dynamic> json) {
    return CpOptionModel(
      id: _firstValue(json, _idKeys),
      code: _firstValue(json, ["code", "region_code", "maint_base_code", "pipeline_code", "section_code"]),
      name: _firstValue(json, _nameKeys) ?? _firstValueWhere(json, (key) => key.endsWith("_name")),
      data: json,
    );
  }

  /// Simple value list (Year, Month, Operating Mode...)
  factory CpOptionModel.value({required String id, required String name}) {
    return CpOptionModel(id: id, code: id, name: name);
  }

  static String? _firstValue(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().isNotEmpty) return value.toString();
    }
    return null;
  }

  static String? _firstValueWhere(Map<String, dynamic> json, bool Function(String key) test) {
    for (final entry in json.entries) {
      if (test(entry.key) && entry.value != null && entry.value.toString().isNotEmpty) {
        return entry.value.toString();
      }
    }
    return null;
  }
}

/// Reads the option list from an API response:
/// `{"data": [...]}`, `[...]` or the first list inside the response map.
List<CpOptionModel> cpOptionListResponse(dynamic json) {
  dynamic list = json;
  if (json is Map) {
    if (json['data'] is List) {
      list = json['data'];
    } else if (json['data'] is Map) {
      list = (json['data'] as Map).values.firstWhere((value) => value is List, orElse: () => []);
    } else {
      list = json.values.firstWhere((value) => value is List, orElse: () => []);
    }
  }
  if (list is! List) return [];
  return list
      .whereType<Map>()
      .map((item) => CpOptionModel.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}
