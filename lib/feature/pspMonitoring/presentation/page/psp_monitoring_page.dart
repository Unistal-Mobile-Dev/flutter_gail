import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/pspMonitoring/domain/bloc/psp_monitoring_bloc.dart';
import 'package:flutter_gail/feature/pspMonitoring/presentation/widget/psp_monitoring_form.dart';

class PspMonitoringPage extends StatefulWidget {
  const PspMonitoringPage({super.key});

  @override
  State<PspMonitoringPage> createState() => _PspMonitoringPageState();
}

class _PspMonitoringPageState extends State<PspMonitoringPage> {

  @override
  void initState() {
    BlocProvider.of<PspMonitoringBloc>(context).add(
        PspMonitoringPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PspMonitoringBloc, PspMonitoringState>(
      builder: (context, state) {
        if (state is FetchPspMonitoringDataState) {
          return PspMonitoringForm(dataState: state);
        } else {
          return const Center(child: CenterLoaderWidget());
        }
      },
    );
  }
}
