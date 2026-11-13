import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/domain/model/cp_option_model.dart';
import 'package:flutter_gail/feature/pspMonitoring/domain/bloc/psp_monitoring_bloc.dart';
import 'package:flutter_gail/feature/pspMonitoring/domain/model/psp_field_model.dart';

class PspMonitoringForm extends StatelessWidget {
  final FetchPspMonitoringDataState dataState;
  const PspMonitoringForm({super.key, required this.dataState});

  /// Readings are numbers and can be negative
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
              onChanged: (value) => PspSelectRegionEvent(regionData: value),
            ),
            _dropDown(
              context: context,
              hint: AppString.maintenanceBase,
              items: dataState.maintenanceBaseList,
              selectedItem: dataState.maintenanceBaseData,
              isRequired: true,
              isLoading: dataState.isMaintenanceBaseLoader,
              onChanged: (value) => PspSelectMaintenanceBaseEvent(maintenanceBaseData: value),
            ),
            _dropDown(
              context: context,
              hint: AppString.pipeline,
              items: dataState.pipelineList,
              selectedItem: dataState.pipelineData,
              isRequired: true,
              isLoading: dataState.isPipelineLoader,
              onChanged: (value) => PspSelectPipelineEvent(pipelineData: value),
            ),
            _dropDown(
              context: context,
              hint: "Section",
              items: dataState.sectionList,
              selectedItem: dataState.sectionData,
              isRequired: true,
              isLoading: dataState.isSectionLoader,
              onChanged: (value) => PspSelectSectionEvent(sectionData: value),
            ),
            _dropDown(
              context: context,
              hint: "Year",
              items: dataState.yearList,
              selectedItem: dataState.yearData,
              isRequired: true,
              onChanged: (value) => PspSelectYearEvent(yearData: value),
            ),
            _dropDown(
              context: context,
              hint: "Month",
              items: dataState.monthList,
              selectedItem: dataState.monthData,
              isRequired: true,
              onChanged: (value) => PspSelectMonthEvent(monthData: value),
            ),
            dataState.isTaskLoader
                ? _loader(context: context)
                : _textField(
                    context: context,
                    label: "Task",
                    controller: dataState.taskController,
                    enabled: false,
                    isRequired: true,
                  ),

            const Divider(height: 30),

            // TLP details
            _dropDown(
              context: context,
              hint: "TLP No",
              items: dataState.tlpNumberList,
              selectedItem: dataState.tlpNumberData,
              isRequired: true,
              isLoading: dataState.isTlpNumberLoader,
              onChanged: (value) => PspSelectTlpNumberEvent(tlpNumberData: value),
            ),
            _textField(
              context: context,
              label: "Chainage (m)",
              controller: dataState.chainageController,
              enabled: false,
            ),
            _textField(
              context: context,
              label: "Location Details",
              controller: dataState.locationDetailsController,
              enabled: false,
            ),
            _dropDown(
              context: context,
              hint: "Type Of TLP",
              items: dataState.tlpTypeList,
              selectedItem: dataState.tlpTypeData,
              isRequired: true,
              onChanged: (value) => PspSelectTlpTypeEvent(tlpTypeData: value),
            ),
            _dropDown(
              context: context,
              hint: "Additional TLP Connection",
              items: dataState.additionalTlpConnectionList,
              selectedItem: dataState.additionalTlpConnectionData,
              onChanged: (value) =>
                  PspSelectAdditionalTlpConnectionEvent(additionalTlpConnectionData: value),
            ),

            _textField(
              context: context,
              label: "Magnesium Anode Reading (-mV)",
              controller: dataState.magnesiumAnodeReadingController,
              textInputType: _readingInputType,
            ),

            // Dynamic reading fields (based on Type Of TLP + Additional TLP Connection)
            if (dataState.isFieldLoader)
              _loader(context: context)
            else
              ...dataState.fieldList.map((field) => _dynamicField(context: context, field: field)),

            _textField(
              context: context,
              label: "Date of Reading",
              controller: dataState.dateOfReadingController,
              enabled: false,
              isRequired: true,
              suffixIcon: const Icon(Icons.calendar_month),
              onTap: () {
                BlocProvider.of<PspMonitoringBloc>(context)
                    .add(PspSelectDateOfReadingEvent(context: context));
              },
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

  /// field_type 3 = dropdown, field_type 1 = input field
  Widget _dynamicField({required BuildContext context, required PspFieldModel field}) {
    if (field.isDropdown) {
      return _dropDown(
        key: ValueKey("dropdown_${field.slug}"),
        context: context,
        hint: field.name,
        items: field.options,
        selectedItem: dataState.fieldOptionValues[field.slug] ?? CpOptionModel(),
        onChanged: (value) => PspSelectFieldOptionEvent(slug: field.slug, optionData: value),
      );
    }
    return _textField(
      key: ValueKey("input_${field.slug}"),
      context: context,
      label: field.name,
      controller: dataState.fieldControllers[field.slug]!,
      textInputType: _readingInputType,
    );
  }

  Widget _dropDown({
    Key? key,
    required BuildContext context,
    required String hint,
    required List<CpOptionModel> items,
    required CpOptionModel selectedItem,
    required PspMonitoringEvent Function(CpOptionModel value) onChanged,
    bool isRequired = false,
    bool isLoading = false,
  }) {
    return Padding(
      key: key,
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
                BlocProvider.of<PspMonitoringBloc>(context).add(onChanged(value));
              },
            ),
    );
  }

  Widget _textField({
    Key? key,
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
      key: key,
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

  Widget _loader({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.04),
      child: const Align(alignment: Alignment.centerLeft, child: DottedLoaderWidget()),
    );
  }

  Widget _submit({required BuildContext context}) {
    return dataState.isLoader == false
        ? ButtonWidget(
            text: "Submit Inspection",
            onPressed: () {
              BlocProvider.of<PspMonitoringBloc>(context)
                  .add(PspSubmitInspectionEvent(context: context));
            },
          )
        : const DottedLoaderWidget();
  }

  Widget _verticalSpace({required BuildContext context}) {
    return SizedBox(height: MediaQuery.of(context).size.width * 0.05);
  }
}
