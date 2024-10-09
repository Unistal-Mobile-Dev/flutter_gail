part of 'add_incident_bloc.dart';

sealed class AddIncidentEvent extends Equatable {
  const AddIncidentEvent();
}

class AddIncidentPageLoadEvent extends AddIncidentEvent {
  final BuildContext context;

 const  AddIncidentPageLoadEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class AddIncidentSelectTypeEvent extends AddIncidentEvent {
  final IncidentTypeModel incidentTypeData;

  const  AddIncidentSelectTypeEvent({required this.incidentTypeData});

  @override
  List<Object?> get props => [incidentTypeData];
}

class AddIncidentSelectImageEvent extends AddIncidentEvent {
  final BuildContext context;
  final int mediaType;

  const  AddIncidentSelectImageEvent({required this.context, required this.mediaType});

  @override
  List<Object?> get props => [context, mediaType];
}

class AddIncidentSelectAudioEvent extends AddIncidentEvent {
  final String audioPath;

  const  AddIncidentSelectAudioEvent({required this.audioPath});

  @override
  List<Object?> get props => [audioPath];
}

class AddIncidentSelectVideoEvent extends AddIncidentEvent {
  final BuildContext context;
  final int mediaType;

  const  AddIncidentSelectVideoEvent({required this.context, required this.mediaType});

  @override
  List<Object?> get props => [context, mediaType];
}

class AddIncidentSubmitEvent extends AddIncidentEvent {
  final BuildContext context;

  const  AddIncidentSubmitEvent({required this.context});

  @override
  List<Object?> get props => [context];
}