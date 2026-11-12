List<ConstantModel> constantListResponse(dynamic json) {
  if (json is Map) {
    return ConstantModel.mapToList(Map<String, dynamic>.from(json));
  }
  if (json is List) {
    return json
        .map((x) => ConstantModel.fromJson(Map<String, dynamic>.from(x)))
        .toList();
  }
  return [];
}

class ConstantModel {
  final String? key;
  final String? value;

  ConstantModel({
    this.key,
    this.value,
  });

  factory ConstantModel.fromJson(Map<String, dynamic> json) {
    return ConstantModel(
      key: json['id']?.toString(),
      value: json['name']?.toString(),
    );
  }

  static List<ConstantModel> mapToList(Map<String, dynamic> mapData,) {
    return mapData.entries.map((entry) {
      return ConstantModel(
        key: entry.key.trim(),
        value: entry.value?.toString(),
      );
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': key,
      'name': value,
    };
  }

  @override
  String toString() => value ?? '';
}
