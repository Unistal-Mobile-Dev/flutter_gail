import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/incident/add_incident/domain/bloc/add_incident_bloc.dart';
import 'package:flutter_gail/feature/task/addMarker/presentation/widget/voice_record_widget.dart';

class AddIncidentPage extends StatefulWidget {
  const AddIncidentPage({super.key});

  @override
  State<AddIncidentPage> createState() => _AddIncidentPageState();
}

class _AddIncidentPageState extends State<AddIncidentPage> {


  @override
  void initState() {
    BlocProvider.of<AddIncidentBloc>(context)
        .add(AddIncidentPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddIncidentBloc, AddIncidentState>(
      builder: (context, state) {
        if(state is FetchAddIncidentDataState){
          return _itemBuilder(dataState: state);
        } else {
          return const Center(child: CenterLoaderWidget());
        }
      },
    );
  }

  Widget _itemBuilder({required FetchAddIncidentDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _verticalSpace(),
            _typeDropDown(dataState: dataState),
            _verticalSpace(),
            _incidentReportController(dataState: dataState),
            _verticalSpace(),
            _actionButton(dataState: dataState),
            _verticalSpace(),
            _submit(dataState: dataState),
            _verticalSpace(),
          ],
        ),
      ),
    );
  }

  Widget _typeDropDown({required FetchAddIncidentDataState dataState}) {
    return DropDownSearchWidget(
      isRequired: true,
      selectedItem: dataState.incidentTypeData.name != null ? dataState.incidentTypeData : null,
      hint: AppString.type,
      items: dataState.incidentTypeList,
      itemAsString: (incidentTypeData) => incidentTypeData.name.toString(),
      onChanged: (value) {
        BlocProvider.of<AddIncidentBloc>(context)
            .add(AddIncidentSelectTypeEvent(incidentTypeData: value));
      },
    );
  }

  Widget _incidentReportController({required FetchAddIncidentDataState dataState}) {
    return TextFieldWidget(
      isRequired: true,
      maxLine: 5,
      labelText: AppString.reportIncident,
      controller: dataState.incidentReportController
    );
  }

  Widget _actionButton({required FetchAddIncidentDataState dataState}) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            mediaType(context: context,
                onPressedCamera: () {
                  BlocProvider.of<AddIncidentBloc>(context)
                      .add(AddIncidentSelectImageEvent(context: context, mediaType: 1));
                  Navigator.pop(context);
                },
                onPressedGallery:() {
                  BlocProvider.of<AddIncidentBloc>(context)
                      .add(AddIncidentSelectImageEvent(context: context, mediaType: 2));
                  Navigator.pop(context);
                }
            );
          }, icon: dataState.imageFile.path.isEmpty
            ? Icon(Icons.camera_alt, color: AppColor.grey,)
            : ClipOval(child: Image.file(
          dataState.imageFile,
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
              BlocProvider.of<AddIncidentBloc>(!context.mounted ? context : context,)
                  .add(AddIncidentSelectAudioEvent(audioPath: res.toString()));
            }
          }, icon: Icon(Icons.mic, color: dataState.audioRecordFile.path.isNotEmpty ? AppColor.themeColor :AppColor.grey,),
          style: IconButton.styleFrom(backgroundColor: AppColor.lightGrey),
        ),*/

/*        IconButton(
          onPressed: () {
            mediaType(context: context,
                onPressedCamera: () {
                  BlocProvider.of<AddIncidentBloc>(context)
                      .add(AddIncidentSelectVideoEvent(context: context, mediaType: 1));
                  Navigator.pop(context);
                },
                onPressedGallery:() {
                  BlocProvider.of<AddIncidentBloc>(context)
                      .add(AddIncidentSelectVideoEvent(context: context, mediaType: 1));
                  Navigator.pop(context);
                }
            );
          }, icon: Icon(Icons.video_camera_back,
          color: dataState.videoFile.path.isNotEmpty ? AppColor.themeColor : AppColor.grey,),
          style: IconButton.styleFrom(backgroundColor: AppColor.lightGrey),
        ),*/
      ],
    );
  }

  Widget _submit({required FetchAddIncidentDataState dataState}) {
    return dataState.isLoader == false ?
        ButtonWidget(text: AppString.submit, 
            onPressed: () {
             BlocProvider.of<AddIncidentBloc>(context)
                 .add(AddIncidentSubmitEvent(context: context));
            }
        ) : const DottedLoaderWidget();
  }

  Widget _verticalSpace() {
    return SizedBox(
        height: MediaQuery.of(context).size.width * 0.05
    );
  }

}
