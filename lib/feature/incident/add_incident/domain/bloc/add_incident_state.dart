part of 'add_incident_bloc.dart';

sealed class AddIncidentState extends Equatable {
  const AddIncidentState();
}

final class AddIncidentInitial extends AddIncidentState {
  @override
  List<Object> get props => [];
}

final class AddIncidentPageLoadState extends AddIncidentInitial {
  @override
  List<Object> get props => [];
}

final class FetchAddIncidentDataState extends AddIncidentInitial {
  final bool isLoader;
  final List<IncidentTypeModel> incidentTypeList;
  final IncidentTypeModel incidentTypeData;
  final TextEditingController incidentReportController;
  final File imageFile;
  final File audioRecordFile;
  final File videoFile;

  FetchAddIncidentDataState({
   required this.videoFile,
   required this.isLoader,
   required this.audioRecordFile,
   required this.imageFile,
   required this.incidentTypeData,
   required this.incidentTypeList,
   required this.incidentReportController,
  });

  @override
  List<Object> get props => [
    videoFile,
    isLoader,
    audioRecordFile,
    imageFile,
    incidentTypeData,
    incidentTypeList,
    incidentReportController,
  ];
}
