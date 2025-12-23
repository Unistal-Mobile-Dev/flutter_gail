import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gail/feature/pgis/domain/bloc/pgis_bloc.dart';
import 'package:flutter_gail/feature/pgis/helper/pgis_helper.dart';
import 'package:flutter_gail/feature/pgis/presentation/widget/custom_switch_widget.dart';
import 'package:flutter_gail/utils/commonWidgets/SpinLoader.dart';
import 'package:flutter_gail/utils/res/app_color.dart';

import 'TypeAheadFieldWidget.dart';

class MapLayerWidget extends StatelessWidget {
  final ArcGISMapViewController controller;
  const MapLayerWidget({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PgisBloc, PgisState>(
      builder: (context, state) {
        if (state is FetchPgisDataState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSwitch(
                    label: "Pipeline Device",
                    value: state.isPipelineDeviceCheck,
                    onChanged: (val) {
                      context.read<PgisBloc>().add(TogglePipelineDeviceEvent(controller: controller));
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomSwitch(
                    label: "Structure Boundary Point",
                    value: state.isStructureCheck,
                    onChanged: (val) {
                       context.read<PgisBloc>().add(ToggleStructureEvent(controller: controller));
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomSwitch(
                    label: "Pipeline Line",
                    value: state.isPipelineCheck,
                    onChanged: (val) {
                      context.read<PgisBloc>().add(TogglePipelineEvent(controller: controller));
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomSwitch(
                    label: "Continuous Network",
                    value: state.isContinuousCheck,
                    onChanged: (val) {
                      context.read<PgisBloc>().add(ToggleContinuousEvent(controller: controller));
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomSwitch(
                    label: "Engineering Network",
                    value: state.isEngineeringCheck,
                    onChanged: (val) {
                      context.read<PgisBloc>().add(ToggleEngineeringEvent(controller: controller));
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomSwitch(
                    label: "Structure Boundary",
                    value: state.isStructureBoundaryCheck,
                    onChanged: (val) {
                      context.read<PgisBloc>().add(ToggleStructureBoundaryEvent(controller: controller));
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomSwitch(
                    label: "Service Territory",
                    value: state.isServiceCheck,
                    onChanged: (val) {
                      context.read<PgisBloc>().add(ToggleServiceEvent(controller: controller));
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomSwitch(
                    label: "Cadastral",
                    value: state.isCadastralCheck,
                    onChanged: (val) {
                      context.read<PgisBloc>().add(ToggleCadastralEvent(controller: controller,));
                    },
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",style: TextStyle(color: AppColor.themeColor,),),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: SpinLoader());
        }
      },
    );
  }
}
