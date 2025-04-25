import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/addEncroachment/domain/bloc/encroachment_bloc.dart';

class EncroachmentForm extends StatelessWidget {

  final FetchEncroachmentDataState dataState;
  const EncroachmentForm({super.key, required this.dataState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _verticalSpace(context),
        _locationText(),
        _verticalSpace(context),
        _chainageController(),
        _verticalSpace(context),
        _encroachmentTypeDropdown(context),
        _verticalSpace(context),
        _actionButton(context),
        _verticalSpace(context),
        _submit(context),
        _verticalSpace(context),
      ],
    );
  }

  Widget _locationText() {
    return TextWidget(dataState.location,
      fontSize: AppFont.font_10,);
  }

  Widget _chainageController() {
    return TextFieldWidget(
        labelText: "Chainage (in meters) ",
        controller: dataState.chainageController,
        isRequired: true,
        textInputType: TextInputType.number,
    );
  }

  Widget _encroachmentTypeDropdown(BuildContext context) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.encroachmentData.value != null ? dataState.encroachmentData : null,
      hint: "Encroachment",
      items: dataState.encroachmentList,
      itemAsString: (encroachmentData) => encroachmentData.label.toString(),
      onChanged: (value) {
        BlocProvider.of<EncroachmentBloc>(context)
            .add(SelectEncroachmentTypeEvent(encroachmentData: value));
      },
    );
  }

  Widget _actionButton(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            BlocProvider.of<EncroachmentBloc>(context)
                .add(SelectFileEvent(context: context));
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
          BlocProvider.of<EncroachmentBloc>(context)
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
