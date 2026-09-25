import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/bloc/add_tlp_survey_bloc.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class AddTlpSurveyFormNew extends StatelessWidget {
  final FetchAddTlpSurveyDataState dataState;
  const AddTlpSurveyFormNew({super.key, required this.dataState});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // ---- Original dropdowns
                _regionDropDown(context: context),
                _verticalSpace(context: context),

                _maintenanceBaseDropDown(context: context),
                _verticalSpace(context: context),

                _pipelineDropDown(context: context),
                _verticalSpace(context: context),

                _sectionDropDown(context: context),
                _verticalSpace(context: context),

                _sectionCodeField(),
                _verticalSpace(context: context),

                _yearField(context),
                _verticalSpace(context: context),

                _tlpTaskPeriodDropDown(context: context),
                _verticalSpace(context: context),

                _taskIdField(),
                _verticalSpace(context: context),

                _tlpNumberDropDown(context: context),
                _verticalSpace(context: context),

                _chainageKmField(),
                _verticalSpace(context: context),

                _locationDetailField(),
                _verticalSpace(context: context),

                _tlpTypeDropDown(context: context),
                _verticalSpace(context: context),

                _tlpConnectionDropDown(context: context),
                _verticalSpace(context: context),

                _tlpConnection1DropDown(context: context),
                _verticalSpace(context: context),

                // ---- PSP Reading (-mV)
                _pspOnField(context),
                _pspOffField(context),

                // ---- Casing PSP
                _casingPspOnField(context),
                _casingPspOffField(context),
                _casingIntegrityField(context),

                // ---- Foreign Pipeline PSP
                _foreignPspOnField(context),
                _foreignPspOffField(context),
                _dcInterferenceField(context),

                // ---- AC PSP
                _acPspVoltField(context),
                _acceptableAcPspVoltField(context),
                _soilResistivityField(context),

                // ---- Monitoring of Coupons
                _couponDcCurrentDensityField(context),
                _couponAcCurrentDensityField(context),
                _couponOnField(context),
                _couponOffField(context),

                // ---- IJ Reading
                _ijOnField(context),
                _ijOffField(context),
                _ijIntegrityField(context),
                _surgeDiverterField(context),

                // ---- Current Measurement
                _calibrationField(context),
                _mvAcrossTerminalField(context),
                _testStationCurrentField(context),

                // ---- Polarisation Cell
                _cellConditionField(context),
                _groundingResistanceField(context),
                _acCurrentDischargeField(context),

                // ---- Others
                _dateOfReadingField(context),
                _verticalSpace(context: context),
                _remarksField(context),
                _remarks2Field(context),
                _submit(context: context),
                _verticalSpace(context: context),
                _verticalSpace(context: context),
              ],
            ),
          ),
        ),
        // ✅ QR Scan FAB - Bottom Right
        Positioned(
          bottom: 30,
          right: 20,
          child: _buildQrScanFAB(context),
        ),
      ],
    );
  }

  // ========================================================================
  // ✅ QR SCAN FAB - WORKING VERSION
  // ========================================================================
  Widget _buildQrScanFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue
                .withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed:  () {
          context.read<AddTlpSurveyBloc>().add(
            ScanQrCodeEvent(
              context: context,
            ),
          );
        },
        backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
        foregroundColor: Colors.white,
        elevation: 6,
        tooltip: 'Scan QR Code',
        child: Icon(Icons.qr_code_scanner,
          size: 28,
        ),
      ),
    );
  }

  // ========================================================================
  // Dropdown Widgets
  // ========================================================================
  Widget _regionDropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem:
      dataState.regionData.name != null ? dataState.regionData : null,
      hint: AppString.region,
      items: dataState.regionList,
      itemAsString: (regionData) => regionData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<AddTlpSurveyBloc>(context)
            .add(SelectRegionEvent(regionData: value));
      },
    );
  }

  Widget _maintenanceBaseDropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.maintenanceBaseData.code != null
          ? dataState.maintenanceBaseData
          : null,
      hint: AppString.maintenanceBase,
      items: dataState.maintenanceBaseList,
      itemAsString: (item) => item.name,
      onChanged: (value) {
        BlocProvider.of<AddTlpSurveyBloc>(context)
            .add(SelectMaintenanceBaseEvent(maintenanceBaseData: value));
      },
    );
  }

  Widget _pipelineDropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem:
      dataState.pipelineData.id != null ? dataState.pipelineData : null,
      hint: AppString.pipeline,
      items: dataState.pipelineList,
      itemAsString: (item) => item.name,
      onChanged: (value) {
        BlocProvider.of<AddTlpSurveyBloc>(context)
            .add(SelectPipelineEvent(pipelineData: value));
      },
    );
  }

  Widget _sectionDropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem:
      dataState.sectionData.id != null ? dataState.sectionData : null,
      hint: AppString.sectionName,
      items: dataState.sectionList,
      itemAsString: (item) => item.name,
      onChanged: (value) {
        BlocProvider.of<AddTlpSurveyBloc>(context)
            .add(SelectSectionEvent(sectionData: value));
      },
    );
  }

  Widget _sectionCodeField() {
    return TextFieldWidget(
      labelText: "Section Code",
      controller: dataState.sectionCodeController,
      isRequired: true,
      enabled: false,
      textInputType: TextInputType.text,
    );
  }

  Widget _tlpTaskPeriodDropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.tlpTaskPeriodData.id != null
          ? dataState.tlpTaskPeriodData
          : null,
      hint: "Period",
      items: dataState.tlpTaslPeriodList,
      itemAsString: (item) => item.name,
      onChanged: (value) {
        BlocProvider.of<AddTlpSurveyBloc>(context)
            .add(SelectTlpTaskPeriodEvent(tlpTaskPeriodData: value));
      },
    );
  }

  Widget _tlpNumberDropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.tlpNumberData.station != null
          ? dataState.tlpNumberData
          : null,
      hint: "TLP NO.",
      items: dataState.tlpNumberList,
      itemAsString: (item) => item.assetId.toString(),
      onChanged: (value) {
        BlocProvider.of<AddTlpSurveyBloc>(context)
            .add(SelectTlpNumberEvent(tlpNumberData: value));
      },
    );
  }

  Widget _tlpTypeDropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem:
      dataState.tlpTypeData.id != null ? dataState.tlpTypeData : null,
      hint: "Type Of TLP",
      items: dataState.tlpTypeLIst,
      itemAsString: (item) => item.name,
      onChanged: (value) {
        BlocProvider.of<AddTlpSurveyBloc>(context)
            .add(SelectTlpTypeEvent(tlpTypeData: value));
      },
    );
  }

  Widget _tlpConnectionDropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.tlpConnectionData.id != null
          ? dataState.tlpConnectionData
          : null,
      hint: "Additional TLP Connection",
      items: dataState.tlpConnectionList,
      itemAsString: (item) => item.name,
      onChanged: (value) {
        BlocProvider.of<AddTlpSurveyBloc>(context)
            .add(SelectTlpConnectionEvent(tlpConnectionData: value));
      },
    );
  }

  Widget _tlpConnection1DropDown({required BuildContext context}) {
    return DropDownSearchWidget(
      isRequired: false,
      selectedItem: dataState.tlpConnection1Data.id != null
          ? dataState.tlpConnection1Data
          : null,
      hint: "Additional TLP Connection 1",
      items: dataState.tlpConnection1List,
      itemAsString: (item) => item.name,
      onChanged: (value) {
        BlocProvider.of<AddTlpSurveyBloc>(context)
            .add(SelectTlpConnection1Event(tlpConnection1Data: value));
      },
    );
  }

  // ========================================================================
  // Text Field Widgets
  // ========================================================================
  Widget _pspOnField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'PSP Reading (-mV) - ON',
          controller: dataState.pspOnController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _pspOffField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'PSP Reading (-mV) - OFF',
          controller: dataState.pspOffController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _casingPspOnField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Casing PSP ON (-mV)',
          controller: dataState.casingPspOnController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _casingPspOffField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Casing PSP OFF (-mV)',
          controller: dataState.casingPspOffController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _casingIntegrityField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Integrity of Casing & Carrier Pipe',
          controller: dataState.casingIntegrityController,
          isRequired: true,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _foreignPspOnField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Foreign PSP ON (-mV)',
          controller: dataState.foreignPspOnController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _foreignPspOffField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Foreign PSP OFF (-mV)',
          controller: dataState.foreignPspOffController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _dcInterferenceField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'DC Interference (Yes/No)',
          controller: dataState.dcInterferenceController,
          isRequired: true,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _acPspVoltField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'AC PSP (At HT Crossing/Parallel) Volts',
          controller: dataState.acPspVoltController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _acceptableAcPspVoltField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Acceptable AC PSP (Volts)',
          controller: dataState.acceptableAcPspVoltController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _soilResistivityField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Soil Resistivity (Ω·m)',
          controller: dataState.soilResistivityController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _couponDcCurrentDensityField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Coupon DC Current Density (A/m²)',
          controller: dataState.couponDcCurrentDensityController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _couponAcCurrentDensityField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Coupon AC Current Density (A/m²)',
          controller: dataState.couponAcCurrentDensityController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _couponOnField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Coupon ON PSP (-mV)',
          controller: dataState.couponOnController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _couponOffField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Coupon OFF PSP (-mV)',
          controller: dataState.couponOffController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _ijOnField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'IJ Reading (-mV) - ON',
          controller: dataState.ijOnController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _ijOffField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'IJ Reading (-mV) - OFF',
          controller: dataState.ijOffController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _ijIntegrityField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Integrity of IJ',
          controller: dataState.ijIntegrityController,
          isRequired: true,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _surgeDiverterField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Condition of Surge Diverter',
          controller: dataState.surgeDiverterConditionController,
          isRequired: true,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _acCurrentDischargeField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'AC Current Discharge (A)',
          controller: dataState.acCurrentDischargeController,
          isRequired: true,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _calibrationField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Calibration of the Span (One Time) (Amp / mV)',
          controller: dataState.calibrationController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _mvAcrossTerminalField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'mV across Two Terminals (with +/- sign)',
          controller: dataState.mvAcrossTerminalController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _testStationCurrentField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Magnitude of current (A) with direction',
          controller: dataState.testStationCurrentController,
          isRequired: true,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _cellConditionField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Physical Condition',
          controller: dataState.cellConditionController,
          isRequired: true,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _groundingResistanceField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Grounding Resistance in Ohms',
          controller: dataState.groundingResistanceController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _dateOfReadingField(BuildContext context) {
    return TextFieldWidget(
      labelText: "Date of Survey (dd-mm-yyyy)",
      controller: dataState.dateOfReadingController,
      enabled: false,
      onTap: () {
        BlocProvider.of<AddTlpSurveyBloc>(context).add(
          SelectDateReadingEvent(context: context),
        );
      },
      isRequired: true,
    );
  }

  Widget _remarksField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Remarks',
          controller: dataState.remarksController,
          isRequired: false,
          maxLine: 3,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _remarks2Field(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'Remarks 2',
          controller: dataState.remarks2Controller,
          isRequired: false,
          maxLine: 3,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _taskIdField() {
    return TextFieldWidget(
      labelText: "Task ID",
      controller: dataState.taskIdController,
      isRequired: true,
      enabled: false,
      textInputType: TextInputType.text,
    );
  }

  Widget _chainageKmField() {
    return TextFieldWidget(
      labelText: "Chainage (KM)",
      controller: dataState.chainageKMController,
      isRequired: true,
      enabled: false,
      textInputType: TextInputType.number,
    );
  }

  Widget _locationDetailField() {
    return TextFieldWidget(
      labelText: "Location Details",
      controller: dataState.locationDetaolController,
      isRequired: true,
      enabled: false,
      textInputType: TextInputType.text,
    );
  }

  Widget _yearField(BuildContext context) {
    return TextFieldWidget(
      labelText: "Year",
      controller: dataState.yearController,
      enabled: false,
      onTap: () {
        BlocProvider.of<AddTlpSurveyBloc>(context).add(
          SelectYearEvent(context: context),
        );
      },
      isRequired: true,
    );
  }

  Widget _submit({required BuildContext context}) {
    return dataState.isLoader == false
        ? ButtonWidget(
      text: AppString.submit,
      onPressed: () {
        BlocProvider.of<AddTlpSurveyBloc>(context)
            .add(SubmitTlpEvent(context: context));
      },
    )
        : const DottedLoaderWidget();
  }

  Widget _verticalSpace({required BuildContext context}) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.05,
    );
  }

  bool hasType(List<String> types) =>
      types.contains(dataState.allowedTLPType) ||
          types.contains(dataState.allowedTLPCondition);
}