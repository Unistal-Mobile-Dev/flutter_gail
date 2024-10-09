part of 'add_crossing_bloc.dart';

sealed class AddCrossingEvent extends Equatable {
  const AddCrossingEvent();
}

class AddCrossingPageLoadEvent extends AddCrossingEvent {
  final BuildContext context;

  const AddCrossingPageLoadEvent({
    required this.context,
  });

  @override
  List<Object?> get props => [context];
}

class AddCrossingSelectCrossingEvent extends AddCrossingEvent {
  final int index;

  const AddCrossingSelectCrossingEvent({
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}

class AddCrossingSelectWarningMarkerEvent extends AddCrossingEvent {
  final String warningMarker;

  const AddCrossingSelectWarningMarkerEvent({
    required this.warningMarker,
  });

  @override
  List<Object?> get props => [warningMarker];
}

class AddCrossingSelectDrainConditionEvent extends AddCrossingEvent {
  final String drainCondition;

  const AddCrossingSelectDrainConditionEvent({
    required this.drainCondition,
  });

  @override
  List<Object?> get props => [drainCondition];
}

class AddCrossingSelectBankConditionEvent extends AddCrossingEvent {
  final String bankCondition;

  const AddCrossingSelectBankConditionEvent({
    required this.bankCondition,
  });

  @override
  List<Object?> get props => [bankCondition];
}

class AddCrossingSelectMediaEvent extends AddCrossingEvent {
  final BuildContext context;
  final int mediaType;
  final bool isVideo;

  const AddCrossingSelectMediaEvent({
    required this.context,
    required this.mediaType,
    required this.isVideo,
  });

  @override
  List<Object?> get props => [context, mediaType,isVideo];
}

class AddCrossingSelectVoiceEvent extends AddCrossingEvent {
  final String audioPath;

  const AddCrossingSelectVoiceEvent({
    required this.audioPath,
  });

  @override
  List<Object?> get props => [audioPath];
}

class AddCrossingSubmitEvent extends AddCrossingEvent {
  final BuildContext context;

  const AddCrossingSubmitEvent({
    required this.context,
  });

  @override
  List<Object?> get props => [context];
}