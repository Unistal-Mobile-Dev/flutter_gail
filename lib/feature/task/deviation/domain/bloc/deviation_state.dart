part of 'deviation_bloc.dart';

sealed class DeviationState extends Equatable {
  const DeviationState();
}

final class DeviationInitial extends DeviationState {
  @override
  List<Object> get props => [];
}

final class DeviationPageLoadState extends DeviationInitial {
  @override
  List<Object> get props => [];
}


final class FetchDeviationDataState extends DeviationInitial {
  final bool isLoader;
  final DeviationModel deviationData;
  final List<DeviationModel> deviationList;
  final File file;
  final bool isFileLoader;
  final TextEditingController otherController;

  FetchDeviationDataState({
    required this.deviationList,
    required this.isLoader,
    required this.file,
    required this.isFileLoader,
    required this.deviationData,
    required this.otherController,
});

  @override
  List<Object> get props => [
    deviationList,
    isLoader,
    file,
    isFileLoader,
    deviationData,
    otherController,
  ];
}
