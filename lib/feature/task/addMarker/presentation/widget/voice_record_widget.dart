import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/utils/commonWidgets/voideRecord/audio_player.dart';
import 'package:flutter_gail/utils/commonWidgets/voideRecord/audio_recorder.dart';

class VoiceRecordWidget extends StatefulWidget {
  const VoiceRecordWidget({super.key});

  @override
  State<VoiceRecordWidget> createState() => _VoiceRecordWidgetState();
}

class _VoiceRecordWidgetState extends State<VoiceRecordWidget> {
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size =  MediaQuery.of(context).size.height - MediaQuery.of(context).size.width;
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            showPlayer == false ?
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () async {
                    if(audioPath != null){
                      if(audioPath.toString().isNotEmpty){
                        final file = File(audioPath.toString());
                        if (await file.exists()) {
                       file.delete();
                        }
                      }
                    }
                    Navigator.pop(!context.mounted? context : context);
                  }, icon: Icon(Icons.close, color: AppColor.themeColor,)),
            ) : const SizedBox.shrink(),

            Expanded(
              child: Center(
                child: showPlayer
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: AudioPlayer(
                    source: audioPath!,
                    onDelete: () {
                      setState(() => showPlayer = false);
                    },
                  ),
                )
                    : Recorder(
                  onStop: (path) {
                    if (kDebugMode) print('Recorded file path: $path');
                    setState(() {
                      audioPath = path;
                      showPlayer = true;
                    });
                  },
                ),
              ),
            ),
            showPlayer ?
            _actionButton()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _actionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(onPressed: () async {
          if(audioPath != null){
            if(audioPath.toString().isNotEmpty){
              final file = File(audioPath.toString());
              if (await file.exists()) {
                file.delete();
              }
            }
          }
          Navigator.pop(!context.mounted? context : context);
        }, child: TextWidget(
          "Cancel", color: AppColor.black,)),

        IconButton(
            onPressed: () {
              Navigator.pop(context, audioPath.toString());
        }, icon: Icon(Icons.done, color: AppColor.themeColor,)),
      ],
    );
  }

}
