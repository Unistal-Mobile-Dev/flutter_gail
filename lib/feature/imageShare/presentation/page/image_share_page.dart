import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/imageShare/domain/bloc/image_share_bloc.dart';
import 'package:flutter_gail/feature/imageShare/presentation/widget/form/image_share_form.dart';

class ImageSharePage extends StatefulWidget {
  const ImageSharePage({super.key});

  @override
  State<ImageSharePage> createState() => _ImageSharePageState();
}

class _ImageSharePageState extends State<ImageSharePage> {

  @override
  void initState() {
    BlocProvider.of<ImageShareBloc>(context)
        .add(ImageSharePageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageShareBloc, ImageShareState>(
      builder: (context, state) {
        if(state is FetchImageShareDataState) {
          return _itemBuilder(dataState: state);
        } else {
          return const Center(child: CenterLoaderWidget());
        }
      },
    );
  }

  Widget _itemBuilder({required FetchImageShareDataState dataState}) {
     return Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: ImageShareForm(dataState: dataState),
        ),
     );
  }
}
