import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/task/deviation/domain/bloc/deviation_bloc.dart';
import 'package:flutter_gail/feature/task/deviation/presentation/widget/form/deviation_form.dart';

class DeviationPage extends StatefulWidget {
  const DeviationPage({super.key});

  @override
  State<DeviationPage> createState() => _DeviationPageState();
}

class _DeviationPageState extends State<DeviationPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextWidget("Deviation",
        fontSize: AppFont.font_16, color: AppColor.white,),),
      body: BlocBuilder<DeviationBloc, DeviationState>(
        builder: (context, state) {
          if (state is FetchDeviationDataState) {
            return _itemBuilder(dataState: state);
          } else {
            return const Center(child: CenterLoaderWidget());
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchDeviationDataState dataState}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: DeviationForm(dataState: dataState),
      ),
    );
  }
}