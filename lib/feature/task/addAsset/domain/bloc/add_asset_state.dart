part of 'add_asset_bloc.dart';

sealed class AddAssetState extends Equatable {
  const AddAssetState();
}

final class AddAssetInitial extends AddAssetState {
  @override
  List<Object> get props => [];
}

final class AddAssetPageLoadState extends AddAssetInitial {
  @override
  List<Object> get props => [];
}

final class FetchAddAssetDataState extends AddAssetInitial {
  final bool isLoader;
  final List<MarkerTypeModel> markerTypeList;
  final MarkerTypeModel markerTypeData;
  final List<ConstantModel> listOfAssetType;
  final ConstantModel assetTypeData;
  final String condition;
  final String painting;
  final TextEditingController remarkController;
  final File cameraFile;
  final File videoFile;
  final File voiceRecordFile;

  FetchAddAssetDataState({
   required this.isLoader,
   required this.remarkController,
   required this.condition,
   required this.markerTypeData,
   required this.markerTypeList,
   required this.painting,
   required this.cameraFile,
   required this.videoFile,
   required this.voiceRecordFile,
    required this.listOfAssetType,
    required this.assetTypeData,
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
    listOfAssetType,
   assetTypeData,
  ];
}