import 'package:flutter_gail/feature/cpUnitMonitoring/domain/model/cp_option_model.dart';

/// field_type from the `fields` API
class PspFieldType {
  static const String input = "1";
  static const String dropdown = "3";
}

/// One dynamic field of the PSP Monitoring form (depends on Type Of TLP
/// and Additional TLP Connection).
class PspFieldModel {
  String? id;
  String? tlpType;
  String name;
  String slug;
  String fieldType;
  List<CpOptionModel> options;

  PspFieldModel({
    this.id,
    this.tlpType,
    required this.name,
    required this.slug,
    required this.fieldType,
    this.options = const [],
  });

  bool get isDropdown => fieldType == PspFieldType.dropdown;

  factory PspFieldModel.fromJson(Map<String, dynamic> json) {
    final options = json['options'] is List
        ? (json['options'] as List)
            .whereType<Map>()
            .map((option) => CpOptionModel.value(
                  id: option['value'].toString(),
                  name: option['label'].toString(),
                ))
            .toList()
        : <CpOptionModel>[];

    return PspFieldModel(
      id: json['id']?.toString(),
      tlpType: json['tlp_type']?.toString(),
      // API names contain "\n", show them on one line
      name: (json['field_name'] ?? "").toString().replaceAll(RegExp(r'\s+'), ' ').trim(),
      slug: (json['field_alias'] ?? json['field_slug'] ?? "").toString(),
      fieldType: (json['field_type'] ?? PspFieldType.input).toString(),
      options: options,
    );
  }
}

/// Active fields from the API response. Same slug is shown only once.
List<PspFieldModel> pspFieldListResponse(dynamic json) {
  final list = json is List ? json : (json is Map && json['data'] is List ? json['data'] : []);
  final Set<String> slugs = {};
  final List<PspFieldModel> fields = [];
  for (final item in list) {
    if (item is! Map) continue;
    if (item['status'] != null && item['status'].toString() != "1") continue;
    final field = PspFieldModel.fromJson(Map<String, dynamic>.from(item));
    if (field.slug.isEmpty || !slugs.add(field.slug)) continue;
    fields.add(field);
  }
  return fields;
}
