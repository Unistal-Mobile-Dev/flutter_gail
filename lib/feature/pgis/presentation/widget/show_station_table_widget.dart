import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gail/feature/pgis/domain/bloc/pgis_bloc.dart';
import 'package:flutter_gail/feature/pgis/domain/model/structure_boundary_point_model.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class ShowStationTable {
  static void showStationTable({
    required BuildContext context,
    required List<StructureBoundaryFeature> stations,
    required ArcGISMapViewController controller,
    required ArcGISPoint mapPoint,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child:
              Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Text(
                          "Stations within buffer (${stations.length})",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel",style: TextStyle(color: EnvironmentConfig.of(context)!.primaryTheme,),),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),
                  stations.isEmpty
                      ? const Expanded(
                    child: Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                      : Expanded(
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowHeight: 42,
                                  dataRowHeight: 48,
                                  showCheckboxColumn: false,
                                  columnSpacing: 24,
                                  columns: const [
                                    DataColumn(label: Text("Station")),
                                    DataColumn(label: Text("Eng Route")),
                                    DataColumn(label: Text("Cont Route")),
                                    DataColumn(label: Text("Area (Sqm)")),
                                  ],
                                  rows: List.generate(stations.length, (index) {
                                    final station = stations[index];

                                    return DataRow(
                                      onSelectChanged: (_) {
                                        if (station.geometry == null) return;

                                        final point = ArcGISPoint(
                                          x: station.geometry.x,
                                          y: station.geometry.y,
                                          spatialReference:
                                              controller
                                                  .arcGISMap
                                                  ?.spatialReference ??
                                              SpatialReference.wgs84,
                                        );

                                        controller.setViewpointCenter(
                                          point,
                                          scale: 1000,
                                        );

                                        Navigator.pop(context);
                                      },
                                      cells: [
                                        DataCell(
                                          Text(
                                            station.attributes.stationName ?? "-",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            station.attributes.engRouteName ?? "-",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            station.attributes.contRouteName ?? "-",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            station.attributes.areaSqM != null
                                                ? station.attributes.areaSqM
                                                    .toString()
                                                : "-",
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.navigation, color: Colors.white),
                              label: const Text(
                                "Navigator",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                if (mapPoint != null) {
                                  context.read<PgisBloc>().add(
                                    StartNavigationEvent(
                                        destination: mapPoint,
                                        controller: controller
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                ],
              ),
        );
      },
    );
  }
}
