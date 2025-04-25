import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/deviation/domain/bloc/deviation_bloc.dart';
import 'package:flutter_gail/utils/commonWidgets/dropdown_search_widget.dart';
import 'package:flutter_gail/utils/commonWidgets/text_field_widget.dart';

class DeviationForm extends StatelessWidget {

  final FetchDeviationDataState dataState;

  const DeviationForm({super.key, required this.dataState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _verticalSpace(context),
        _deviationDropdown(context),
        _verticalSpace(context),
        dataState.deviationData.id.toString() == "5" ?
        _verticalSpace(context) : const SizedBox.shrink(),
        dataState.deviationData.id.toString() == "5" ?
         _otherController() : const SizedBox.shrink(),
        _verticalSpace(context),
        _actionButton(context),
        _verticalSpace(context),
        _submit(context),
        _verticalSpace(context),
      ],
    );
  }

  Widget _deviationDropdown(BuildContext context) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.deviationData.id != null ? dataState.deviationData : null,
      hint: "Deviation",
      items: dataState.deviationList,
      itemAsString: (deviationData) => deviationData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<DeviationBloc>(context)
            .add(SelectDeviation(deviationData: value));
      },
    );
  }

  Widget _otherController() {
    return TextFieldWidget(
      labelText: "Other Reason",
      controller: dataState.otherController,
      isRequired: true,
      maxLine: 3,
      textInputType: TextInputType.text,
    );
  }

  Widget _actionButton(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            BlocProvider.of<DeviationBloc>(context)
                .add(SelectFile(context: context));
          }, icon: dataState.file.path.isEmpty
            ? Icon(Icons.camera_alt, color: AppColor.grey,)
            : ClipOval(child: Image.file(
          dataState.file,
          height: MediaQuery.of(context).size.width * 0.10,
          width: MediaQuery.of(context).size.width * 0.10,
        ),
        ),
          style: IconButton.styleFrom(backgroundColor: AppColor.lightGrey),
        ),

      ],
    );
  }

  Widget _submit(BuildContext context) {
    return dataState.isLoader == false ?
    ButtonWidget(text: AppString.submit,
        onPressed: () {
          BlocProvider.of<DeviationBloc>(context)
              .add(SubmitEvent(context: context));
        }
    ) : const DottedLoaderWidget();
  }

  Widget _verticalSpace(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.width * 0.05
    );
  }

}
