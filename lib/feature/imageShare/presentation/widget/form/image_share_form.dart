import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/imageShare/domain/bloc/image_share_bloc.dart';

class ImageShareForm extends StatelessWidget {
  final FetchImageShareDataState dataState;

  const ImageShareForm({
    super.key,
    required this.dataState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _verticalSpace(context: context),
        _regionDropDown(context: context),
        _verticalSpace(context: context),
        _maintenanceBaseDropDown(context: context),
        _verticalSpace(context: context),
        _pipelineDropDown(context: context),
        _verticalSpace(context: context),
        _stationDropDown(context: context),
        _verticalSpace(context: context),
        _sectionDropDown(context: context),
        _verticalSpace(context: context),
        _sectionNameController(),
        _verticalSpace(context: context),
        _fromChainageController(),
        _verticalSpace(context: context),
        _categoryDropDown(context: context),
        _verticalSpace(context: context),
        _subCategoryDropDown(context: context),
        _verticalSpace(context: context),
        _titleController(),
        _verticalSpace(context: context),
        _remarkController(),
        _verticalSpace(context: context),
        _imageWidget(context: context),
        _verticalSpace(context: context),
        _fileListWidget(context: context),
        _verticalSpace(context: context),
        _buttonWidget(context: context),
        _verticalSpace(context: context),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _regionDropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem:
      dataState.regionData.name != null ? dataState.regionData : null,
      hint: AppString.region,
      items: dataState.regionList,
      itemAsString: (regionData) => regionData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<ImageShareBloc>(context)
            .add(SelectRegionEvent(regionData: value));
      },
    );
  }

  Widget _maintenanceBaseDropDown({required BuildContext context}) {
    return dataState.isMaintenanceLoader == false
        ? DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.maintenanceBaseData.name != null
          ? dataState.maintenanceBaseData
          : null,
      hint: AppString.maintenanceBase,
      items: dataState.maintenanceBaseList,
      itemAsString: (maintenanceBaseData) =>
          maintenanceBaseData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<ImageShareBloc>(context)
            .add(SelectMaintenanceBaseEvent(maintenanceBaseData: value));
      },
    )
        : const DottedLoaderWidget();
  }

  Widget _pipelineDropDown({required BuildContext context}) {
    return dataState.isPipelineLoader == false
        ? DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.pipelineData.pipelineCode != null
          ? dataState.pipelineData
          : null,
      hint: AppString.pipeline,
      items: dataState.pipelineList,
      itemAsString: (pipelineData) =>
      "${pipelineData.pipelineCode.toString()}-${pipelineData.pipelineName
          .toString()}",
      onChanged: (value) {
        BlocProvider.of<ImageShareBloc>(context)
            .add(
            SelectPipelineEvent(pipelineImageShareData: value)); // pipelineName
      },
    )
        : const DottedLoaderWidget();
  }

  Widget _stationDropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: false,
      selectedItem:
      dataState.stationData.name != null ? dataState.stationData : null,
      hint: AppString.stationName,
      items: dataState.stationList,
      itemAsString: (stationData) => stationData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<ImageShareBloc>(context)
            .add(SelectStationEvent(stationData: value));
      },
    );
  }

  Widget _sectionDropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: false,
      selectedItem: dataState.sectionData.sectionName != null
          ? dataState.sectionData
          : null,
      hint: AppString.sections,
      items: dataState.sectionList,
      itemAsString: (sectionData) => sectionData.sectionName.toString(),
      onChanged: (value) {
        BlocProvider.of<ImageShareBloc>(context)
            .add(SelectSectionEvent(sectionData: value));
      },
    );
  }

  Widget _sectionNameController() {
    TextEditingController controller = TextEditingController(
        text: dataState.sectionData.sectionName != null ? dataState.sectionData.sectionLength.
        toString() : "");
    return TextFieldWidget(
    labelText: AppString.sectionLength,
    controller: controller,
    enabled: false );
    }

  Widget _fromChainageController() {
    return TextFieldWidget(
      labelText: AppString.chainage,
      controller: dataState.fromChainageController,
      textInputType: TextInputType.number,
    );
  }

  Widget _toChainageController() {
    return TextFieldWidget(
      labelText: AppString.toChainagem,
      controller: dataState.toChainageController,
      isRequired: true,
      enabled: false,
    );
  }

  Widget _categoryDropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem:
      dataState.categoryData.name != null ? dataState.categoryData : null,
      hint: AppString.categoryName,
      items: dataState.categoryList,
      itemAsString: (categoryData) => categoryData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<ImageShareBloc>(context)
            .add(SelectCategoryEvent(categoryData: value));
      },
    );
  }

  Widget _subCategoryDropDown({required BuildContext context}) {
    return dataState.isSubCategoryLoader == false ?
    DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.subCategoryData.name != null
          ? dataState.subCategoryData
          : null,
      hint: AppString.subCategoryName,
      items: dataState.subCategoryList,
      itemAsString: (subCategoryData) => subCategoryData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<ImageShareBloc>(context)
            .add(SelectSubcategoryEvent(subCategoryData: value));
      },
    ) : const DottedLoaderWidget();
  }

  Widget _titleController() {
    return TextFieldWidget(
      labelText: AppString.title,
      controller: dataState.titleController,
      isRequired: true,
    );
  }

  Widget _remarkController() {
    return TextFieldWidget(
      labelText: AppString.remark,
      controller: dataState.remarkController,
    );
  }

  Widget _buttonWidget({required BuildContext context}) {
    return dataState.isLoader == false
        ? ButtonWidget(
        text: AppString.submit,
        onPressed: () {
          BlocProvider.of<ImageShareBloc>(context)
              .add(ImageShareSubmitEvent(context: context));
        })
        : const DottedLoaderWidget();
  }

  Widget _imageWidget({required BuildContext context}) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width / 4,
      child: DottedBorder(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: dataState.isFileLoader == false ?
            IconButton(
                onPressed: () {
                  BlocProvider.of<ImageShareBloc>(context).add(
                      ImageShareSelectFileEvent(
                          context: context, mediaType: 1));
                  // mediaType(
                  //     context: context,
                  //     onPressedCamera: () {
                  //       Navigator.pop(context);
                  //       BlocProvider.of<ImageShareBloc>(context).add(
                  //           ImageShareSelectFileEvent(
                  //               context: context, mediaType: 1));
                  //     },
                  //     onPressedGallery: () {
                  //       Navigator.pop(context);
                  //       BlocProvider.of<ImageShareBloc>(context).add(
                  //           ImageShareSelectFileEvent(
                  //               context: context, mediaType: 2));
                  //     });
                },
                icon: Icon(
                  Icons.image_outlined,
                  color: AppColor.lightGrey,
                )) : const DottedLoaderWidget(),
          ),
        ),
      ),
    );
  }

  Widget _fileListWidget({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dataState.fileList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Number of columns
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width / 4,
            height: MediaQuery
                .of(context)
                .size
                .width / 4,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    dataState.fileList[index].file,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<ImageShareBloc>(context)
                          .add(ImageShareDeleteFileEvent(index: index));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _verticalSpace({required BuildContext context}) {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .width * 0.05);
  }
}
