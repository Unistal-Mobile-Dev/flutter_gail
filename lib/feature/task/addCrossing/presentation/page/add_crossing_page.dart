import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/addCrossing/domain/bloc/add_crossing_bloc.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class AddCrossingPage extends StatefulWidget {
  const AddCrossingPage({super.key});

  @override
  State<AddCrossingPage> createState() => _AddCrossingPageState();
}

class _AddCrossingPageState extends State<AddCrossingPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextWidget("Pipeline Crossing",
        fontSize: AppFont.font_16, color: AppColor.white,),),
      body: BlocBuilder<AddCrossingBloc, AddCrossingState>(
        builder: (context, state) {
          if(state is FetchAddCrossingDataState){
            return _itemBuilder(dataState: state);
          } else {
            return const Center(child: CenterLoaderWidget(),);
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchAddCrossingDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget("Warning Crossing",color: AppColor.black,),
            _crossingListBuilder(dataState: dataState),
            _verticalSpace(),
            _warningMarkerRadioButton(dataState: dataState),
            _verticalSpace(),
            _drainConditionRadioButton(dataState: dataState),
            _verticalSpace(),
            _bankConditionRadioButton(dataState: dataState),
            _verticalSpace(),
            _remarkController(dataState: dataState),
            _verticalSpace(),
            _actionButton(dataState: dataState),
            _verticalSpace(),
            _submitButton(dataState: dataState),
            _verticalSpace(),
          ],
        ),
      ),
    );
  }

  Widget _crossingListBuilder({required FetchAddCrossingDataState dataState}) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.20,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: dataState.crossingTypeList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectCrossingEvent(index: index));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: dataState.crossingTypeList[index].isSelected == true
                          ? EnvironmentConfig.of(context)!.primaryTheme : AppColor.lightGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(2), // Border radius
                        child: ClipOval(child: Image.asset(
                          dataState.crossingTypeList[index].crossingUrl.toString(),
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                        )
                        ),
                      ),
                    ),
                    TextWidget(
                      dataState.crossingTypeList[index].name.toString(),
                      color: dataState.crossingTypeList[index].isSelected == true
                          ? EnvironmentConfig.of(context)!.primaryTheme : AppColor.black,
                      textAlign: TextAlign.center,
                      fontSize: AppFont.font_10,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _warningMarkerRadioButton({required FetchAddCrossingDataState dataState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget("Warning Marker",color: AppColor.black,),
        Row(
          children: [
            Radio(value: "Good",
                groupValue: dataState.warningMarker,
                onChanged: (value) {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectWarningMarkerEvent(warningMarker: value.toString()));
                }),
            TextWidget("Good", fontSize: AppFont.font_12,),

            Radio(value: "Damaged",
                groupValue: dataState.warningMarker,
                onChanged: (value) {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectWarningMarkerEvent(warningMarker: value.toString()));
                }),
            TextWidget("Damaged", fontSize: AppFont.font_12,),

            Radio(value: "Missing",
                groupValue: dataState.warningMarker,
                onChanged: (value) {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectWarningMarkerEvent(warningMarker: value.toString()));
                }),
            TextWidget("Missing", fontSize: AppFont.font_12,),

          ],
        )
      ],
    );
  }

  Widget _drainConditionRadioButton({required FetchAddCrossingDataState dataState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget("Vent And Drain Condition",color: AppColor.black,),
        Row(
          children: [
            Radio(value: "Good",
                groupValue: dataState.drainCondition,
                onChanged: (value) {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectDrainConditionEvent(drainCondition: value.toString()));
                }),
            TextWidget("Good", fontSize: AppFont.font_12,),

            Radio(value: "Eroded",
                groupValue: dataState.drainCondition,
                onChanged: (value) {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectDrainConditionEvent(drainCondition: value.toString()));
                }),
            TextWidget("Eroded", fontSize: AppFont.font_12,),

            Radio(value: "N.A",
                groupValue: dataState.drainCondition,
                onChanged: (value) {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectDrainConditionEvent(drainCondition: value.toString()));
                }),
            TextWidget("N.A", fontSize: AppFont.font_12,),

          ],
        )
      ],
    );
  }

  Widget _bankConditionRadioButton({required FetchAddCrossingDataState dataState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget("Bank Condition",color: AppColor.black,),
        Row(
          children: [
            Radio(value: "Good",
                groupValue: dataState.bankCondition,
                onChanged: (value) {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectBankConditionEvent(bankCondition: value.toString()));
                }),
            TextWidget("Good", fontSize: AppFont.font_12,),

            Radio(value: "Eroded",
                groupValue: dataState.bankCondition,
                onChanged: (value) {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectBankConditionEvent(bankCondition: value.toString()));
                }),
            TextWidget("Eroded", fontSize: AppFont.font_12,),

            Radio(value: "Pipe Exposed",
                groupValue: dataState.bankCondition,
                onChanged: (value) {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectBankConditionEvent(bankCondition: value.toString()));
                }),
            TextWidget("Pipe Exposed", fontSize: AppFont.font_12,),

          ],
        )
      ],
    );
  }

  Widget _remarkController({required FetchAddCrossingDataState dataState}) {
    return TextFieldWidget(
      controller: dataState.remarkController,
      maxLine: 5,
      labelText: AppString.remark,
    );
  }

  Widget _actionButton({required FetchAddCrossingDataState dataState}) {
    return Row(
      children: [
        IconButton(
          onPressed: () {

            mediaType(context: context,
                onPressedCamera: () {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectMediaEvent(context: context, mediaType: 1, isVideo: false));
                  Navigator.pop(context);
                },
                onPressedGallery:() {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectMediaEvent(context: context, mediaType: 2, isVideo: false));
                  Navigator.pop(context);
                }
            );
          }, icon: dataState.cameraFile.path.isEmpty
            ? Icon(Icons.camera_alt, color: AppColor.grey,)
            : ClipOval(child: Image.file(
          dataState.cameraFile,
          height: MediaQuery.of(context).size.width * 0.10,
          width: MediaQuery.of(context).size.width * 0.10,
        ),
        ),
          style: IconButton.styleFrom(backgroundColor: AppColor.lightGrey),
        ),

/*        IconButton(
          onPressed: () async {
            double size =  MediaQuery.of(!context.mounted ? context : context).size.height
                - MediaQuery.of(!context.mounted ? context : context).size.width;
            var res = await showCupertinoModalPopup<dynamic>(
              context: !context.mounted ? context : context,
              builder: (BuildContext context) => Container(
                height: size * 0.70,
                padding: const EdgeInsets.only(top: 6.0),
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: const SafeArea(
                  top: false,
                  child: VoiceRecordWidget(),
                ),
              ),
            );
            if(res != null){
              BlocProvider.of<AddCrossingBloc>(context.mounted ? context : context)
                  .add(AddCrossingSelectVoiceEvent(audioPath: res.toString()));
            }
          }, icon: Icon(Icons.mic, color: dataState.voiceRecordFile.path.isNotEmpty ? EnvironmentConfig.of(context)!.primaryTheme :AppColor.grey,),
          style: IconButton.styleFrom(backgroundColor: AppColor.lightGrey),
        ),*/

/*        IconButton(
          onPressed: () {
            mediaType(context: context,
                onPressedCamera: () {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectMediaEvent(context: context, mediaType: 1, isVideo: true));
                  Navigator.pop(context);
                },
                onPressedGallery:() {
                  BlocProvider.of<AddCrossingBloc>(context)
                      .add(AddCrossingSelectMediaEvent(context: context, mediaType: 2, isVideo: true));
                  Navigator.pop(context);
                }
            );
          }, icon: Icon(Icons.video_camera_back,
          color: dataState.videoFile.path.isNotEmpty ? EnvironmentConfig.of(context)!.primaryTheme : AppColor.grey,),
          style: IconButton.styleFrom(backgroundColor: AppColor.lightGrey),
        ),*/
      ],
    );
  }

  Widget _submitButton({required FetchAddCrossingDataState dataState}) {
    return dataState.isLoader == false ?
    ButtonWidget(
        text: AppString.submit,
        onPressed: () {
          BlocProvider.of<AddCrossingBloc>(context)
              .add(AddCrossingSubmitEvent(context: context));
        }
    ) : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.04,
    );
  }

}
