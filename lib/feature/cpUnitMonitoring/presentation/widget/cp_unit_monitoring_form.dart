import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/domain/bloc/cp_unit_monitoring_bloc.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/domain/model/cp_option_model.dart';

class CpUnitMonitoringForm extends StatelessWidget {
  final FetchCpUnitMonitoringDataState dataState;
  const CpUnitMonitoringForm({super.key, required this.dataState});

  static const TextInputType _readingInputType =
      TextInputType.numberWithOptions(signed: true, decimal: true);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Task selection
            _dropDown(
              context: context,
              hint: AppString.region,
              items: dataState.regionList,
              selectedItem: dataState.regionData,
              isRequired: true,
              onChanged: (value) => CpSelectRegionEvent(regionData: value),
            ),
            _dropDown(
              context: context,
              hint: AppString.maintenanceBase,
              items: dataState.maintenanceBaseList,
              selectedItem: dataState.maintenanceBaseData,
              isRequired: true,
              isLoading: dataState.isMaintenanceBaseLoader,
              onChanged: (value) => CpSelectMaintenanceBaseEvent(maintenanceBaseData: value),
            ),
            _dropDown(
              context: context,
              hint: AppString.pipeline,
              items: dataState.pipelineList,
              selectedItem: dataState.pipelineData,
              isRequired: true,
              isLoading: dataState.isPipelineLoader,
              onChanged: (value) => CpSelectPipelineEvent(pipelineData: value),
            ),
            _dropDown(
              context: context,
              hint: "Section",
              items: dataState.sectionList,
              selectedItem: dataState.sectionData,
              isRequired: true,
              isLoading: dataState.isSectionLoader,
              onChanged: (value) => CpSelectSectionEvent(sectionData: value),
            ),
            _dropDown(
              context: context,
              hint: "Year",
              items: dataState.yearList,
              selectedItem: dataState.yearData,
              isRequired: true,
              onChanged: (value) => CpSelectYearEvent(yearData: value),
            ),
            _dropDown(
              context: context,
              hint: "Month",
              items: dataState.monthList,
              selectedItem: dataState.monthData,
              isRequired: true,
              onChanged: (value) => CpSelectMonthEvent(monthData: value),
            ),
            dataState.isTaskIdLoader
                ? const Align(alignment: Alignment.centerLeft, child: DottedLoaderWidget())
                : _textField(
                    context: context,
                    label: "Task",
                    controller: dataState.taskIdController,
                    enabled: false,
                    isRequired: true,
                  ),

            const Divider(height: 30),

            // Inspection details
            _dropDown(
              context: context,
              hint: "Rectifier",
              items: dataState.rectifierList,
              selectedItem: dataState.rectifierData,
              isRequired: true,
              isLoading: dataState.isRectifierLoader,
              onChanged: (value) => CpSelectRectifierEvent(rectifierData: value),
            ),
            _textField(
              context: context,
              label: "Chainage (m)",
              controller: dataState.chainageController,
              // Comes from the selected rectifier, not editable
              enabled: false,
            ),
            _dropDown(
              context: context,
              hint: "Operating Mode",
              items: dataState.operatingModeList,
              selectedItem: dataState.operatingModeData,
              onChanged: (value) => CpSelectOperatingModeEvent(operatingModeData: value),
            ),
            _textField(
              context: context,
              label: "Inspected By",
              controller: dataState.inspectedByController,
            ),
            _textField(
              context: context,
              label: "Inspection Date",
              controller: dataState.inspectionDateController,
              enabled: false,
              isRequired: true,
              suffixIcon: const Icon(Icons.calendar_month),
              onTap: () {
                BlocProvider.of<CpUnitMonitoringBloc>(context)
                    .add(CpSelectInspectionDateEvent(context: context));
              },
            ),
            _textField(
              context: context,
              label: "PSP (V)",
              controller: dataState.pspController,
              textInputType: _readingInputType,
            ),
            _dropDown(
              context: context,
              hint: "On/Off Status",
              items: dataState.onOffStatusList,
              selectedItem: dataState.onOffStatusData,
              onChanged: (value) => CpSelectOnOffStatusEvent(onOffStatusData: value),
            ),
            _textField(
              context: context,
              label: "AC Voltage In (V)",
              controller: dataState.acVoltageInController,
              textInputType: _readingInputType,
            ),
            _textField(
              context: context,
              label: "AC Current In (A)",
              controller: dataState.acCurrentInController,
              textInputType: _readingInputType,
            ),
            _textField(
              context: context,
              label: "DC Current Out (A)",
              controller: dataState.dcCurrentOutController,
              textInputType: _readingInputType,
            ),
            _textField(
              context: context,
              label: "Target Internal PSP (mV)",
              controller: dataState.targetInternalPspController,
              textInputType: _readingInputType,
            ),
            _textField(
              context: context,
              label: "PSP at reference Cell 1",
              controller: dataState.pspReferenceCell1Controller,
              textInputType: _readingInputType,
            ),
            _textField(
              context: context,
              label: "PSP at reference Cell 2",
              controller: dataState.pspReferenceCell2Controller,
              textInputType: _readingInputType,
            ),
            _textField(
              context: context,
              label: "PSP at reference Cell 3",
              controller: dataState.pspReferenceCell3Controller,
              textInputType: _readingInputType,
            ),
            _textField(
              context: context,
              label: "Controlling at reference Cell",
              controller: dataState.controllingReferenceCellController,
            ),
            _textField(
              context: context,
              label: "PSP Nearest (V)",
              controller: dataState.pspNearestController,
              textInputType: _readingInputType,
            ),
            _textField(
              context: context,
              label: "Percentage Power Availability %",
              controller: dataState.powerAvailabilityController,
              textInputType: _readingInputType,
            ),
            _dropDown(
              context: context,
              hint: "Rectifier Health",
              items: dataState.rectifierHealthList,
              selectedItem: dataState.rectifierHealthData,
              onChanged: (value) => CpSelectRectifierHealthEvent(rectifierHealthData: value),
            ),
            _textField(
              context: context,
              label: "Remarks",
              controller: dataState.remarksController,
              maxLine: 3,
            ),
            _submit(context: context),
            _verticalSpace(context: context),
            _verticalSpace(context: context),
          ],
        ),
      ),
    );
  }

  Widget _dropDown({
    required BuildContext context,
    required String hint,
    required List<CpOptionModel> items,
    required CpOptionModel selectedItem,
    required CpUnitMonitoringEvent Function(CpOptionModel value) onChanged,
    bool isRequired = false,
    bool isLoading = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.04),
      child: isLoading
          ? const Align(alignment: Alignment.centerLeft, child: DottedLoaderWidget())
          : DropDownSearchWidget(
              isRequired: isRequired,
              selectedItem: selectedItem.id != null ? selectedItem : null,
              hint: hint,
              items: items,
              itemAsString: (item) => item.name.toString(),
              onChanged: (value) {
                if (value == null) return;
                BlocProvider.of<CpUnitMonitoringBloc>(context).add(onChanged(value));
              },
            ),
    );
  }

  Widget _textField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    TextInputType? textInputType,
    bool enabled = true,
    bool isRequired = false,
    int? maxLine,
    Widget? suffixIcon,
    GestureTapCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.04),
      child: TextFieldWidget(
        labelText: label,
        controller: controller,
        textInputType: textInputType,
        enabled: enabled,
        isRequired: isRequired,
        maxLine: maxLine,
        suffixIcon: suffixIcon,
        onTap: onTap,
      ),
    );
  }

  Widget _submit({required BuildContext context}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: "Submit Inspection",
            onPressed: () {
              BlocProvider.of<CpUnitMonitoringBloc>(context)
                  .add(CpSubmitInspectionEvent(context: context));
            },
          )
        : const DottedLoaderWidget();
  }

  Widget _verticalSpace({required BuildContext context}) {
    return SizedBox(height: MediaQuery.of(context).size.width * 0.05);
  }
}
