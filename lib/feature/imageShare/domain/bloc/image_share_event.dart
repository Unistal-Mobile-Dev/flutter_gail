part of 'image_share_bloc.dart';

sealed class ImageShareEvent extends Equatable {
  const ImageShareEvent();
}

class ImageSharePageLoadEvent extends ImageShareEvent {
   final BuildContext context;
   const ImageSharePageLoadEvent({required this.context});
  @override
  List<Object?> get props => [];
}

class SelectRegionEvent extends ImageShareEvent {
  final RegionTypeModel regionData;
  const SelectRegionEvent({required this.regionData});
  @override
  List<Object?> get props => [regionData];
}

class SelectMaintenanceBaseEvent extends ImageShareEvent {
  final MaintenanceBaseModel maintenanceBaseData;
  const SelectMaintenanceBaseEvent({required this.maintenanceBaseData});
  @override
  List<Object?> get props => [maintenanceBaseData];
}

class SelectPipelineEvent extends ImageShareEvent {
  final PipelineImageShareModel pipelineImageShareData;
  const SelectPipelineEvent({required this.pipelineImageShareData});
  @override
  List<Object?> get props => [pipelineImageShareData];
}

class SelectStationEvent extends ImageShareEvent {
  final StationModel stationData;
  const SelectStationEvent({required this.stationData});
  @override
  List<Object?> get props => [stationData];
}

class SelectSectionEvent extends ImageShareEvent {
  final SectionImageShareModel sectionData;
  const SelectSectionEvent({required this.sectionData});
  @override
  List<Object?> get props => [sectionData];
}

class SelectCategoryEvent extends ImageShareEvent {
  final CategoryModel categoryData;
  const SelectCategoryEvent({required this.categoryData});
  @override
  List<Object?> get props => [categoryData];
}

class SelectSubcategoryEvent extends ImageShareEvent {
  final SubCategoryModel subCategoryData;
  const SelectSubcategoryEvent({required this.subCategoryData});
  @override
  List<Object?> get props => [subCategoryData];
}

class ImageShareSelectFileEvent extends ImageShareEvent {
  final BuildContext context;
  final int mediaType;
  const ImageShareSelectFileEvent({required this.context, required this.mediaType});
  @override
  List<Object?> get props => [context, mediaType];
}

class ImageShareDeleteFileEvent extends ImageShareEvent {
  final int index;
  const ImageShareDeleteFileEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class ImageShareSubmitEvent extends ImageShareEvent {
  final BuildContext context;
  const ImageShareSubmitEvent({required this.context});
  @override
  List<Object?> get props => [context];
}