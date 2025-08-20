import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/category_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/maintenance_base_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/pipeline_image_share_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/section_imgae_share_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/station_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/sub_category_model.dart';
import 'package:flutter_gail/feature/imageShare/helper/imgae_share_helper.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/pipeline_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/region_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/section_model.dart';
import 'package:flutter_gail/feature/task/createTask/helper/create_task_helper.dart';
import 'package:flutter_gail/services/location/location_helper.dart';
import 'package:flutter_gail/services/location/location_model.dart';
import 'package:flutter_gail/utils/commonClass/connectivity_helper.dart';

import '../../../dashboard/domain/model/file_model.dart';

part 'image_share_event.dart';

part 'image_share_state.dart';

class ImageShareBloc extends Bloc<ImageShareEvent, ImageShareState> {
  bool isLoader = false;
  bool isFileLoader = false;
  bool isMaintenanceLoader = false;
  bool isPipelineLoader = false;
  bool isSubCategoryLoader = false;
  List<RegionTypeModel> regionList = [];
  RegionTypeModel regionData = RegionTypeModel();
  List<MaintenanceBaseModel> maintenanceBaseList = [];
  MaintenanceBaseModel maintenanceBaseData = MaintenanceBaseModel();
  List<PipelineImageShareModel> pipelineList = [];
  PipelineImageShareModel pipelineData = PipelineImageShareModel();
  List<SectionImageShareModel> sectionList = [];
  SectionImageShareModel sectionData = SectionImageShareModel();
  List<StationModel> stationList = [];
  StationModel stationData = StationModel();
  List<CategoryModel> categoryList = [];
  CategoryModel categoryData = CategoryModel();
  List<SubCategoryModel> subCategoryList = [];
  SubCategoryModel subCategoryData = SubCategoryModel();
  TextEditingController fromChainageController = TextEditingController();
  TextEditingController toChainageController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  List<FileModel> fileList = [];
  final ImageShareHelper imageShareHelper = ImageShareHelper();

  ImageShareBloc() : super(ImageShareInitial()) {
    on<ImageSharePageLoadEvent>(_pageLoad);
    on<SelectRegionEvent>(_selectRegion);
    on<SelectMaintenanceBaseEvent>(_selectMaintenanceBase);
    on<SelectPipelineEvent>(_selectPipeline);
    on<SelectStationEvent>(_selectStation);
    on<SelectSectionEvent>(_selectSection);
    on<SelectCategoryEvent>(_selectCategory);
    on<SelectSubcategoryEvent>(_selectSubcategory);
    on<ImageShareSelectFileEvent>(_selectFile);
    on<ImageShareDeleteFileEvent>(_deleteFile);
    on<ImageShareSubmitEvent>(_submit);
  }

  _pageLoad(ImageSharePageLoadEvent event, emit) async {
    emit(ImageSharePageLoadState());
    isLoader = false;
    isFileLoader = false;
    isMaintenanceLoader = false;
    isPipelineLoader = false;
    isSubCategoryLoader = false;
    regionList = [];
    regionData = RegionTypeModel();
    maintenanceBaseList = [];
    maintenanceBaseData = MaintenanceBaseModel();
    pipelineList = [];
    pipelineData = PipelineImageShareModel();
    sectionList = [];
    sectionData = SectionImageShareModel();
    stationList = [];
    stationData = StationModel();
    categoryList = [];
    categoryData = CategoryModel();
    subCategoryList = [];
    subCategoryData = SubCategoryModel();
    fromChainageController = TextEditingController();
    toChainageController = TextEditingController();
    titleController = TextEditingController();
    remarkController = TextEditingController();
    fileList = [];
    var regionRes = await imageShareHelper.fetchRegionType();
    if (regionRes != null) {
      regionList = regionRes;
    }

    var categoryRes = await imageShareHelper.fetchCategoryType();
    if (categoryRes != null) {
      categoryList = categoryRes;
    }

    _eventCompleted(emit);
  }

  _selectRegion(SelectRegionEvent event, emit) async {
    regionData = event.regionData;
    pipelineData = PipelineImageShareModel();
    sectionData = SectionImageShareModel();
    stationData = StationModel();
    fromChainageController.text = "";
    toChainageController.text = "";
    isMaintenanceLoader = true;
    _eventCompleted(emit);
    var res =
        await imageShareHelper.fetchMaintenanceBaseType(regionData: regionData);
    if (res != null) {
      maintenanceBaseList = res;
    }
    isMaintenanceLoader = false;
    _eventCompleted(emit);
  }

  _selectMaintenanceBase(SelectMaintenanceBaseEvent event, emit) async {
    maintenanceBaseData = event.maintenanceBaseData;
    pipelineData = PipelineImageShareModel();
    sectionData = SectionImageShareModel();
    stationData = StationModel();
    pipelineList = [];
    sectionList = [];
    isPipelineLoader = true;
    fromChainageController.text = "";
    toChainageController.text = "";
    _eventCompleted(emit);
    var res = await imageShareHelper.fetchPipelineType(
        maintenanceBaseModel: maintenanceBaseData);
    if (res != null) {
      pipelineList = pipelineImageShareListResponse(res['pipelineData']);
      sectionList = sectionImageShareListResponse(res['sections']);
    }

    stationList = [];
    if (sectionList.isNotEmpty) {
      for (var data in sectionList) {
        stationList.addAll(data.stationList!);
      }
    }

    isPipelineLoader = false;
    _eventCompleted(emit);
  }

  _selectPipeline(SelectPipelineEvent event, emit) async {
    pipelineData = event.pipelineImageShareData;
    _eventCompleted(emit);
  }

  _selectStation(SelectStationEvent event, emit) async {
    stationData = event.stationData;
    _eventCompleted(emit);
  }

  _selectSection(SelectSectionEvent event, emit) async {
    sectionData = event.sectionData;
    fromChainageController.text = "";
    toChainageController.text = sectionData.toChainage.toString();
    _eventCompleted(emit);
  }

  _selectCategory(SelectCategoryEvent event, emit) async {
    categoryData = event.categoryData;
    isSubCategoryLoader = true;
    _eventCompleted(emit);
    subCategoryData = SubCategoryModel();
    subCategoryList = [];
    var res =
        await imageShareHelper.fetchSubCategoryType(categoryData: categoryData);
    if (res != null) {
      subCategoryList = res;
    }
    isSubCategoryLoader = false;
    _eventCompleted(emit);
  }

  _selectSubcategory(SelectSubcategoryEvent event, emit) async {
    subCategoryData = event.subCategoryData;
    _eventCompleted(emit);
  }

  _selectFile(ImageShareSelectFileEvent event, emit) async {
    isFileLoader = true;
    _eventCompleted(emit);
    var locationRes = await LocationHelper.getLocationOfflineMode(
        context: event.context.mounted ? event.context : event.context);
    LocationModel locationData = LocationModel();
    if (locationRes != null) {
      locationData = locationRes;
      if (event.mediaType == 1) {
        var res = await DashboardHelper.cameraPiker(
            context: event.context.mounted ? event.context : event.context);
        if (res != null) {
          fileList.add(FileModel(name: "", file: res, keyName: "", lat: locationData.lat ?? 0.0, long: locationData.long ?? 0.0));
        }
      } else {
        var res = await DashboardHelper.imagePiker(
            context: event.context.mounted ? event.context : event.context);
        if (res != null) {
          fileList.add(FileModel(name: "", file: res, keyName: "", lat: locationData.lat ?? 0.0, long: locationData.long ?? 0.0));
        }
      }
    }
    isFileLoader = false;
    _eventCompleted(emit);
  }

  _deleteFile(ImageShareDeleteFileEvent event, emit) async {
    isFileLoader = true;
    _eventCompleted(emit);
    fileList.removeAt(event.index);
    isFileLoader = false;
    _eventCompleted(emit);
  }

  _submit(ImageShareSubmitEvent event, emit) async {
    BuildContext context = event.context;
    isLoader = true;
    _eventCompleted(emit);

    if (await ConnectivityHelper.allConnectivityCheck(context: event.context) ==
        false) {
      isLoader = false;
      _eventCompleted(emit);
      return;
    }

    var textFiledValidation = await imageShareHelper.textFieldValidationCheck(
        context: context,
        regionData: regionData,
        maintenanceBaseModel: maintenanceBaseData,
        pipelineData: pipelineData,
        sectionData: sectionData,
        categoryData: categoryData,
        subCategoryData: subCategoryData,
        stationData: stationData,
        fromChainage: fromChainageController.text.toString(),
        toChainage: toChainageController.text.toString(),
        title: titleController.text.toString(),
        remark: remarkController.text.toString(),
        fileList: fileList);

    if (textFiledValidation == false) {
      isLoader = false;
      _eventCompleted(emit);
      return false;
    }


    var res = await imageShareHelper.submit(
        context: context,
        regionData: regionData,
        maintenanceBaseModel: maintenanceBaseData,
        pipelineData: pipelineData,
        sectionData: sectionData,
        categoryData: categoryData,
        subCategoryData: subCategoryData,
        stationData: stationData,
        fromChainage: fromChainageController.text.toString(),
        toChainage: toChainageController.text.toString(),
        title: titleController.text.toString(),
        remark: remarkController.text.toString(),
        fileList: fileList);
    if (res != null) {
      isLoader = false;
      isFileLoader = false;
      isMaintenanceLoader = false;
      isPipelineLoader = false;
      isSubCategoryLoader = false;
      regionData = RegionTypeModel();
      maintenanceBaseList = [];
      maintenanceBaseData = MaintenanceBaseModel();
      pipelineList = [];
      pipelineData = PipelineImageShareModel();
      sectionList = [];
      sectionData = SectionImageShareModel();
      stationList = [];
      stationData = StationModel();
      categoryData = CategoryModel();
      subCategoryList = [];
      subCategoryData = SubCategoryModel();
      fromChainageController = TextEditingController();
      toChainageController = TextEditingController();
      titleController = TextEditingController();
      remarkController = TextEditingController();
      fileList = [];
    }

    isLoader = false;
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<ImageShareState> emit) {
    emit(FetchImageShareDataState(
        regionData: regionData,
        stationList: stationList,
        titleController: titleController,
        isFileLoader: isFileLoader,
        isLoader: isLoader,
        isSubCategoryLoader: isSubCategoryLoader,
        isPipelineLoader: isPipelineLoader,
        isMaintenanceLoader: isMaintenanceLoader,
        categoryList: categoryList,
        categoryData: categoryData,
        fileList: fileList,
        fromChainageController: fromChainageController,
        maintenanceBaseData: maintenanceBaseData,
        maintenanceBaseList: maintenanceBaseList,
        pipelineData: pipelineData,
        pipelineList: pipelineList,
        regionList: regionList,
        remarkController: remarkController,
        sectionData: sectionData,
        sectionList: sectionList,
        stationData: stationData,
        subCategoryData: subCategoryData,
        subCategoryList: subCategoryList,
        toChainageController: toChainageController));
  }
}
