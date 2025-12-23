import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/pgis/domain/bloc/pgis_bloc.dart';
import 'package:flutter_gail/feature/pgis/presentation/widget/show_station_table_widget.dart';
import 'package:flutter_gail/utils/commonWidgets/SpinLoader.dart';

class PgisPage extends StatefulWidget {
  const PgisPage({super.key});

  @override
  State<PgisPage> createState() => _PgisPageState();
}

class _PgisPageState extends State<PgisPage> {
  late Timer _rotationTimer;
  ValueNotifier<double> _rotationNotifier = ValueNotifier(0);

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
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          right: 10,
          child:_rotationButton(),
        ),
        Positioned(
          right: 10,
          bottom: MediaQuery.of(context).size.height * 0.25,
          child: _iconButtons(dataState: dataState),
        ),
      //  if (dataState.stationList.isNotEmpty)
          Positioned(
          right: 10,
          bottom: MediaQuery.of(context).size.height * 0.10,
          child: FloatingActionButton(
            tooltip: 'Show Stations',
            onPressed: () {
           //   if (dataState.stationList.isNotEmpty) {
                ShowStationTable.showStationTable(
                  context: context,
                  stations: dataState.stationList,
                  controller: _mapViewController,
                );
            //  }
            },
            child: Icon(Icons.list),
          ),
        ),

      ],
    );
  }

  _rotationButton(){
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
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 6),
                ],
              ),
              child: Icon(Icons.navigation, color: Colors.red, size: 32),
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
          tooltip: 'Map layer',
          backgroundColor: Theme.of(context).primaryColor,
          shape: StadiumBorder(),
          elevation: 0,
          onPressed: () {
            context.read<PgisBloc>().add(
              MapLayerEvent(ctx: context, controller: _mapViewController),
            );
          },
          child: Icon(Icons.layers, color: Colors.white),
        ),
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
        _mapViewType(dataState: dataState),

      ],
    );
  }

  Widget _buildMap({required FetchPgisDataState dataState}) {
    return ArcGISMapView(
      controllerProvider: () => _mapViewController,
      onMapViewReady: () {

        context.read<PgisBloc>().add(PGISMapReady(_mapViewController));
      },
      onTap: (details) async {

        final bloc = context.read<PgisBloc>();
        bloc.add(IdentifyFeaturesAtTapEvent(
            context: context,
            controller: _mapViewController,
            offset: Offset(details.dx, details.dy),
          ),
        );
      },
    );
  }

  Widget _mapViewType({required FetchPgisDataState dataState}) {
    return Card(
      shape: const CircleBorder(),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<PgisBloc>(context).add(
            SelectMapArcGISStreets(
              isArcGISStreets: !dataState.isArcGISStreets,
              controller: _mapViewController,
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
    );
  }

}
