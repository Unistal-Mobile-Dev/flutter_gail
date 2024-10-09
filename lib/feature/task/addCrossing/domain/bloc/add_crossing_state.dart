part of 'add_crossing_bloc.dart';

sealed class AddCrossingState extends Equatable {
  const AddCrossingState();
}

final class AddCrossingInitial extends AddCrossingState {
  @override
  List<Object> get props => [];
}


final class AddCrossingPageLoadState extends AddCrossingInitial {
  @override
  List<Object> get props => [];
}

final class FetchAddCrossingDataState extends AddCrossingInitial {
  final bool isLoader;
  final List<CrossingTypeModel> crossingTypeList;
  final CrossingTypeModel crossingTypeData;
  final String warningMarker;
  final String drainCondition;
  final String bankCondition;
  final TextEditingController remarkController;
  final File cameraFile;
  final File videoFile;
  final File voiceRecordFile;

  FetchAddCrossingDataState({
    required this.isLoader,
    required this.remarkController,
    required this.warningMarker,
    required this.crossingTypeData,
    required this.crossingTypeList,
    required this.drainCondition,
    required this.bankCondition,
    required this.cameraFile,
    required this.videoFile,
    required this.voiceRecordFile,
  });

  @override
  List<Object> get props => [
    isLoader,
    remarkController,
    warningMarker,
    crossingTypeData,
    crossingTypeList,
    drainCondition,
    bankCondition,
    cameraFile,
    videoFile,
    voiceRecordFile,
  ];
}