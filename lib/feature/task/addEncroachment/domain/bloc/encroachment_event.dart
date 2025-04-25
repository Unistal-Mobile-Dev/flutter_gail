part of 'encroachment_bloc.dart';

sealed class EncroachmentEvent extends Equatable {
  const EncroachmentEvent();
}

class PageLoadEvent extends EncroachmentEvent {
  final BuildContext context;

  const PageLoadEvent({required this.context,});

  @override
  List<Object?> get props => [context];
}

class SelectEncroachmentTypeEvent extends EncroachmentEvent {
  final EncroachmentModel encroachmentData;

  const SelectEncroachmentTypeEvent({required this.encroachmentData});

  @override
  List<Object?> get props => [encroachmentData];
}

class SelectFileEvent extends EncroachmentEvent {
  final BuildContext context;

  const SelectFileEvent({
    required this.context,
  });

  @override
  List<Object?> get props => [context];
}

class SubmitEvent extends EncroachmentEvent {
  final BuildContext context;

  const SubmitEvent({
    required this.context,
  });

  @override
  List<Object?> get props => [context];
}
