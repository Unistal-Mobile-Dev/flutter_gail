import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/addEncroachment/domain/bloc/encroachment_bloc.dart';
import 'package:flutter_gail/feature/task/addEncroachment/presentation/widget/form/encroachment_form.dart';

class EncroachmentPage extends StatefulWidget {
  const EncroachmentPage({super.key});

  @override
  State<EncroachmentPage> createState() => _EncroachmentPageState();
}

class _EncroachmentPageState extends State<EncroachmentPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextWidget("Encroachment",
        fontSize: AppFont.font_16, color: AppColor.white,),),
      body: BlocBuilder<EncroachmentBloc, EncroachmentState>(
        builder: (context, state) {
          if(state is FetchEncroachmentDataState){
            return _itemBuilder(dataState: state);
          } else {
            return const Center(child: CenterLoaderWidget());
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchEncroachmentDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: EncroachmentForm(dataState: dataState),
      ),
    );
  }

}
