import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/addMarker/domain/bloc/add_marker_bloc.dart';
import 'package:flutter_gail/feature/task/addMarker/presentation/widget/voice_record_widget.dart';
import 'package:flutter_gail/utils/commonClass/fade_route.dart';
import 'package:flutter_gail/utils/commonWidgets/cupertino_date_picker_widget.dart';

class AddMarkerPage extends StatefulWidget {
  const AddMarkerPage({super.key});

  @override
  State<AddMarkerPage> createState() => _AddMarkerPageState();
}

class _AddMarkerPageState extends State<AddMarkerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextWidget("Pipeline Marker",
        fontSize: AppFont.font_16, color: AppColor.white,),),
      body: BlocBuilder<AddMarkerBloc, AddMarkerState>(
        builder: (context, state) {
          if(state is FetchAddMarkerDataState){
            return _itemBuilder(dataState: state);
          } else {
            return const Center(child: CenterLoaderWidget(),);
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchAddMarkerDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget("Warning Marker",color: AppColor.black,),
            _markerListBuilder(dataState: dataState),
            _verticalSpace(),
            _conditionRadioButton(dataState: dataState),
            _verticalSpace(),
            _paintingRadioButton(dataState: dataState),
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

  Widget _markerListBuilder({required FetchAddMarkerDataState dataState}) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: dataState.markerTypeList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<AddMarkerBloc>(context)
                    .add(AddMarkerSelectMarkerEvent(index: index));
              },
              child: CircleAvatar(
                backgroundColor: dataState.markerTypeList[index].isSelected == true
                     ? AppColor.themeColor : AppColor.lightGrey,
                child: Padding(
                  padding: const EdgeInsets.all(2), // Border radius
                  child: ClipOval(child: Image.asset(
                      dataState.markerTypeList[index].markerUrl.toString(),
                      height: MediaQuery.of(context).size.width * 0.15,
                      width: MediaQuery.of(context).size.width * 0.15,
                     )
                  ),
                ),
              ),
            ),
          );
      }),
    );
  }

  Widget _conditionRadioButton({required FetchAddMarkerDataState dataState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget("Condition",color: AppColor.black,),
        Row(
          children: [
            Radio(value: "1",
                groupValue: dataState.condition,
                onChanged: (value) {
                BlocProvider.of<AddMarkerBloc>(context)
                    .add(AddMarkerSelectConditionEvent(condition: value.toString()));
            }),
            TextWidget("Good", fontSize: AppFont.font_12,),

            Radio(value: "2",
                groupValue: dataState.condition,
                onChanged: (value) {
                  BlocProvider.of<AddMarkerBloc>(context)
                      .add(AddMarkerSelectConditionEvent(condition: value.toString()));
                }),
            TextWidget("Damaged", fontSize: AppFont.font_12,),

            Radio(value: "3",
                groupValue: dataState.condition,
                onChanged: (value) {
                  BlocProvider.of<AddMarkerBloc>(context)
                      .add(AddMarkerSelectConditionEvent(condition: value.toString()));
                }),
            TextWidget("Missing", fontSize: AppFont.font_12,),

          ],
        )
      ],
    );
  }

  Widget _paintingRadioButton({required FetchAddMarkerDataState dataState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget("Painting",color: AppColor.black,),
        Row(
          children: [
            Radio(value: "1",
                groupValue: dataState.painting,
                onChanged: (value) {
                  BlocProvider.of<AddMarkerBloc>(context)
                      .add(AddMarkerSelectPaintingEvent(painting: value.toString()));
                }),
            TextWidget("Good", fontSize: AppFont.font_12,),

            Radio(value: "2",
                groupValue: dataState.painting,
                onChanged: (value) {
                  BlocProvider.of<AddMarkerBloc>(context)
                      .add(AddMarkerSelectPaintingEvent(painting: value.toString()));
                }),
            TextWidget("Required", fontSize: AppFont.font_12,),

          ],
        )
      ],
    );
  }

  Widget _remarkController({required FetchAddMarkerDataState dataState}) {
    return TextFieldWidget(
      controller: dataState.remarkController,
      maxLine: 5,
      labelText: AppString.remark,
    );
  }
  
  Widget _actionButton({required FetchAddMarkerDataState dataState}) {
    return Row(
      children: [
        IconButton(
          onPressed: () {

          mediaType(context: context,
              onPressedCamera: () {
               BlocProvider.of<AddMarkerBloc>(context)
                   .add(AddMarkerSelectMediaEvent(context: context, mediaType: 1, isVideo: false));
                Navigator.pop(context);
              },
              onPressedGallery:() {
                BlocProvider.of<AddMarkerBloc>(context)
                    .add(AddMarkerSelectMediaEvent(context: context, mediaType: 2, isVideo: false));
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

        IconButton(
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
              BlocProvider.of<AddMarkerBloc>(context.mounted ? context : context)
                  .add(AddMarkerSelectVoiceEvent(audioPath: res.toString()));
            }
        }, icon: Icon(Icons.mic,
          color: dataState.voiceRecordFile.path.isEmpty ?
          AppColor.grey : AppColor.themeColor),
          style: IconButton.styleFrom(backgroundColor: AppColor.lightGrey),
        ),

        IconButton(
          onPressed: () {
          mediaType(context: context,
              onPressedCamera: () {
                BlocProvider.of<AddMarkerBloc>(context)
                    .add(AddMarkerSelectMediaEvent(context: context, mediaType: 1, isVideo: true));
                Navigator.pop(context);
              },
              onPressedGallery:() {
                BlocProvider.of<AddMarkerBloc>(context)
                    .add(AddMarkerSelectMediaEvent(context: context, mediaType: 2, isVideo: true));
                Navigator.pop(context);
              }
          );
        }, icon: Icon(Icons.video_camera_back,
          color: dataState.voiceRecordFile.path.isEmpty ?
          AppColor.grey : AppColor.themeColor,),
          style: IconButton.styleFrom(backgroundColor: AppColor.lightGrey),
        ),
      ],
    );
  }

  Widget _submitButton({required FetchAddMarkerDataState dataState}) {
    return dataState.isLoader == false ?
    ButtonWidget(
        text: AppString.submit,
        onPressed: () {
          BlocProvider.of<AddMarkerBloc>(context)
              .add(AddMarkerSubmitEvent(context: context));
        }
    ) : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.04,
    );
  }

}
