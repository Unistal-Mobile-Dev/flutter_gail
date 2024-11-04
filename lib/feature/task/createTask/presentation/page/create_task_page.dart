import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/createTask/domain/bloc/create_task_bloc.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/repeat_frequency_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/shift_type_model.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/user_name_model.dart';
import 'package:flutter_gail/utils/commonWidgets/cupertino_date_picker_widget.dart';
import 'package:flutter_gail/utils/commonWidgets/cupertino_time_picker_widget.dart';
import 'package:flutter_gail/utils/commonWidgets/dropdown_multiselection_widget.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {

  @override
  void initState() {
    BlocProvider.of<CreateTaskBloc>(context)
        .add(CreateTaskPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget("Create Task",
          color: AppColor.white,
          fontSize: AppFont.font_16,
          fontWeight: FontWeight.w700,),
      ),
      body: BlocBuilder<CreateTaskBloc, CreateTaskState>(
        builder: (context, state) {
          if(state is FetchCreateTaskDataState) {
             return _itemBuilder(dataState: state);
          } else {
            return const Center(child: CenterLoaderWidget(),);
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchCreateTaskDataState dataState}) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _verticalSpace(),
            _regionDropdown(dataState: dataState),
            _verticalSpace(),
            _maintenanceBaseDropdown(dataState: dataState),
            _verticalSpace(),
            _pipelineNameDropdown(dataState: dataState),
            _verticalSpace(),
            _sectionNameDropdown(dataState: dataState),
            _verticalSpace(),
            _patrolRouteNameDropdown(dataState: dataState),
            _verticalSpace(),
            _patrolRouteLength(dataState: dataState),
            _verticalSpace(),
            _shiftNameDropdown(dataState: dataState),
            _shiftList(dataState: dataState),
            Divider(color:  AppColor.lightGrey,),
            Align(
              alignment: Alignment.topLeft,
              child: TextWidget(AppString.walkerDetails+"*",
                fontWeight: FontWeight.w700,
                color: AppColor.themeColor,),
            ),
            _verticalSpace(),
            _startPatrollingDateController(dataState: dataState),
            _verticalSpace(),
            _endPatrollingDateController(dataState: dataState),
            _verticalSpace(),
            _repeatFrequencyDropdown(dataState: dataState),
            _verticalSpace(),
            _userTypeDropdown(dataState: dataState),
            _verticalSpace(),
            _vendorDropdown(dataState: dataState),
            _verticalSpace(),
            _userNameDropdown(dataState: dataState),
            _verticalSpace(),
            _shiftTimeSetWidget(dataState: dataState),
            _verticalSpace(),
            _button(dataState: dataState),
            _verticalSpace(),
            _verticalSpace(),
          ],
        ),
      ),
    );
  }


  Widget _regionDropdown({required FetchCreateTaskDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.regionTypeData.name != null ? dataState.regionTypeData : null,
      hint: AppString.region,
      items: dataState.regionTypeList,
      itemAsString: (regionTypeData) => regionTypeData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskRegionEvent(regionTypeData: value));
      },
    );
  }

  Widget _maintenanceBaseDropdown({required FetchCreateTaskDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.maintenanceTypeData.name != null ? dataState.maintenanceTypeData : null,
      hint: AppString.maintenanceBase,
      items: dataState.maintenanceTypeList,
      itemAsString: (maintenanceTypeData) => maintenanceTypeData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskMaintenanceTypeEvent(maintenanceTypeData: value));
      },
    );
  }

  Widget _pipelineNameDropdown({required FetchCreateTaskDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.pipelineData.name != null ? dataState.pipelineData : null,
      hint: AppString.pipelineName,
      items: dataState.pipelineList,
      itemAsString: (pipelineData) => pipelineData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskPipelineTypeEvent(pipelineData: value));
      },
    );
  }

  Widget _sectionNameDropdown({required FetchCreateTaskDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.sectionData.name != null ? dataState.sectionData : null,
      hint: AppString.sectionName,
      items: dataState.sectionList,
      itemAsString: (sectionData) => sectionData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskSectionTypeEvent(sectionData: value));
      },
    );
  }

  Widget _patrolRouteNameDropdown({required FetchCreateTaskDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.routeData.name != null ? dataState.routeData : null,
      hint: AppString.patrolRouteName,
      items: dataState.routeList,
      itemAsString: (routeData) => routeData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskRouteEvent(routeData: value));
      },
    );
  }

  Widget _patrolRouteLength({required FetchCreateTaskDataState dataState}) {
    TextEditingController controller =  TextEditingController(
        text: dataState.routeData.length != null ? dataState.routeData.length.toString() : "" );
    return TextFieldWidget(
      isRequired: true,
      controller: controller,
      enabled: false,
      labelText: AppString.patrolRouteLength,
    );
  }


  Widget _shiftNameDropdown({required FetchCreateTaskDataState dataState}) {
    var seen = <String>{};
    List<ShiftTypeModel> shiftList = dataState.shiftList.where((shiftData) => seen.add(shiftData.sgCode.toString())).toList();
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.shiftData.name != null ? dataState.shiftData : null,
      hint: AppString.shiftGroup,
      items: shiftList,
      itemAsString: (shiftData) => shiftData.sgCode.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskSelectShitDataEvent(shiftData: value));
      },
    );
  }

  Widget _shiftList({required FetchCreateTaskDataState dataState }) {
    List<ShiftTypeModel> shiftList = [];
    for(var shiftData in dataState.shiftList){
      print(shiftData.sgCode.toString());
      if(dataState.shiftData.sgCode.toString() == shiftData.sgCode.toString()){
        shiftList.add(shiftData);
      }
    }
    return dataState.shiftData.sgCode != null ?
    Card(
      shadowColor: AppColor.themeColor,
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shiftList.length,
          itemBuilder: (context, index) {
             return Padding(
               padding: const EdgeInsets.all(10.0),
               child: Row(
                 children: [
                   TextWidget(dataState.shiftList[index].name.toString(), fontSize: AppFont.font_12,),
                   Expanded(child: TextWidget(" : ${dataState.shiftList[index].startTime.toString()} "
                       "- ${dataState.shiftList[index].endTime.toString()}", fontSize: AppFont.font_12,)),
                 ],
               ),
             );
      }),
    ) : const SizedBox.shrink();
  }

  Widget _repeatFrequencyDropdown({required FetchCreateTaskDataState dataState}) {
    return DropDownSearchMultiSelectWidget(
      selectedItem: dataState.repeatFrequencyData,
      hint: AppString.repeatFrequency,
      items: dataState.repeatFrequencyList,
      compareFn: (item, selectedItem) =>
      item.name == selectedItem.name,
      itemAsString: (repeatFrequencyData) => repeatFrequencyData.name.toString(),
      onChanged: (value) {
        List<RepeatFrequencyModel> list = [];
        for(var data in value){
          list.add(data);
        }

        List<RepeatFrequencyModel> tempList =   list.where((element) =>  element.id == "0").toList();
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskRepeatFrequencyEvent(
            repeatFrequencyData: tempList.isNotEmpty ? dataState.repeatFrequencyList : list));
      },
    );
  }


  Widget _startPatrollingDateController({required FetchCreateTaskDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      controller: dataState.startPatrollingDateController,
      labelText: AppString.patrollingStartDate,
      onTap: () => showCupertinoDatePickerWidgetDialog(
        context: context,
        child : CupertinoDatePickerWidget(
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime newDate) async {
            BlocProvider.of<CreateTaskBloc>(context)
                .add(CreateTaskStartPatrollingDateEvent(context: context, dateTime: newDate));
          },
        ),
      ),
    );
  }



  Widget _endPatrollingDateController({required FetchCreateTaskDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      controller: dataState.endPatrollingDateController,
      labelText: AppString.patrollingEndDate,
      onTap: () => showCupertinoDatePickerWidgetDialog(
        context: context,
        child : CupertinoDatePickerWidget(
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime newDate) async {
            BlocProvider.of<CreateTaskBloc>(context)
                .add(CreateTaskEndPatrollingDateEvent(context: context, dateTime: newDate));
          },
        ),
      ),
    );
  }

  Widget _userTypeDropdown({required FetchCreateTaskDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.userTypeData.name != null ? dataState.userTypeData : null,
      hint: AppString.userType,
      items: dataState.userTypeList,
      itemAsString: (userTypeData) => userTypeData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskUserTypeEvent(userTypeData: value));
      },
    );
  }

  Widget _vendorDropdown({required FetchCreateTaskDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.vendorData.name != null ? dataState.vendorData : null,
      hint: AppString.vendor,
      items: dataState.vendorList,
      itemAsString: (vendorData) => vendorData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskVendorEvent(vendorData: value));
      },
    );
  }

  Widget _userNameDropdown({required FetchCreateTaskDataState dataState}) {
    return DropDownSearchMultiSelectWidget(
      selectedItem: dataState.userNameData,
      hint: AppString.userName,
      items: dataState.userNameList,
      showSearchBox: true,
      compareFn: (item, selectedItem) =>
      item.name == selectedItem.name,
      itemAsString: (repeatFrequencyData) => repeatFrequencyData.name.toString(),
      onChanged: (value) {
        List<UserNameModel> list = [];
        for(var data in value){
          list.add(data);
        }
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskUserNameEvent(userNameData: list));
      },
    );
  }

  Widget _shiftTimeSetWidget({required FetchCreateTaskDataState dataState}) {
    return Card(
      shadowColor: AppColor.themeColor,
      elevation: 2,
      child: ListView.builder(
          itemCount: dataState.shiftGroupList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(dataState.shiftGroupList[index].userNameData!.name.toString(),
                  fontWeight: FontWeight.w700,),
                _list(shiftList: dataState.shiftGroupList[index].shiftList!,
                    selectedValue: dataState.shiftGroupList[index].selectedValue.toString(),
                    listIndex: index),
            ],
          ),
        );
      }),
    );
  }

  Widget _list({required List<ShiftTypeModel> shiftList,
    required String selectedValue, required int listIndex }) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: shiftList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Radio(
                    value: shiftList[index].name.toString(),
                    groupValue: selectedValue,
                    onChanged: (value) {
                      BlocProvider.of<CreateTaskBloc>(context).add(
                          CreateTaskShiftGroupEvent(selectedValue: value.toString(), index: listIndex));
                      }
                    ),
                TextWidget(shiftList[index].name.toString(), fontSize: AppFont.font_12,),
                Expanded(child: TextWidget(" : ${shiftList[index].startTime.toString()} "
                    "- ${shiftList[index].endTime.toString()}", fontSize: AppFont.font_12,)),
              ],
            ),
          );
        });
  }

  Widget _button({required FetchCreateTaskDataState dataState}) {
    return dataState.isLoader == false ?
    ButtonWidget(
        text: AppString.submit,
        onPressed: () {
          BlocProvider.of<CreateTaskBloc>(context)
          .add(CreateTaskSubmitEvent(context: context));
        }
    ) : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
       height: MediaQuery.of(context).size.width * 0.05
    );
  }

}
