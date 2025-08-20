import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/createTask/domain/bloc/create_task_bloc.dart';
import 'package:flutter_gail/feature/task/createTask/domain/model/lineWalker_user_model.dart';
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
            // _shiftNameDropdown(dataState: dataState),
            // _shiftList(dataState: dataState),
            // Divider(color:  AppColor.lightGrey,),
            Align(
              alignment: Alignment.topLeft,
              child: TextWidget(AppString.walkerDetails+"*",
                fontWeight: FontWeight.w700,
                color: AppColor.themeColor,),
            ),
            _verticalSpace(),
            _repeatFrequencyDropdown(dataState: dataState),
            _verticalSpace(),
            // _startPatrollingDateController(dataState: dataState),
            // _verticalSpace(),
            // _endPatrollingDateController(dataState: dataState),
            // _verticalSpace(),
            _userTypeDropdown(dataState: dataState),
            _verticalSpace(),
            _supervisorUsersDropdown(dataState: dataState),
            _verticalSpace(),
            _lineWalkerUsersDropdown(dataState: dataState),
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
    return dataState.isMaintenanceLoader == false ?
    DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.maintenanceTypeData.name != null ? dataState.maintenanceTypeData : null,
      hint: AppString.maintenanceBase,
      items: dataState.maintenanceTypeList,
      itemAsString: (maintenanceTypeData) => maintenanceTypeData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskMaintenanceTypeEvent(maintenanceTypeData: value));
      },
    ) : const Align(
      alignment: Alignment.centerLeft,
      child: DottedLoaderWidget(),
    );
  }

  Widget _pipelineNameDropdown({required FetchCreateTaskDataState dataState}) {
    return dataState.isPipelineNameLoader == false ?
    DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.pipelineData.name != null ? dataState.pipelineData : null,
      hint: AppString.pipelineName,
      items: dataState.pipelineList,
      itemAsString: (pipelineData) => pipelineData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskPipelineTypeEvent(pipelineData: value));
      },
    ): const Align(
      alignment: Alignment.centerLeft,
      child: DottedLoaderWidget(),
    );
  }

  Widget _sectionNameDropdown({required FetchCreateTaskDataState dataState}) {
    return dataState.isSectionNameLoader == false ?
    DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.sectionData.name != null ? dataState.sectionData : null,
      hint: AppString.sectionName,
      items: dataState.sectionList,
      itemAsString: (sectionData) => sectionData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskSectionTypeEvent(sectionData: value));
      },
    ): const Align(
      alignment: Alignment.centerLeft,
      child: DottedLoaderWidget(),
    );
  }

  Widget _patrolRouteNameDropdown({required FetchCreateTaskDataState dataState}) {
    return dataState.isPatrolRouteNameLoader == false ?
    DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.routeData.name != null ? dataState.routeData : null,
      hint: AppString.patrolRouteName,
      items: dataState.routeList,
      itemAsString: (routeData) => routeData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskRouteEvent(routeData: value));
      },
    ): const Align(
      alignment: Alignment.centerLeft,
      child: DottedLoaderWidget(),
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

  Widget _repeatFrequencyDropdown({required FetchCreateTaskDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.repeatFrequencyData.name != null ? dataState.repeatFrequencyData : null,
      hint: AppString.repeatFrequency,
      items: dataState.repeatFrequencyList,
      itemAsString: (regionTypeData) => regionTypeData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskRepeatFrequencyEvent(repeatFrequencyData: value));
      },
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
            .add(CreateTaskUserTypeEvent(userTypeData: value, context: context));
      },
    );
  }

  Widget _supervisorUsersDropdown({required FetchCreateTaskDataState dataState}) {
    return dataState.isVendorLoader == false ?
    dataState.supervisorUsersList.isNotEmpty ?
    DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.supervisorUsersData.name != null ? dataState.supervisorUsersData : null,
      hint: AppString.supervisorUsers,
      items: dataState.supervisorUsersList,
      itemAsString: (supervisorUsersData) => supervisorUsersData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskSupervisorUserEvent(supervisorUserData: value));
      },
    ): const SizedBox.shrink() : const DottedLoaderWidget();
  }

  Widget _lineWalkerUsersDropdown({required FetchCreateTaskDataState dataState}) {
    return dataState.isUserNameLoader == false ?
    DropDownSearchMultiSelectWidget(
      selectedItem: dataState.lineWalkerUsersData,
      hint: AppString.lineWalkerUsers,
      items: dataState.lineWalkerUsersList,
      showSearchBox: true,
      compareFn: (item, selectedItem) =>
      item.name == selectedItem.name,
      itemAsString: (lineWalkerUsersData) => lineWalkerUsersData.name.toString(),
      onChanged: (value) {
        List<LineWalkerUsersModel> list = [];
        for(var data in value){
          list.add(data);
        }
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskLineWalkerUserEvent(lineWalkerUserData: list));
      },
    ) : const DottedLoaderWidget();
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
                    listIndex: index),
            ],
          ),
        );
      }),
    );
  }

  Widget _list({required List<ShiftTypeModel> shiftList, required int listIndex }) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: shiftList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Checkbox(
                    value: shiftList[index].isSelected,
                     onChanged: (value) {
                      print(shiftList[index].id);
                     BlocProvider.of<CreateTaskBloc>(context).add(
                      CreateTaskShiftGroupEvent(selectedValue: value!,
                          id:  int.parse(shiftList[index].id.toString()),
                          lastIndex: listIndex,
                          value : shiftList[index].name.toString()));
                  }),
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
