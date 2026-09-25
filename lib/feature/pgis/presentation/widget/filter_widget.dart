import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gail/feature/pgis/domain/bloc/pgis_bloc.dart';
import 'package:flutter_gail/feature/pgis/helper/pgis_helper.dart';
import 'package:flutter_gail/utils/commonWidgets/SpinLoader.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

import 'TypeAheadFieldWidget.dart';

class FilterWidget extends StatelessWidget {
  final ArcGISMapViewController mapViewController;
  const FilterWidget({super.key, required this.mapViewController});

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
                  TypeaheadFieldWidget(
                    label: "Search Section Name",
                    suffix: IconButton(
                      icon: Icon(Icons.cancel_outlined, color: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<PgisBloc>().add(
                          ResetPipelineEvent(
                            controller: mapViewController,
                          ),
                        );
                      },
                    ),
                    controller: state.pipelineCtrl,
                    suggestionsCallback: (val) async {
                      final results = await PGISHelper.pipelineSuggestionName(
                        context: context,
                        query: val,
                      );
                      return results ?? [];
                    },
                    onSelected: (suggestion) async {
                      state.pipelineCtrl.text = suggestion.engRouteName;
                      Navigator.pop(context);

                      context.read<PgisBloc>().add(
                        SelectPipelineEngRouteEvent(
                          context: context,
                          query: suggestion.engRouteName,
                          controller: mapViewController,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  TypeaheadFieldWidget(
                   // enabled:  state.pipelineCtrl.text.isNotEmpty ? true : false,
                    label: "Search Station Name",
                    controller: state.sectionCtrl,
                    suffix: IconButton(
                      icon: Icon(Icons.cancel_outlined, color: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<PgisBloc>().add(
                          ResetStationEvent(
                            controller: mapViewController,
                          ),
                        );
                      },
                    ),
                    suggestionsCallback: (val) async {
                      final results = await PGISHelper.stationSuggestionName(
                        context: context,
                        query: val,
                        pipelineNameOrCode: state.pipelineCtrl.text,
                      );
                      return results ?? [];
                    },
                    onSelected: (suggestion) async {
                      state.sectionCtrl.text = suggestion.stationName;
                      Navigator.pop(context);
                      context.read<PgisBloc>().add(
                        SelectStationEvent(
                          context: context,
                          query:  suggestion.objectId.toString(),
                          controller: mapViewController,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  TypeaheadFieldWidget(
                  //  enabled:  state.pipelineCtrl.text.isNotEmpty ? true : false,
                    label: "Search TLP Name",
                    suffix: IconButton(
                      icon: Icon(Icons.cancel_outlined, color: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<PgisBloc>().add(
                          ResetTLPEvent(
                            controller: mapViewController,
                          ),
                        );
                      },
                    ),
                    controller: state.tlpCtrl,
                    suggestionsCallback: (val) async {
                      final results = await PGISHelper.tlpSuggestionName(
                        context: context,
                        query: val,
                        pipelineNameOrCode: state.pipelineCtrl.text,
                      );
                      return results ?? [];
                    },
                    onSelected: (suggestion) async {
                      state.tlpCtrl.text = suggestion.tlpno ?? '';
                      Navigator.pop(context);
                      context.read<PgisBloc>().add(
                        SelectTLPEvent(
                          context: context,
                          query:  suggestion.objectId.toString(),
                          controller: mapViewController,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",style: TextStyle(color: EnvironmentConfig.of(context)!.primaryTheme,),),
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
