import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/bloc/add_tlp_survey_bloc.dart';
import 'package:flutter_gail/utils/commonWidgets/dropdown_search_widget.dart';
import 'package:flutter_gail/utils/res/app_string.dart';

class AddTlpSurveyForm extends StatelessWidget {
  final FetchAddTlpSurveyDataState dataState;
  const AddTlpSurveyForm({super.key, required this.dataState});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [

            // Dropdowns
            _regionDropDown(context: context),
            _verticalSpace(context: context),

            _maintenanceBaseDropDown(context: context),
            _verticalSpace(context: context),

            _pipelineDropDown(context: context),
            _verticalSpace(context: context),

            _sectionDropDown(context: context),
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

            // PSP Reading (-mV)
            _pspOnField(context),
            _pspOffField(context),

            // Casing PSP
            _casingPspOnField(context),
            _casingPspOffField(context),
            _casingIntegrityField(context),

            // Foreign Pipeline PSP
            _foreignPspOnField(context),
            _foreignPspOffField(context),

            // AC PSP
            _acPspVoltField(context),

            // IJ Reading
            _ijOnField(context),
            _ijOffField(context),
            _ijIntegrityField(context),

            // Surge Diverter
            _surgeDiverterField(context),
            _acCurrentDischarge(context),

            // PSP Polarisation Coupon
            _couponOnField(context),
            _couponOffField(context),

            // Current Measurement
            _calibrationField(context),
            _mvAcrossTerminalField(context),
            _testStationCurrentField(context),

            // Polarisation Cell
            _cellConditionField(context),
            _groundingResistanceField(context),

            // Others
            _dateOfReadingField(context),
            _verticalSpace(context: context),
            _remarksField(context),
            _submit(context: context),
            _verticalSpace(context: context),
            _verticalSpace(context: context),
          ],
        ),
      ),
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
      selectedItem: dataState.pipelineData.id != null ? dataState.pipelineData : null,
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
      selectedItem: dataState.sectionData.id != null ? dataState.sectionData : null,
      hint: AppString.sectionName,
      items: dataState.sectionList,
      itemAsString: (item) => item.name,
      onChanged: (value) {
        BlocProvider.of<AddTlpSurveyBloc>(context)
            .add(SelectSectionEvent(sectionData: value));
      },
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
      selectedItem: dataState.tlpNumberData.station != null ? dataState.tlpNumberData : null,
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
      selectedItem: dataState.tlpTypeData.id != null ? dataState.tlpTypeData : null,
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

// PSP Reading (-mV)
  Widget _pspOnField(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          labelText: 'PSP Reading (-mv) - ON',
          controller: dataState.pspOnController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

  Widget _pspOffField(BuildContext context) {
    return  Column(
      children: [
        TextFieldWidget(
          labelText: 'PSP Reading (-mv) - OFF',
          controller: dataState.pspOffController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    );
  }

// Casing PSP (-mV)
  Widget _casingPspOnField(BuildContext context) {
    return hasType(['C','D'])
        ? Column(
          children: [
            TextFieldWidget(
                  labelText: 'Casing PSP ON (-mV)',
                  controller: dataState.casingPspOnController,
                  isRequired: true,
                  textInputType: TextInputType.number,
                ),
            _verticalSpace(context: context)
          ],
        ) : const SizedBox.shrink();
  }

  Widget _casingPspOffField(BuildContext context) {
    return  hasType(['C','D'])
        ? Column(
          children: [
            TextFieldWidget(
                  labelText: 'Casing PSP OFF (-mV)',
                  controller: dataState.casingPspOffController,
                  isRequired: true,
                  textInputType: TextInputType.number,
                ),
            _verticalSpace(context: context),
          ],
        ) : const SizedBox.shrink();
  }

// Integrity of Casing & Carrier Pipe
  Widget _casingIntegrityField(BuildContext context) {
    return hasType(['C','D','F', 'I'])
        ?  Column(
          children: [
            TextFieldWidget(
                  labelText: 'Integrity of Casing & Carrier Pipe',
                  controller: dataState.casingIntegrityController,
                  isRequired: true,
                ),
            _verticalSpace(context: context),
          ],
        ) : const SizedBox.shrink();
  }

// Foreign Pipeline PSP (-mV)
  Widget _foreignPspOnField(BuildContext context) {
    return  hasType(['A','C','D', 'I'])
        ?  Column(
          children: [
            TextFieldWidget(
                  labelText: 'Foreign PSP ON (-mV)',
                  controller: dataState.foreignPspOnController,
                  isRequired: true,
                  textInputType: TextInputType.number,
                ),
            _verticalSpace(context: context),
          ],
        ) : const SizedBox.shrink();
  }

  Widget _foreignPspOffField(BuildContext context) {
    return hasType(['A','C','D', 'I'])
        ?  Column(
          children: [
            TextFieldWidget(
                  labelText: 'Foreign PSP OFF (-mV)',
                  controller: dataState.foreignPspOffController,
                  isRequired: true,
                  textInputType: TextInputType.number,
                ),
            _verticalSpace(context: context),
          ],
        ) : const SizedBox.shrink();
  }

// AC PSP (Volts)
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

// IJ Reading (-mV)
  Widget _ijOnField(BuildContext context) {
    return hasType(['K','P'])
        ? Column(
          children: [
            TextFieldWidget(
                  labelText: 'IJ Reading (-mv) - ON',
                  controller: dataState.ijOnController,
                  isRequired: true,
                  textInputType: TextInputType.number,
                ),
            _verticalSpace(context: context),
          ],
        ) : const SizedBox.shrink();
  }

  Widget _ijOffField(BuildContext context) {
    return  hasType(['K','P'])
        ? Column(
          children: [
            TextFieldWidget(
                  labelText: 'IJ Reading (-mv) - OFF',
                  controller: dataState.ijOffController,
                  isRequired: true,
                  textInputType: TextInputType.number,
                ),
            _verticalSpace(context: context),
          ],
        ) : const SizedBox.shrink();
  }

// Integrity of IJ
  Widget _ijIntegrityField(BuildContext context) {
    return hasType(['K','P'])
        ? Column(
          children: [
            TextFieldWidget(
                  labelText: 'Integrity of IJ',
                  controller: dataState.ijIntegrityController,
                  isRequired: true,
                ),
            _verticalSpace(context: context),
          ],
        ) : const SizedBox.shrink();
  }

// Condition of Surge Diverter
  Widget _surgeDiverterField(BuildContext context) {
    return  hasType(['K','P'])
        ? Column(
          children: [
            TextFieldWidget(
                  labelText: 'Condition of Surge Diverter',
                  controller: dataState.surgeDiverterConditionController,
                   isRequired: true,
                ),
            _verticalSpace(context: context),
          ],
        ) : const SizedBox.shrink();
  }

  // Condition of Surge Diverter
  Widget _acCurrentDischarge(BuildContext context) {
    return  hasType(['K','P'])
        ? Column(
      children: [
        TextFieldWidget(
          labelText: 'AC Current Discharge (Amps)',
          controller: dataState.acCurrentDischargeController,
          isRequired: true,
        ),
        _verticalSpace(context: context),
      ],
    ) : const SizedBox.shrink();
  }

// PSP Polarisation Coupon (-mV)
  Widget _couponOnField(BuildContext context) {
    return hasType(['K'])
        ?
    Column(
      children: [
        TextFieldWidget(
          labelText: 'PSP Polarisation Coupon (mv) - ON',
          controller: dataState.couponOnController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    ) : const SizedBox.shrink();
  }

  Widget _couponOffField(BuildContext context) {
    return hasType(['K'])
        ?  Column(
      children: [
        TextFieldWidget(
          labelText: 'PSP Polarisation Coupon (mv) - OFF',
          controller: dataState.couponOffController,
          isRequired: true,
          textInputType: TextInputType.number,
        ),
        _verticalSpace(context: context),
      ],
    ) : const SizedBox.shrink();
  }

// Current Measurement
  Widget _calibrationField(BuildContext context) {
    return hasType(['B'])
        ? Column(
          children: [
            TextFieldWidget(
                  labelText: 'Calibration of the Span (One Time) (Amp / mv)',
                  controller: dataState.calibrationController,
                   isRequired: true,
                  textInputType: TextInputType.number,
                ),
            _verticalSpace(context: context),
          ],
        ) : const SizedBox.shrink();
  }

  Widget _mvAcrossTerminalField(BuildContext context) {
    return hasType(['B'])
        ? Column(
          children: [
            TextFieldWidget(
                  labelText: 'mV across Two Terminal (with +/- sign)',
                  controller: dataState.mvAcrossTerminalController,
                   isRequired: true,
                  textInputType: TextInputType.number,
                ),
            _verticalSpace(context: context),
          ],
        ) : const SizedBox.shrink();
  }

  Widget _testStationCurrentField(BuildContext context) {
    return hasType(['B'])
        ? Column(
          children: [
            TextFieldWidget(
                  labelText: 'Current from Test Station with direction of current flow',
                  controller: dataState.testStationCurrentController,
                  isRequired: true,
                  textInputType: TextInputType.number,
                ),
            _verticalSpace(context: context),
          ],
        ) : const SizedBox.shrink();
  }

// Polarisation Cell
  Widget _cellConditionField(BuildContext context) {
    return hasType(['H'])
        ? Column(
      children: [
        TextFieldWidget(
          labelText: 'Physical Condition',
          controller: dataState.cellConditionController,
          isRequired: true,
        ),
        _verticalSpace(context: context),
      ],
    ) : const SizedBox.shrink();
  }

  Widget _groundingResistanceField(BuildContext context) {
    return hasType(['H'])
        ? Column(
          children: [
            TextFieldWidget(
                  labelText: 'Grounding Resistance (Ohms)',
                  controller: dataState.groundingResistanceController,
                  isRequired: true,
                  textInputType: TextInputType.number,
                ),
            _verticalSpace(context: context),
          ],
        ) : const SizedBox.shrink();
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

  Widget _dateOfReadingField(BuildContext context) {
    return TextFieldWidget(
      labelText: "Date of Reading",
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


  Widget _submit({required BuildContext context}) {
     return dataState.isLoader == false ?
     ButtonWidget(
         text: AppString.submit,
          onPressed: () {
            BlocProvider.of<AddTlpSurveyBloc>(context).add(SubmitTlpEvent(context: context));
           }
       ) : const DottedLoaderWidget();
  }



  Widget _verticalSpace({required BuildContext context}) {
    return SizedBox(height: MediaQuery
        .of(context)
        .size
        .width * 0.05);
  }

  bool hasType(List<String> types) =>
      types.contains(dataState.allowedTLPType) || types.contains(dataState.allowedTLPCondition);

}
