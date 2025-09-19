import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/home/presentation/widget/app_bar_widget.dart';
import 'package:flutter_gail/feature/pgis/domain/bloc/pgis_bloc.dart';
import 'package:flutter_gail/utils/commonWidgets/SpinLoader.dart';

class PgisPage extends StatefulWidget {
  const PgisPage({super.key});

  @override
  State<PgisPage> createState() => _PgisPageState();
}

class _PgisPageState extends State<PgisPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PgisBloc>(
      context,
    ).add(PgisPageLoadedEvent(context: context));
  }

  final _mapViewController = ArcGISMapView.createController();
  TextEditingController textEditingController = TextEditingController();
  List<Map<String, dynamic>> attributeJsonList = [];

  @override
  void dispose() {
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
    return BlocBuilder<PgisBloc, PgisState>(
      builder: (context, state) {
        if (state is FetchPgisDataState) {
          return _itemBuilder(dataState: state);
        } else {
          return const Center(child: SpinLoader());
        }
      },
    );
  }

  Widget _itemBuilder({required FetchPgisDataState dataState}) {
    return Stack(
      children: [
        _buildMap(dataState: dataState),
        Visibility(
          visible: dataState.isNavigating,
          child: buildDirectionsWidget(),
        ),
        Positioned(
          right: 10,
          bottom: MediaQuery.of(context).size.height * 0.25,
          child: iconButtons(dataState: dataState),
        ),
        // Positioned(
        //   right: 0,
        //   left: 0,
        //   bottom: MediaQuery.of(context).size.height * 0.001,
        //   child: buildNavigationControls(dataState: dataState),
        // ),
        //   _locationField(dataState: dataState),
        //    Positioned(
        //      top: 0,
        //      left: 10,
        //      right: 10,
        //      child: PlaceSearchWidget(
        //          onPlaceSelected: (ArcGISPoint point) {
        //            _mapViewController.setViewpointCenter(
        //              point,
        //              scale: 10000,
        //            );
        //          }
        //      ),
        //    ),
        // _mapViewType(dataState: dataState),
      ],
    );
  }

  Widget buildDirectionsWidget() {
    final _directionsTextNotifier = ValueNotifier('Directions placeholder');
    return ValueListenableBuilder(
      valueListenable: _directionsTextNotifier,
      builder: (context, statusText, child) {
        print("statusText-------------------->${statusText}");
        return Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColor,
          ),
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              getDirectionIcon(statusText),
              Flexible(
                child: Text(
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  statusText,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getDirectionIcon(String statusText) {
    if (statusText.contains('forward')) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(Icons.straight, color: Colors.white, size: 50),
      );
    } else if (statusText.contains('right')) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(Icons.turn_right, color: Colors.white, size: 50),
      );
    } else if (statusText.contains('left')) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(Icons.turn_left, color: Colors.white, size: 50),
      );
    }
    return Icon(Icons.straight, color: Colors.white, size: 50);
  }

  Widget iconButtons({required FetchPgisDataState dataState}) {
    return Column(
      spacing: 15,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // FloatingActionButton(
        //   tooltip: 'Toggle voice guidance',
        //   backgroundColor: Theme.of(context).primaryColor,
        //   shape: StadiumBorder(),
        //   elevation: 0,
        //   onPressed: () {
        //     context.read<HomeBloc>().add(MuteVoiceGuidanceEvent());
        //   },
        //   child: Icon(
        //     dataState.isMuted ? Icons.volume_off_rounded : Icons.volume_up,
        //     color: Colors.white,
        //   ),
        // ),
        FloatingActionButton(
          tooltip: 'Zoom to location',
          backgroundColor: Theme.of(context).primaryColor,
          shape: StadiumBorder(),
          elevation: 0,
          onPressed: () {
            context.read<PgisBloc>().add(
              LocationEvent(controller: _mapViewController),
            );
          },
          child: Icon(Icons.my_location_rounded, color: Colors.white),
        ),

        FloatingActionButton(
          tooltip: 'search_rounded',
          backgroundColor: Theme.of(context).primaryColor,
          shape: StadiumBorder(),
          elevation: 0,
          //    onPressed: showWarnings,
          onPressed: () {
            context.read<PgisBloc>().add(
              SearchRoundedEvent(
                ctx: context,
                arcGISMapViewController: _mapViewController,
              ),
            );
          },
          child: Icon(Icons.filter_alt_sharp, color: Colors.white),
        ),
      ],
    );
  }

  Widget buildNavigationControls({required FetchPgisDataState dataState}) {
    return Container(

      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () async {
                // await initRoute();
                // await Future.delayed(const Duration(milliseconds: 200));
                // if (_route?.routeGeometry != null) {
                //   displayRoutePreview(_route!.routeGeometry!);
                // }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_rounded, color: Colors.black87),
                  Text(
                    'Directions',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ],
              ),
            ),
            FloatingActionButton(
              mini: true,
              elevation: 0,
              backgroundColor: Colors.white,
              shape: StadiumBorder(),
              onPressed: () async {
                // if (_distance == '0') {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(
                //         "Please get directions first before starting the navigation.",
                //       ),
                //       backgroundColor: Colors.red,
                //     ),
                //   );
                //   return;
                // }
                // dataState.isNavigating
                //     ? await stopNavigation()
                //     : await startNavigation();
              },
              child: Icon(
                dataState.isNavigating
                    ? Icons.stop_rounded
                    : Icons.navigation_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap({required FetchPgisDataState dataState}) {
    return ArcGISMapView(
        controllerProvider: () => _mapViewController,
        onMapViewReady: () {
          context.read<PgisBloc>().add(PgisMapReady(_mapViewController));
        },
        onTap: (details) async {
          final bloc = context.read<PgisBloc>();
          bloc.add(IdentifyFeaturesAtTapEvent(
            context: context,
            controller: _mapViewController,
            offset: Offset(details.dx, details.dy),
          ));
        }

    );
  }



  Widget _mapViewType({required FetchPgisDataState dataState}) {
    return Positioned(
      bottom: 50,
      right: 10,
      child: Card(
        shape: const CircleBorder(),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          onTap: () {
            BlocProvider.of<PgisBloc>(context).add(
              SelectMapArcGISStreets(
                isArcGISStreets: dataState.isArcGISStreets ? false : true,
              ),
            );
            _mapViewController.arcGISMap = ArcGISMap.withBasemapStyle(
              dataState.isArcGISStreets
                  ? BasemapStyle.arcGISStreets
                  : BasemapStyle.arcGISImagery,
            );
          },
          child: SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(
              dataState.isArcGISStreets
                  ? AppIcon.arcGISStreetsIcon
                  : AppIcon.arcGISImageryIcon,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }


  void dismissSearch() {
    // Clear the text field and dismiss the keyboard.
    textEditingController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
