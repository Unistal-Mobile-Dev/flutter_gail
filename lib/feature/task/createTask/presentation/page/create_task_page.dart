import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/createTask/domain/bloc/create_task_bloc.dart';
import 'package:flutter_gail/utils/commonWidgets/cupertino_date_picker_widget.dart';
import 'package:flutter_gail/utils/commonWidgets/cupertino_time_picker_widget.dart';

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
            _lineNameDropdown(dataState: dataState),
            _verticalSpace(),
            _lineLength(dataState: dataState),
            _verticalSpace(),
            _startPatrollingDateController(dataState: dataState),
            _verticalSpace(),
            _startPatrollingTimeController(dataState: dataState),
            _verticalSpace(),
            _endPatrollingDateController(dataState: dataState),
            _verticalSpace(),
            _endPatrollingTimeController(dataState: dataState),
            _verticalSpace(),
            _shiftNameDropdown(dataState: dataState),
            _verticalSpace(),
            _shitStart(dataState: dataState),
            _verticalSpace(),
            _shitEnd(dataState: dataState),
            _verticalSpace(),
            _taskDate(dataState: dataState),
            _verticalSpace(),
            _button(dataState: dataState),
            _verticalSpace(),
          ],
        ),
      ),
    );
  }

  Widget _lineNameDropdown({required FetchCreateTaskDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.lineData.name != null ? dataState.lineData : null,
      hint: AppString.lineName,
      items: dataState.lineList,
      itemAsString: (lineData) => lineData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskSelectLineDataEvent(lineData: value));
      },
    );
  }

  Widget _lineLength({required FetchCreateTaskDataState dataState}) {
    TextEditingController controller =  TextEditingController(
        text: dataState.lineData.length != null ? dataState.lineData.length.toString() : "" );
    return TextFieldWidget(
        isRequired: true,
        controller: controller,
        enabled: false,
        labelText: AppString.lineLength,
    );
  }

  Widget _startPatrollingDateController({required FetchCreateTaskDataState dataState}) {
    return TextFieldWidget(
        enabled: false,
        isRequired: true,
        controller: dataState.startPatrollingDateController,
        labelText: AppString.startPatrollingDate,
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

  Widget _startPatrollingTimeController({required FetchCreateTaskDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      controller: dataState.startPatrollingTimeController,
      labelText: AppString.startPatrollingTime,
      onTap: () => showCupertinoDatePickerWidgetDialog(
        context: context,
        child : CupertinoTimePickerWidget(
          initialDateTime: Duration(hours: DateTime.now().hour,
              minutes: DateTime.now().minute, seconds:  DateTime.now().second),
          onDateTimeChanged: (Duration duration) async {
            BlocProvider.of<CreateTaskBloc>(context)
                .add(CreateTaskStartPatrollingTimeEvent(context: context, duration: duration));
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
      labelText: AppString.endPatrollingDate,
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

  Widget _endPatrollingTimeController({required FetchCreateTaskDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      controller: dataState.endPatrollingTimeController,
      labelText: AppString.endPatrollingTime,
      onTap: () => showCupertinoDatePickerWidgetDialog(
        context: context,
        child : CupertinoTimePickerWidget(
          initialDateTime: Duration(hours: DateTime.now().hour,
              minutes: DateTime.now().minute, seconds:  DateTime.now().second),
          onDateTimeChanged: (Duration duration) async {
            BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskEndPatrollingTimeEvent(context: context, duration: duration));
          },
        ),
      ),
    );
  }

  Widget _shiftNameDropdown({required FetchCreateTaskDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.shiftData.name != null ? dataState.shiftData : null,
      hint: AppString.shiftName,
      items: dataState.shiftList,
      itemAsString: (shiftData) => shiftData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<CreateTaskBloc>(context)
            .add(CreateTaskSelectShitDataEvent(shiftData: value));
      },
    );
  }

  Widget _shitStart({required FetchCreateTaskDataState dataState}) {
    TextEditingController controller =  TextEditingController(
        text: dataState.shiftData.startTime != null ? dataState.shiftData.startTime.toString() : "" );
    return TextFieldWidget(
      isRequired: true,
      controller: controller,
      enabled: false,
      labelText: AppString.shiftStart,
    );
  }

  Widget _shitEnd({required FetchCreateTaskDataState dataState}) {
    TextEditingController controller =  TextEditingController(
        text: dataState.shiftData.endTime != null ? dataState.shiftData.endTime.toString() : "" );
    return TextFieldWidget(
      isRequired: true,
      controller: controller,
      enabled: false,
      labelText: AppString.shiftEnd,
    );
  }

  Widget _taskDate({required FetchCreateTaskDataState dataState}) {
    return TextFieldWidget(
      enabled: false,
      isRequired: true,
      controller: dataState.taskDateController,
      labelText: AppString.taskDate,
      onTap: () => showCupertinoDatePickerWidgetDialog(
        context: context,
        child : CupertinoDatePickerWidget(
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime newDate) async {
            BlocProvider.of<CreateTaskBloc>(context)
                .add(CreateTaskDateEvent(context: context, dateTime: newDate));
          },
        ),
      ),
    );
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
