class PiggabilityDataModel {
  final Map<String, int> piggabilityCountMap;
  final Map<String, int> length;
  final Map<String, int> regulatoryTypeCounts;

  PiggabilityDataModel({
    required this.piggabilityCountMap,
    required this.length,
    required this.regulatoryTypeCounts,
  });

  factory PiggabilityDataModel.fromMap(Map<String, dynamic> map) {
    return PiggabilityDataModel(
      piggabilityCountMap: Map<String, int>.from(map['piggabilityCountMap'] ?? {}),
      length: Map<String, int>.from(map['length'] ?? {}),
      regulatoryTypeCounts: Map<String, int>.from(map['regulatoryTypeCounts'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'piggabilityCountMap': piggabilityCountMap,
      'length': length,
      'regulatoryTypeCounts': regulatoryTypeCounts,
    };
  }
}
