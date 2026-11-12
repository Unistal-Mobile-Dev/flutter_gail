part of 'add_asset_bloc.dart';

sealed class AddAssetEvent extends Equatable {
  const AddAssetEvent();
}

class AddAssetPageLoadEvent extends AddAssetEvent {
  final BuildContext context;
  final dynamic data;

  const AddAssetPageLoadEvent({
    required this.context,
    required this.data,
 });

  @override
  List<Object?> get props => [context];
}

class AddAssetSelectAssetEvent extends AddAssetEvent {
  final int index;

  const AddAssetSelectAssetEvent({
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}

class AddAssetSelectAssetTypeEvent extends AddAssetEvent {
  final ConstantModel assetTypeValue;
  const AddAssetSelectAssetTypeEvent({required this.assetTypeValue});
  @override
  List<Object?> get props => [assetTypeValue];
}

class AddAssetSelectConditionEvent extends AddAssetEvent {
  final String condition;

  const AddAssetSelectConditionEvent({
    required this.condition,
  });

  @override
  List<Object?> get props => [condition];
}

class AddAssetSelectPaintingEvent extends AddAssetEvent {
  final String painting;

  const AddAssetSelectPaintingEvent({
    required this.painting,
  });

  @override
  List<Object?> get props => [painting];
}

class AddAssetSelectMediaEvent extends AddAssetEvent {
  final BuildContext context;
  final int mediaType;
  final bool isVideo;

  const AddAssetSelectMediaEvent({
    required this.context,
    required this.mediaType,
    required this.isVideo,
  });

  @override
  List<Object?> get props => [context, mediaType,isVideo];
}

class AddAssetSelectVoiceEvent extends AddAssetEvent {
  final String audioPath;

  const AddAssetSelectVoiceEvent({
    required this.audioPath,
  });

  @override
  List<Object?> get props => [audioPath];
}

class AddAssetSubmitEvent extends AddAssetEvent {
  final BuildContext context;

  const AddAssetSubmitEvent({
    required this.context,
  });

  @override
  List<Object?> get props => [context];
}