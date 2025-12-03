import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gail/feature/pgis/domain/bloc/pgis_bloc.dart';
import 'package:flutter_gail/feature/pgis/helper/pgis_helper.dart';
import 'package:flutter_gail/utils/commonWidgets/SpinLoader.dart';

import 'TypeAheadFieldWidget.dart';

class MapLayerWidget extends StatelessWidget {
  const MapLayerWidget({super.key, });

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
                  Flexible(
                    child: RadioListTile<String>(
                      contentPadding: EdgeInsets.all(0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      dense: true,
                      title: Text("Generate New Bill",),
                      value: "Generate New Bill",
                      groupValue: state.selectedLayerType.isEmpty
                          ? ""
                          : state.selectedLayerType,
                      onChanged: (value) {
                        context.read<PgisBloc>().add(SelectLayerTypeEvent(value!));
                      },
                    ),
                  ),
                  Flexible(
                    child: RadioListTile<String>(
                      contentPadding: EdgeInsets.all(0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      dense: true,
                      title: Text("Next Gas Bill",),
                      value: "Next Gas Bill",
                      groupValue: state.selectedLayerType.isEmpty
                          ? ""
                          : state.selectedLayerType,
                      onChanged: (value) {
                        context.read<PgisBloc>().add(SelectLayerTypeEvent(value!));
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
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
