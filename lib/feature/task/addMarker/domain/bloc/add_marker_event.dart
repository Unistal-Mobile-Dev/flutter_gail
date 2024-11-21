part of 'add_marker_bloc.dart';

sealed class AddMarkerEvent extends Equatable {
  const AddMarkerEvent();
}

class AddMarkerPageLoadEvent extends AddMarkerEvent {
  final BuildContext context;
  final dynamic data;

  const AddMarkerPageLoadEvent({
    required this.context,
    required this.data,
 });

  @override
  List<Object?> get props => [context];
}

class AddMarkerSelectMarkerEvent extends AddMarkerEvent {
  final int index;

  const AddMarkerSelectMarkerEvent({
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}

class AddMarkerSelectConditionEvent extends AddMarkerEvent {
  final String condition;

  const AddMarkerSelectConditionEvent({
    required this.condition,
  });

  @override
  List<Object?> get props => [condition];
}

class AddMarkerSelectPaintingEvent extends AddMarkerEvent {
  final String painting;

  const AddMarkerSelectPaintingEvent({
    required this.painting,
  });

  @override
  List<Object?> get props => [painting];
}

class AddMarkerSelectMediaEvent extends AddMarkerEvent {
  final BuildContext context;
  final int mediaType;
  final bool isVideo;

  const AddMarkerSelectMediaEvent({
    required this.context,
    required this.mediaType,
    required this.isVideo,
  });

  @override
  List<Object?> get props => [context, mediaType,isVideo];
}

class AddMarkerSelectVoiceEvent extends AddMarkerEvent {
  final String audioPath;

  const AddMarkerSelectVoiceEvent({
    required this.audioPath,
  });

  @override
  List<Object?> get props => [audioPath];
}

class AddMarkerSubmitEvent extends AddMarkerEvent {
  final BuildContext context;

  const AddMarkerSubmitEvent({
    required this.context,
  });

  @override
  List<Object?> get props => [context];
}