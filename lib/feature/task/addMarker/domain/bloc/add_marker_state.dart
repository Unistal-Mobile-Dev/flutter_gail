part of 'add_marker_bloc.dart';

sealed class AddMarkerState extends Equatable {
  const AddMarkerState();
}

final class AddMarkerInitial extends AddMarkerState {
  @override
  List<Object> get props => [];
}

final class AddMarkerPageLoadState extends AddMarkerInitial {
  @override
  List<Object> get props => [];
}

final class FetchAddMarkerDataState extends AddMarkerInitial {
  final bool isLoader;
  final List<MarkerTypeModel> markerTypeList;
  final MarkerTypeModel markerTypeData;
  final String condition;
  final String painting;
  final TextEditingController remarkController;
  final File cameraFile;
  final File videoFile;
  final File voiceRecordFile;

  FetchAddMarkerDataState({
   required this.isLoader,
   required this.remarkController,
   required this.condition,
   required this.markerTypeData,
   required this.markerTypeList,
   required this.painting,
   required this.cameraFile,
   required this.videoFile,
   required this.voiceRecordFile,
});

  @override
  List<Object> get props => [
    isLoader,
    remarkController,
    condition,
    markerTypeData,
    markerTypeList,
    painting,
    cameraFile,
    videoFile,
    voiceRecordFile,
  ];
}