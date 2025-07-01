List<PipelineSection> pipelineSectionListResponse(var json) {
  return List<PipelineSection>.from(json.map((x) => PipelineSection.fromMap(x)));
}

class PipelineSection {
  final String section;

  final int iliNd;
  final int iliDue;
  final int iliOverdue;

  final int daNd;
  final int daDue;
  final int daOverdue;

  final int iaOtherNd;
  final int iaOtherDue;
  final int iaOtherOverdue;

  final int cipsNd;
  final int cipsDue;
  final int cipsOverdue;

  final int catNd;
  final int catDue;
  final int catOverdue;

  final int dcvgAcvgNd;
  final int dcvgAcvgDue;
  final int dcvgAcvgOverdue;

  final int piggingNd;
  final int piggingDue;
  final int piggingOverdue;

  final int cmlNd;
  final int cmlDue;
  final int cmlOverdue;

  final int anomImmediate;
  final int anomScheduled;
  final int anomVerification;

  final int cpProtected;
  final int cpOverProtection;
  final int cpUnderProtection;

  final int healthyIj;
  final int shortedIj;
  final int healthyCasing;
  final int shortedCasingElectrolytic;
  final int shortedCasingElectrical;

  final int noInterference;
  final int acInterference;

  final int weReported;
  final int weTempTaken;
  final int wePermanentPlanned;

  PipelineSection({
    required this.section,
    required this.iliNd,
    required this.iliDue,
    required this.iliOverdue,
    required this.daNd,
    required this.daDue,
    required this.daOverdue,
    required this.iaOtherNd,
    required this.iaOtherDue,
    required this.iaOtherOverdue,
    required this.cipsNd,
    required this.cipsDue,
    required this.cipsOverdue,
    required this.catNd,
    required this.catDue,
    required this.catOverdue,
    required this.dcvgAcvgNd,
    required this.dcvgAcvgDue,
    required this.dcvgAcvgOverdue,
    required this.piggingNd,
    required this.piggingDue,
    required this.piggingOverdue,
    required this.cmlNd,
    required this.cmlDue,
    required this.cmlOverdue,
    required this.anomImmediate,
    required this.anomScheduled,
    required this.anomVerification,
    required this.cpProtected,
    required this.cpOverProtection,
    required this.cpUnderProtection,
    required this.healthyIj,
    required this.shortedIj,
    required this.healthyCasing,
    required this.shortedCasingElectrolytic,
    required this.shortedCasingElectrical,
    required this.noInterference,
    required this.acInterference,
    required this.weReported,
    required this.weTempTaken,
    required this.wePermanentPlanned,
  });

  factory PipelineSection.fromMap(Map<String, dynamic> map) {
    return PipelineSection(
      section: map['Section'] ?? '',
      iliNd: map['ILI_ND'] ?? 0,
      iliDue: map['ILI_Due'] ?? 0,
      iliOverdue: map['ILI_Overdue'] ?? 0,
      daNd: map['DA_ND'] ?? 0,
      daDue: map['DA_Due'] ?? 0,
      daOverdue: map['DA_Overdue'] ?? 0,
      iaOtherNd: map['IA_Other_ND'] ?? 0,
      iaOtherDue: map['IA_Other_Due'] ?? 0,
      iaOtherOverdue: map['IA_Other_Overdue'] ?? 0,
      cipsNd: map['CIPS_ND'] ?? 0,
      cipsDue: map['CIPS_Due'] ?? 0,
      cipsOverdue: map['CIPS_Overdue'] ?? 0,
      catNd: map['CAT_ND'] ?? 0,
      catDue: map['CAT_Due'] ?? 0,
      catOverdue: map['CAT_Overdue'] ?? 0,
      dcvgAcvgNd: map['DCVG_ACVG_ND'] ?? 0,
      dcvgAcvgDue: map['DCVG_ACVG_Due'] ?? 0,
      dcvgAcvgOverdue: map['DCVG_ACVG_Overdue'] ?? 0,
      piggingNd: map['Pigging_ND'] ?? 0,
      piggingDue: map['Pigging_Due'] ?? 0,
      piggingOverdue: map['Pigging_Overdue'] ?? 0,
      cmlNd: map['CML_ND'] ?? 0,
      cmlDue: map['CML_Due'] ?? 0,
      cmlOverdue: map['CML_Overdue'] ?? 0,
      anomImmediate: map['Anom_Immediate'] ?? 0,
      anomScheduled: map['Anom_Scheduled'] ?? 0,
      anomVerification: map['Anom_Verification'] ?? 0,
      cpProtected: map['CP_Protected'] ?? 0,
      cpOverProtection: map['CP_Over_Protection'] ?? 0,
      cpUnderProtection: map['CP_Under_Protection'] ?? 0,
      healthyIj: map['Healthy_IJ'] ?? 0,
      shortedIj: map['Shorted_IJ'] ?? 0,
      healthyCasing: map['Healthy_Casing'] ?? 0,
      shortedCasingElectrolytic: map['Shorted_Casing_Electrolytic'] ?? 0,
      shortedCasingElectrical: map['Shorted_Casing_Electrical'] ?? 0,
      noInterference: map['No_Interference'] ?? 0,
      acInterference: map['AC_Interference'] ?? 0,
      weReported: map['WE_Reported'] ?? 0,
      weTempTaken: map['WE_Temp_taken'] ?? 0,
      wePermanentPlanned: map['WE_Permanent_Planned'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Section": section,
      "ILI_ND": iliNd,
      "ILI_Due": iliDue,
      "ILI_Overdue": iliOverdue,
      "DA_ND": daNd,
      "DA_Due": daDue,
      "DA_Overdue": daOverdue,
      "IA_Other_ND": iaOtherNd,
      "IA_Other_Due": iaOtherDue,
      "IA_Other_Overdue": iaOtherOverdue,
      "CIPS_ND": cipsNd,
      "CIPS_Due": cipsDue,
      "CIPS_Overdue": cipsOverdue,
      "CAT_ND": catNd,
      "CAT_Due": catDue,
      "CAT_Overdue": catOverdue,
      "DCVG_ACVG_ND": dcvgAcvgNd,
      "DCVG_ACVG_Due": dcvgAcvgDue,
      "DCVG_ACVG_Overdue": dcvgAcvgOverdue,
      "Pigging_ND": piggingNd,
      "Pigging_Due": piggingDue,
      "Pigging_Overdue": piggingOverdue,
      "CML_ND": cmlNd,
      "CML_Due": cmlDue,
      "CML_Overdue": cmlOverdue,
      "Anom_Immediate": anomImmediate,
      "Anom_Scheduled": anomScheduled,
      "Anom_Verification": anomVerification,
      "CP_Protected": cpProtected,
      "CP_Over_Protection": cpOverProtection,
      "CP_Under_Protection": cpUnderProtection,
      "Healthy_IJ": healthyIj,
      "Shorted_IJ": shortedIj,
      "Healthy_Casing": healthyCasing,
      "Shorted_Casing_Electrolytic": shortedCasingElectrolytic,
      "Shorted_Casing_Electrical": shortedCasingElectrical,
      "No_Interference": noInterference,
      "AC_Interference": acInterference,
      "WE_Reported": weReported,
      "WE_Temp_taken": weTempTaken,
      "WE_Permanent_Planned": wePermanentPlanned,
    };
  }
}
