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
          APIs.getSubCategoryApi + "?CategoryCode=${categoryData.code}";
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
      required List<File> fileList}) async {
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

      if (sectionData.sectionCode == null || sectionData.sectionCode!.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please select a section");
        return false;
      }

      if (stationData.name == null) {
        SnackBarErrorWidget(context).show(message: "Please select station");
        return false;
      }

      if (categoryData.name == null) {
        SnackBarErrorWidget(context).show(message: "Please select a category");
        return false;
      }

      if (subCategoryData.name == null) {
        SnackBarErrorWidget(context)
            .show(message: "Please select a sub-category");
        return false;
      }

      if (fromChainage.isEmpty) {
        SnackBarErrorWidget(context)
            .show(message: "Please enter From Chainage");
        return false;
      }

      if (toChainage.isEmpty) {
        SnackBarErrorWidget(context).show(message: "Please enter To Chainage");
        return false;
      }

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
      required List<File> fileList}) async {
     try{

       String url = APIs.saveImageSharingApi;
       List<FileModel> imageList = [];
       int id = 1;
       if(fileList.isNotEmpty){
         for(var data in fileList){
           imageList.add(FileModel(
               name: data.path.split('/').last,
               file: data,
               keyName: "file-$id"));
           id++;
         }
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
         'fromChainage': fromChainage.toString(),
         'toChainage': toChainage.toString(),
         'imageStatus': 'Under Review',
         'categoryName': categoryData.name.toString(),
         'categoryCode': categoryData.code.toString(),
         'subCategoryName': subCategoryData.name.toString(),
         'subCategoryCode': subCategoryData.code.toString(),
         'imageTitle': title.toString(),
         'remarks': remark.toString(),
         'uploadedDate': currentDate.toString()
       };

       var body  =  {
         "imageSummary" : json.toString(),
       };
       var res =  await ServerRequest.postDataWithFile(urlEndPoint: url,
           body: body, context: !context.mounted ? context :context, fileList: imageList);
       if(res != null &&  res['message'] != null){
         SnackBarSuccessWidget(!context.mounted ? context :context).show(message: res['message'].toString());
         return res;
       }
     }catch(_) {}
     return null;
  }
}
