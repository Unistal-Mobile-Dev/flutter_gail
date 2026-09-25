import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/bloc/add_tlp_survey_bloc.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/presentation/widget/add_tlp_survey_form.dart';
import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/presentation/widget/add_tlp_survey_form_new.dart';

class AddTlpSurveyPage extends StatefulWidget {
  const AddTlpSurveyPage({super.key});

  @override
  State<AddTlpSurveyPage> createState() => _AddTlpSurveyPageState();
}

class _AddTlpSurveyPageState extends State<AddTlpSurveyPage> {

  @override
  void initState() {
    BlocProvider.of<AddTlpSurveyBloc>(context).add(
        AddTlpSurveyPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTlpSurveyBloc, AddTlpSurveyState>(
      builder: (context, state) {
        if(state is FetchAddTlpSurveyDataState) {
           return AddTlpSurveyFormNew(dataState: state);
          // return AddTlpSurveyForm(dataState: state);
        } else {
          return const Center(child: CenterLoaderWidget());
        }
      },
    );
  }
}
