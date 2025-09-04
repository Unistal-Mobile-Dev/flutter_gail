class PipelineModel {
  final int objectId;
  final String sectionName;
  final String engRouteName;

  PipelineModel({
    required this.objectId,
    required this.sectionName,
    required this.engRouteName,
  });

  @override
  String toString() {
    return '$engRouteName($sectionName)';
  }
}
