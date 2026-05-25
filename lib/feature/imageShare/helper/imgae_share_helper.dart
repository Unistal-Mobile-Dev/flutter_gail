import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/interface/image_share_interface.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/category_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/maintenance_base_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/pipeline_image_share_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/section_imgae_share_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/station_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/sub_category_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/region_type_model.dart';
import 'package:flutter_gail/services/location/location_helper.dart';
import 'package:flutter_gail/services/location/location_model.dart';
import 'package:flutter_gail/utils/commonClass/connectivity_helper.dart';

class ImageShareHelper extends ImageShareInterface {
  @override
  Future<dynamic> fetchCategoryType() async {
    try {
      String url = APIs.getCategoryApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['data'] != null) {
        return categoryListResponse(res['data']);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<dynamic> fetchMaintenanceBaseType(
      {required RegionTypeModel regionData}) async {
    try {
      String url = APIs.areaStructureApi + "?region_code=${regionData.code}";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['maintBaseData'] != null) {
        return maintenanceBaseListResponse(res['maintBaseData']);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<dynamic> fetchPipelineType(
      {required MaintenanceBaseModel maintenanceBaseModel}) async {
    try {
      String url =
          APIs.getPipelineApi + "?maint_base_code=${maintenanceBaseModel.code}";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['sections'] != null && res['pipelineData'] != null) {
        return res;
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<dynamic> fetchRegionType() async {
    try {
      String url = APIs.areaStructureApi;
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['regionData'] != null) {
        return regionTypeListResponse(res['regionData']);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<dynamic> fetchSubCategoryType(
      {required CategoryModel categoryData}) async {
    try {
      String url =
          APIs.getSubCategoryApi + "?categoryCode=${categoryData.code}";
      var res = await ServerRequest.getData(urlEndPoint: url);
      if (res != null && res['data'] != null) {
        return subCategoryListResponse(res['data']);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<dynamic> textFieldValidationCheck(
      {required BuildContext context,
      required RegionTypeModel regionData,
      required MaintenanceBaseModel maintenanceBaseModel,
      required PipelineImageShareModel pipelineData,
      required SectionImageShareModel sectionData,
      required CategoryModel categoryData,
      required SubCategoryModel subCategoryData,
      required StationModel stationData,
      required String fromChainage,
      required String toChainage,
      required String title,
      required String remark,
      required List<FileModel> fileList}) async {
    try {
      if (regionData.id == null) {
        SnackBarErrorWidget(context).show(message: "Please select a region");
        return false;
      }
      if (maintenanceBaseModel.name == null) {
        SnackBarErrorWidget(context)
            .show(message: "Please select a maintenance base");
        return false;
      }

      if (pipelineData.pipelineCode == null ||
          pipelineData.pipelineCode!.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please select a pipeline");
        return false;
      }

      if (fromChainage.isNotEmpty && sectionData.sectionLength == null) {
        SnackBarErrorWidget(context).show(message: "Please select section");

        final double? from = double.tryParse(fromChainage);
        final double? to = double.tryParse(sectionData.sectionLength);

        if (from == null || to == null || from >= to) {
          SnackBarErrorWidget(context).show(message: "Invalid chainage values");
          return false;
        }

        return false;
      }

      if (fromChainage.isEmpty && sectionData.sectionLength != null) {
        SnackBarErrorWidget(context).show(message: "Please enter chainage values");
        return false;
      }

      if(fromChainage.isNotEmpty && sectionData.sectionLength != null){
        final double from = double.parse(fromChainage.toString());
        final double length = double.parse(sectionData.sectionLength.toString());

        if (from > length) {
          SnackBarErrorWidget(context).show(message: "Invalid chainage values");
          return false;
        }
      }

      // if (sectionData.sectionCode == null || sectionData.sectionCode!.isEmpty) {
      //   SnackBarErrorWidget(context).show(message: "Please select a section");
      //   return false;
      // }
      //
      // if (stationData.name == null) {
      //   SnackBarErrorWidget(context).show(message: "Please select station");
      //   return false;
      // }

      if (categoryData.name == null) {
        SnackBarErrorWidget(context).show(message: "Please select a category");
        return false;
      }

      if (subCategoryData.name == null) {
        SnackBarErrorWidget(context)
            .show(message: "Please select a sub-category");
        return false;
      }

      // if (fromChainage.isEmpty) {
      //   SnackBarErrorWidget(context)
      //       .show(message: "Please enter Chainage");
      //   return false;
      // }

      // if (toChainage.isEmpty) {
      //   SnackBarErrorWidget(context).show(message: "Please enter To Chainage");
      //   return false;
      // }

      if (title.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter Title");
        return false;
      }

      if (fileList.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please upload at least one image");
        return false;
      }
      return true;
    } catch (_) {}
    return false;
  }

  @override
  Future<dynamic> submit(
      {required BuildContext context,
      required RegionTypeModel regionData,
      required MaintenanceBaseModel maintenanceBaseModel,
      required PipelineImageShareModel pipelineData,
      required SectionImageShareModel sectionData,
      required CategoryModel categoryData,
      required SubCategoryModel subCategoryData,
      required StationModel stationData,
      required String fromChainage,
      required String toChainage,
      required String title,
      required String remark,
      required List<FileModel> fileList}) async {
     try{

       String url = APIs.saveImageSharingApi;
       List<FileModel> imageList = [];
       int id = 1;
       Map<String, String> list = {};
       if(fileList.isNotEmpty){
         for(var data in fileList){
           imageList.add(FileModel(
               name: data.file.path.split('/').last,
               file: data.file,
               keyName: "file-$id"));

           var value = {
             "file-$id-lat" : data.lat.toString(),
             "file-$id-lng" : data.long.toString(),
             "file-$id-section" : sectionData.sectionName != null ? sectionData.sectionName.toString()  : "",
             "file-$id-station" : stationData.name != null ? stationData.name.toString()  : "",
           };
           list.addAll(value);
           id++;
         }
       }

       var locationRes = await LocationHelper.getLocationOfflineMode(
           context: context);
       LocationModel locationData = LocationModel();
       if (locationRes == null) {
          return null;
       } else {
         locationData = locationRes;
       }

       if (await ConnectivityHelper.allConnectivityCheck(
         context: context.mounted ? context : context,
       ) ==
           false) {
         return null;
       }

       final DateFormat formatter = DateFormat('dd-MM-yyyy');
       final String currentDate = formatter.format(DateTime.now());
       var json = {
         'region': regionData.code.toString(),
         'regionName': regionData.name.toString(),
         'maintBaseCode': maintenanceBaseModel.code.toString(),
         'baseName': maintenanceBaseModel.name.toString(),
         'pipelineCode': pipelineData.pipelineCode.toString(),
         'pipelineName': pipelineData.pipelineName.toString(),
         'stationName': stationData.name.toString(),
         'sectionCode': sectionData.sectionCode.toString(),
         'sectionName': sectionData.sectionName.toString(),
         'sectionLength': sectionData.sectionLength.toString(),
         'chainage': fromChainage.toString(),
         'imageStatus': 'Under Review',
         'categoryName': categoryData.name.toString(),
         'categoryCode': categoryData.code.toString(),
         'subCategoryName': subCategoryData.name.toString(),
         'subCategoryCode': subCategoryData.code.toString(),
         'imageTitle': title.toString(),
         'remarks': remark.toString(),
         'uploadedDate': currentDate.toString(),
         "latitude": locationData.lat != null ? locationData.lat.toString() : "0.0",
         "longitude": locationData.long != null ? locationData.long.toString(): "0.0",
       };

       json.addAll(list);

       var res =  await ServerRequest.postDataWithFile(urlEndPoint: url,
           body: json, context: !context.mounted ? context :context, fileList: imageList);
       if(res != null &&  res['message'] != null){
         SnackBarSuccessWidget(!context.mounted ? context :context).show(message: res['message'].toString());
         return res;
       }
     }catch(_) {}
     return null;
  }
}
