part of 'image_share_bloc.dart';

sealed class ImageShareState extends Equatable {
  const ImageShareState();
}

final class ImageShareInitial extends ImageShareState {
  @override
  List<Object> get props => [];
}


final class ImageSharePageLoadState extends ImageShareInitial {
  @override
  List<Object> get props => [];
}

final class FetchImageShareDataState extends ImageShareInitial {
  final bool isLoader;
  final bool isFileLoader;
  final bool isMaintenanceLoader;
  final bool isPipelineLoader;
  final bool isSubCategoryLoader;
  final List<RegionTypeModel> regionList;
  final RegionTypeModel regionData;
  final List<MaintenanceBaseModel> maintenanceBaseList;
  final MaintenanceBaseModel maintenanceBaseData;
  final List<PipelineImageShareModel> pipelineList;
  final PipelineImageShareModel pipelineData;
  final List<SectionImageShareModel> sectionList;
  final SectionImageShareModel sectionData;
  final List<StationModel> stationList;
  final StationModel stationData;
  final List<CategoryModel> categoryList;
  final CategoryModel categoryData;
  final List<SubCategoryModel> subCategoryList;
  final SubCategoryModel subCategoryData;
  final TextEditingController fromChainageController;
  final TextEditingController toChainageController;
  final TextEditingController titleController;
  final TextEditingController remarkController;
  final List<FileModel> fileList;

  FetchImageShareDataState({
    required this.regionData,
    required this.stationList,
    required this.titleController,
    required this.isFileLoader,
    required this.isLoader,
    required this.isPipelineLoader,
    required this.isMaintenanceLoader,
    required this.isSubCategoryLoader,
    required this.categoryList,
    required this.categoryData,
    required this.fileList,
    required this.fromChainageController,
    required this.maintenanceBaseData,
    required this.maintenanceBaseList,
    required this.pipelineData,
    required this.pipelineList,
    required this.regionList,
    required this.remarkController,
    required this.sectionData,
    required this.sectionList,
    required this.stationData,
    required this.subCategoryData,
    required this.subCategoryList,
    required this.toChainageController
});

  @override
  List<Object> get props => [
    regionData,
    stationList,
    titleController,
    isFileLoader,
    isLoader,
    isPipelineLoader,
    isMaintenanceLoader,
    isSubCategoryLoader,
    categoryList,
    categoryData,
    fileList,
    fromChainageController,
    maintenanceBaseData,
    maintenanceBaseList,
    pipelineData,
    pipelineList,
    regionList,
    remarkController,
    sectionData,
    sectionList,
    stationData,
    subCategoryData,
    subCategoryList,
    toChainageController
  ];
}

