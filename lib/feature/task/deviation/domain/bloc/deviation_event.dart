part of 'deviation_bloc.dart';

sealed class DeviationEvent extends Equatable {
  const DeviationEvent();
}


class DeviationPageLoadEvent extends DeviationEvent {
  final BuildContext context;
  const DeviationPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class SelectDeviation extends DeviationEvent {
  final DeviationModel deviationData;
  const SelectDeviation({required this.deviationData});

  @override
  List<Object?> get props => [deviationData];
}

class SelectFile extends DeviationEvent {
  final BuildContext context;
  const SelectFile({required this.context});

  @override
  List<Object?> get props => [context];
}

class SubmitEvent extends DeviationEvent {
  final BuildContext context;
  const SubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}