import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/domain/bloc/cp_unit_monitoring_bloc.dart';
import 'package:flutter_gail/feature/cpUnitMonitoring/presentation/widget/cp_unit_monitoring_form.dart';

class CpUnitMonitoringPage extends StatefulWidget {
  const CpUnitMonitoringPage({super.key});

  @override
  State<CpUnitMonitoringPage> createState() => _CpUnitMonitoringPageState();
}

class _CpUnitMonitoringPageState extends State<CpUnitMonitoringPage> {

  @override
  void initState() {
    BlocProvider.of<CpUnitMonitoringBloc>(context).add(
        CpUnitMonitoringPageLoadEvent(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CpUnitMonitoringBloc, CpUnitMonitoringState>(
      builder: (context, state) {
        if (state is FetchCpUnitMonitoringDataState) {
          return CpUnitMonitoringForm(dataState: state);
        } else {
          return const Center(child: CenterLoaderWidget());
        }
      },
    );
  }
}
