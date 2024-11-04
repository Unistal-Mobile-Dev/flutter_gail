import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/incident/add_incident/domain/bloc/add_incident_bloc.dart';
import 'package:flutter_gail/feature/incident/add_incident/presentation/page/add_incident_page.dart';
import 'package:flutter_gail/feature/map/domain/bloc/map_bloc.dart';
import 'package:flutter_gail/feature/map/presentation/widget/sample_state_support.dart';
import 'package:flutter_gail/feature/task/addCrossing/domain/bloc/add_crossing_bloc.dart';
import 'package:flutter_gail/feature/task/addCrossing/presentation/page/add_crossing_page.dart';
import 'package:flutter_gail/feature/task/addMarker/domain/bloc/add_marker_bloc.dart';
import 'package:flutter_gail/feature/task/addMarker/presentation/page/add_marker_page.dart';
import 'package:flutter_gail/pdf_helper.dart';
import 'package:flutter_gail/utils/commonClass/fade_route.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SampleStateSupport {

  final _mapViewController = ArcGISMapView.createController();
  final _locationDataSource = SystemLocationDataSource();
  StreamSubscription? _statusSubscription;
  var _status = LocationDataSourceStatus.stopped;
  StreamSubscription? _autoPanModeSubscription;
  var _autoPanMode = LocationDisplayAutoPanMode.recenter;
  var _ready = false;

  final _stopsGraphicsOverlay = GraphicsOverlay();
  final _routeGraphicsOverlay = GraphicsOverlay();
  final _locationHistoryLineOverlay = GraphicsOverlay();
  final _locationHistoryPointOverlay = GraphicsOverlay();


  @override
  void initState() {
    BlocProvider.of<MapBloc>(context)
        .add(MapPageLoadEvent(context: context));
    super.initState();
  }

  @override
  void dispose() {
    _locationDataSource.stop();
    _statusSubscription?.cancel();
    _autoPanModeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            ArcGISMapView(
              controllerProvider: () => _mapViewController,
              onMapViewReady: onMapViewReady,
              onTap: onTap,
            ),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  void onTap(Offset localPosition) async {
    final identifyGraphicsOverlayResult =
    await _mapViewController.identifyGraphicsOverlay(
      _stopsGraphicsOverlay,
      screenPoint: localPosition,
      tolerance: 22,
    );

    if (identifyGraphicsOverlayResult.graphics.isEmpty) return;
    if (mounted) {
      for(var data in identifyGraphicsOverlayResult.graphics){
         print(data.attributes.toString());
      }
      final graphic = identifyGraphicsOverlayResult.graphics.first;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(graphic.attributes.toString()));
        },
      );
    }
  }

Widget _actionButtons(){
    return Positioned(
      top: 50,
      left: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _backButton(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          _navigationButton(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          _recentButton(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          _addMarkerButton(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          _addCrossingButton(),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          _addIncidentButton(),
        ],
      ),
    );
  }

  Widget _backButton() {
    return IconButton(onPressed: () {
      Navigator.pop(context);
    }, icon: Icon(Icons.arrow_back_ios,
      color: AppColor.black,)
    );
  }

  Widget _navigationButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget('Navigation',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.navigation, color: AppColor.themeSecondary,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () {
          _mapViewController.locationDisplay.autoPanMode =
              LocationDisplayAutoPanMode.navigation;
          _autoPanModeSubscription = _mapViewController.locationDisplay.onAutoPanModeChanged.listen((mode) {
            setState(() => _autoPanMode = mode);
          });
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }

  Widget _recentButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget('Re-centre',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.location_history, color: Colors.blueAccent,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () {
          currentLocation();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }

  Widget _addMarkerButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget('Marker',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.location_searching_sharp, color: AppColor.themeColor,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () {
          BlocProvider.of<AddMarkerBloc>(context).add(AddMarkerPageLoadEvent(context: context));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(
                page: const AddMarkerPage()),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }

  Widget _addCrossingButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget('Crossing',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.transgender_outlined, color: AppColor.themeColor,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () {
               BlocProvider.of<AddCrossingBloc>(context)
                   .add(AddCrossingPageLoadEvent(context: context));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(
                page: const AddCrossingPage()),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }

  Widget _addIncidentButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget('Add Incident',
          color: AppColor.black,
          fontSize: AppFont.font_11,),
        icon: Icon(Icons.gpp_maybe_sharp, color: AppColor.cardBlue,
          size: MediaQuery.of(context).size.width * 0.05,),
        onPressed: () async {
          BlocProvider.of<AddIncidentBloc>(context).add(AddIncidentPageLoadEvent(context: context));
/*          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(
                page: const AddIncidentPage()),
          );*/
        PdfHelper.createPolyLine();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }

  void onMapViewReady() async{

    _mapViewController.arcGISMap =
        ArcGISMap.withBasemapStyle(BasemapStyle.arcGISStreets);
    _mapViewController.graphicsOverlays.add(_routeGraphicsOverlay);
    _mapViewController.graphicsOverlays.add(_stopsGraphicsOverlay);
    final imageStart = await ArcGISImage.fromAsset(AppIcon.startLocationIcon);
    final routeStartPointMarker = PictureMarkerSymbol.withImage(imageStart)
      ..width = 20
      ..height = 20;

    final imageEnd = await ArcGISImage.fromAsset(AppIcon.endLocationIcon);
    final routeEndPointMarker = PictureMarkerSymbol.withImage(imageEnd)
      ..width = 20
      ..height = 20;

    final startPoint1 = Viewpoint.withLatLongScale(
      latitude: 28.611783,
      longitude: 77.385932,
      scale: 2e4,
    );

    final endPoint1 = Viewpoint.withLatLongScale(
      latitude: 28.609494,
      longitude: 77.384517,
      scale: 2e4,
    );

    Map<String, dynamic> attributes1 = {"id" :1};
    Map<String, dynamic> attributes2 = {"id" :2};

    _stopsGraphicsOverlay.graphics.addAll([
      Graphic(geometry: startPoint1.targetGeometry, symbol: routeStartPointMarker, attributes: attributes1),
      Graphic(geometry: endPoint1.targetGeometry, symbol: routeEndPointMarker, attributes: attributes2),
    ]);
    _initPolyline();
  }

  Future<void> _initPolyline() async {

    _locationHistoryLineOverlay.renderer = SimpleRenderer(
      symbol: SimpleLineSymbol(
        color: Colors.red[100]!,
        width: 2.0,
      ),
    );
    _locationHistoryPointOverlay.renderer = SimpleRenderer(
      symbol: SimpleMarkerSymbol(
        color: Colors.red,
        size: 10.0,
      ),
    );

    _mapViewController.graphicsOverlays.addAll([
      _locationHistoryLineOverlay,
      _locationHistoryPointOverlay,
    ]);

    _mapViewController.locationDisplay.onLocationChanged.listen((onData) {
       print(onData.position.x.toString()); //  long
       print(onData.position.y.toString()); // lat
    });
    _startLocationDataSource();
    setState(() {});
  }

  Future<void> _startLocationDataSource() async {
    final routeLineJson =
    await rootBundle.loadString('assets/SimulatedRoute.json');
    final routeLine = Geometry.fromJsonString(routeLineJson) as Polyline;

    final routeLineSymbol = SimpleLineSymbol(
      style: SimpleLineSymbolStyle.dashDot,
      color: Colors.blue,
      width: 2.0,
    );

    final routeLineSymbol1 = SimpleLineSymbol(
      style: SimpleLineSymbolStyle.solid,
      color: Colors.red.withOpacity(0.2),
      width: 20.0,

    );

    final routeGraphic =
    Graphic(geometry: routeLine, symbol: routeLineSymbol,);
    _routeGraphicsOverlay.graphics.add(routeGraphic);

    final routeGraphic1 =
    Graphic(geometry: routeLine, symbol: routeLineSymbol1);
    _routeGraphicsOverlay.graphics.add(routeGraphic1);
    currentLocation();

    setState(() {});
  }

  void currentLocation() async {

    _mapViewController.locationDisplay.dataSource = _locationDataSource;
    _mapViewController.locationDisplay.autoPanMode = LocationDisplayAutoPanMode.recenter;

    // final imageEnd = await ArcGISImage.fromAsset(AppIcon.gpsMovedIcon);
    // final routeEndPointMarker = PictureMarkerSymbol.withImage(imageEnd)
    //   ..width = 35
    //   ..height = 35;
    //
    // _mapViewController.locationDisplay.courseSymbol = routeEndPointMarker;

    _statusSubscription = _locationDataSource.onStatusChanged.listen((status) {
      setState(() => _status = status);
    });

    setState(() => _status = _locationDataSource.status);

    _autoPanModeSubscription = _mapViewController.locationDisplay.onAutoPanModeChanged.listen((mode) {
          setState(() => _autoPanMode = mode);
        });

    setState(() => _autoPanMode = _mapViewController.locationDisplay.autoPanMode);
    try {

      // final imageStart = await ArcGISImage.fromAsset(AppIcon.startLocationIcon);
      // final routeStartPointMarker = PictureMarkerSymbol.withImage(imageStart)
      //   ..width = 35
      //   ..height = 35;
      // _stopsGraphicsOverlay.graphics.addAll([
      //   Graphic(geometry: ArcGISPoint(
      //     x: 80.689667,
      //     y:20.263066,
      //     spatialReference: SpatialReference.wgs84,
      //   ), symbol: routeStartPointMarker)
      // ]);

        await _locationDataSource.start();
    } on ArcGISException catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(content: Text(e.message)),
        );
      }
    }
    setState(() => _ready = true);
  }

}