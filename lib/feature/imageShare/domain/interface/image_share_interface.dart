import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/dashboard/domain/model/file_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/category_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/maintenance_base_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/pipeline_image_share_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/section_imgae_share_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/station_model.dart';
import 'package:flutter_gail/feature/imageShare/domain/model/sub_category_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/region_type_model.dart';

abstract class ImageShareInterface {

  Future<dynamic> fetchRegionType();
  Future<dynamic> fetchMaintenanceBaseType({required RegionTypeModel regionData});
  Future<dynamic> fetchPipelineType({required MaintenanceBaseModel maintenanceBaseModel});
  Future<dynamic> fetchCategoryType();
  Future<dynamic> fetchSubCategoryType({required CategoryModel categoryData});
  Future<dynamic> textFieldValidationCheck({required BuildContext context,
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
    required List<FileModel> fileList,
  });

  Future<dynamic> submit({required BuildContext context,
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
    required List<FileModel> fileList,
  });

}