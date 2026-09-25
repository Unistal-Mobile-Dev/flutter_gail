import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/pgis/domain/bloc/pgis_bloc.dart';
import 'package:flutter_gail/feature/pgis/presentation/widget/show_station_table_widget.dart';
import 'package:flutter_gail/utils/commonWidgets/SpinLoader.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';

class PgisPage extends StatefulWidget {
  const PgisPage({super.key});

  @override
  State<PgisPage> createState() => _PgisPageState();
}

class _PgisPageState extends State<PgisPage> {
  late Timer _rotationTimer;
  ValueNotifier<double> _rotationNotifier = ValueNotifier(0);

  // /// ===== Measure state =====
  // final GraphicsOverlay _measureOverlay = GraphicsOverlay();
  // final List<ArcGISPoint> _measurePoints = [];
  // bool _isMeasuring = false;
  // double _measuredDistance = 0.0;
  // ArcGISPoint? mapPoint;
  // ArcGISPoint? _currentLocationPoint;

  @override
  void initState() {
    super.initState();
    // Start listening when page loads
    _rotationTimer = Timer.periodic(Duration(milliseconds: 200), (timer) async {
      try {
        final vp = await _mapViewController.getCurrentViewpoint(
          ViewpointType.centerAndScale,
        );
        if (vp != null) {
          _rotationNotifier.value = vp.rotation;
        }
      } catch (_) {}
    });
    BlocProvider.of<PgisBloc>(
      context,
    ).add(PgisPageLoadedEvent(context: context));
  }

  final _mapViewController = ArcGISMapView.createController();
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    _rotationTimer.cancel();
    _mapViewController.dispose();
    super.dispose();
  }

  void showLoaderDialog(BuildContext context, {String message = "Loading..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Flexible(child: Text(message, style: TextStyle(fontSize: 16))),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<PgisBloc, PgisState>(
        builder: (context, state) {
          if (state is FetchPgisDataState) {
            return _itemBuilder(dataState: state);
          } else {
            return const Center(child: SpinLoader());
          }
        },
      ),
    );
  }

  Widget _itemBuilder({required FetchPgisDataState dataState}) {
    return Stack(
      children: [
        _buildMap(dataState: dataState),
        if (dataState.distanceKm.toString().isNotEmpty &&
            dataState.distanceKm.toString() != "0.0")
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.height * 0.01,
            right: MediaQuery.of(context).size.height * 0.01,
            child: Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Distance: ${dataState.distanceKm.toStringAsFixed(2)} km',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Time: ${dataState.travelTimeMin.toStringAsFixed(0)} min',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.01,
          left: MediaQuery.of(context).size.height * 0.01,
          child: _rotationButton(),
        ),
        Positioned(
          right: MediaQuery.of(context).size.height * 0.01,
          top: MediaQuery.of(context).size.height * 0.002,
          child: _iconButtons(dataState: dataState),
        ),
        Positioned(
          right: MediaQuery.of(context).size.height * 0.01,
          bottom: MediaQuery.of(context).size.height * 0.20,
          child: FloatingActionButton(
            mini: true,
            tooltip: 'Show Stations',
            onPressed: () {
              ShowStationTable.showStationTable(
                context: context,
                stations: dataState.stationList,
                controller: _mapViewController,
                mapPoint: dataState.desPoint,
              );
            },
            child: Icon(Icons.list, size: 21,),
          ),
        ),
      ],
    );
  }

  _rotationButton() {
    return ValueListenableBuilder<double>(
      valueListenable: _rotationNotifier,
      builder: (context, rotation, child) {
        return GestureDetector(
          onTap: () {
            _mapViewController.setViewpointRotation(angleDegrees: 0);
          },
          child: Transform.rotate(
            angle: -rotation * 3.141592 / 180,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Icon(Icons.navigation, color: EnvironmentConfig.of(context)!.primaryTheme, size: 21),
            ),
          ),
        );
      },
    );
  }

  Widget _iconButtons({required FetchPgisDataState dataState}) {
    return Column(
      spacing: 15,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          mini: true,
          tooltip: 'Basemap',
          shape: const StadiumBorder(),
          elevation: 0,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  insetPadding: const EdgeInsets.all(12),
                  title: Row(
                    children: [
                      Icon(
                        Icons.dashboard_outlined,
                        size: 21,
                        color: EnvironmentConfig.of(context)!.primaryTheme,
                      ),
                      SizedBox(width: 8),
                      Text("Basemap"),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(color: EnvironmentConfig.of(context)!.primaryTheme),
                        _basemapOption(
                          context,
                          "Streets (Light)",
                          BasemapStyle.arcGISStreets,
                        ),
                        _basemapOption(
                          context,
                          "Streets (Night)",
                          BasemapStyle.arcGISStreetsNight,
                        ),
                        _basemapOption(
                          context,
                          "Imagery",
                          BasemapStyle.arcGISImagery,
                        ),
                        _basemapOption(
                          context,
                          "Topographic",
                          BasemapStyle.arcGISTopographic,
                        ),
                        _basemapOption(
                          context,
                          "Navigation",
                          BasemapStyle.arcGISNavigation,
                        ),
                        _basemapOption(
                          context,
                          "Terrain",
                          BasemapStyle.arcGISTerrain,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: EnvironmentConfig.of(context)!.primaryTheme),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.dashboard_outlined, color: Colors.white,size: 21),
        ),
        FloatingActionButton(
          mini: true,
          tooltip: 'Map layer',
          backgroundColor: Theme.of(context).primaryColor,
          shape: StadiumBorder(),
          elevation: 0,
          onPressed: () {
            context.read<PgisBloc>().add(
              MapLayerEvent(ctx: context, controller: _mapViewController),
            );
          },
          child: Icon(Icons.layers, color: Colors.white,size: 21),
        ),
        FloatingActionButton(
          mini: true,
          tooltip: 'Zoom to location',
          backgroundColor: Theme.of(context).primaryColor,
          shape: StadiumBorder(),
          elevation: 0,
          onPressed: () {
            context.read<PgisBloc>().add(
              LocationEvent(controller: _mapViewController),
            );
          },
          child: Icon(Icons.my_location_rounded, color: Colors.white,size: 21),
        ),

        FloatingActionButton(
          mini: true,
          tooltip: 'search_rounded',
          backgroundColor: Theme.of(context).primaryColor,
          shape: StadiumBorder(),
          elevation: 0,
          onPressed: () {
            context.read<PgisBloc>().add(
              SearchRoundedEvent(
                ctx: context,
                arcGISMapViewController: _mapViewController,
              ),
            );
          },
          child: Icon(Icons.filter_alt_sharp, color: Colors.white,size: 21),
        ),
      ],
    );
  }

  Widget _buildMap({required FetchPgisDataState dataState}) {
    return ArcGISMapView(
      controllerProvider: () => _mapViewController,
      onMapViewReady: () {
        _mapViewController.interactionOptions.flingEnabled = false;
        context.read<PgisBloc>().add(PGISMapReady(_mapViewController));
      },
      onTap: (details) async {
        final bloc = context.read<PgisBloc>();
        bloc.add(
          IdentifyFeaturesAtTapEvent(
            context: context,
            controller: _mapViewController,
            offset: Offset(details.dx, details.dy),
          ),
        );
      },
    );
  }

  Widget _basemapOption(BuildContext context, String name, BasemapStyle style) {
    return InkWell(
      onTap: () {
        context.read<PgisBloc>().add(
          ChangeBasemapEvent(
            basemapStyle: style,
            controller: _mapViewController,
          ),
        );
        Navigator.pop(context); // close popup
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [Icon(Icons.map, color: EnvironmentConfig.of(context)!.primaryTheme,), SizedBox(width: 8), Text(name)]),
      ),
    );
  }
}
