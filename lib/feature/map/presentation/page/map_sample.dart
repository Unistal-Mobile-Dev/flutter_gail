import 'dart:async';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/incident/add_incident/domain/bloc/add_incident_bloc.dart';
import 'package:flutter_gail/feature/incident/add_incident/presentation/page/add_incident_page.dart';
import 'package:flutter_gail/feature/map/domain/bloc/map_bloc.dart';
import 'package:flutter_gail/feature/map/helper/map_helper.dart';
import 'package:flutter_gail/feature/map/presentation/widget/text_button_icon_widget.dart';
import 'package:flutter_gail/feature/task/addAsset/domain/bloc/add_asset_bloc.dart';
import 'package:flutter_gail/feature/task/addAsset/presentation/page/add_asset_page.dart';
import 'package:flutter_gail/feature/task/addCrossing/domain/bloc/add_crossing_bloc.dart';
import 'package:flutter_gail/feature/task/addCrossing/presentation/page/add_crossing_page.dart';
import 'package:flutter_gail/feature/task/addEncroachment/domain/bloc/encroachment_bloc.dart';
import 'package:flutter_gail/feature/task/addEncroachment/presentation/page/encroachment_page.dart';
import 'package:flutter_gail/feature/task/addMarker/domain/bloc/add_marker_bloc.dart';
import 'package:flutter_gail/feature/task/addMarker/presentation/page/add_marker_page.dart';
import 'package:flutter_gail/feature/task/deviation/domain/bloc/deviation_bloc.dart';
import 'package:flutter_gail/feature/task/deviation/presentation/page/deviation_page.dart';
import 'package:flutter_gail/utils/commonClass/fade_route.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  CameraPosition? _initialCameraPosition;
  LatLng? _currentLatLng;

  Set<Marker> _markers = {};
  BitmapDescriptor? _personIcon;
  BitmapDescriptor? _directionIcon;
  BitmapDescriptor? _bpIcon;
  BitmapDescriptor? _kmIcon;
  BitmapDescriptor? _wmIcon;
  StreamSubscription<Position>? _positionStream;

  bool _isAutoFollow = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation();
    await _loadCustomMarker();
    await _loadDirectionMarker();
    await _loadBPMarker();
    await _loadKMMarker();
    await _loadWMMarker();
  }

  /// ✅ Load custom marker icon
  Future<void> _loadCustomMarker() async {
    final ByteData data = await rootBundle.load(
      'assets/ic_location_person.png',
    );
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 80,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? bytes = await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    _personIcon = BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// ✅ Load custom marker icon
  Future<void> _loadDirectionMarker() async {
    final ByteData data = await rootBundle.load(AppIcon.dmIcon);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 50,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? bytes = await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    _directionIcon = BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// ✅ Load custom marker icon
  Future<void> _loadBPMarker() async {
    final ByteData data = await rootBundle.load(AppIcon.bpIcon);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 50,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? bytes = await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    _bpIcon = BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// ✅ Load custom marker icon
  Future<void> _loadKMMarker() async {
    final ByteData data = await rootBundle.load(AppIcon.kmIcon);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 50,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? bytes = await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    _kmIcon = BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// ✅ Load custom marker icon
  Future<void> _loadWMMarker() async {
    final ByteData data = await rootBundle.load(AppIcon.wmIcon);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 50,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? bytes = await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    _wmIcon = BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// ✅ Get current location + listen to updates
  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.request();
    if (!status.isGranted) return;

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );

    final latLng = LatLng(position.latitude, position.longitude);
    setState(() {
      _currentLatLng = latLng;
      _initialCameraPosition = CameraPosition(target: latLng, zoom: 18.5);
    });

    // Update marker and center camera on start
    await _updateMarkerPosition(position, moveCamera: true);

    // Stream location updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position newPos) {
      context.read<MapBloc>().add(
        MapRouteLocationCheck(
          context: !context.mounted ? context : context,
          currentPoint: LatLng(newPos.latitude, newPos.longitude),
          speed: newPos.speed,
          verticalAccuracy: newPos.speedAccuracy,
        ),
      );

      _updateMarkerPosition(newPos, moveCamera: _isAutoFollow);
    });
  }

  /// ✅ Update marker + camera follow
  Future<void> _updateMarkerPosition(
    Position pos, {
    bool moveCamera = false,
  }) async {
    final newLatLng = LatLng(pos.latitude, pos.longitude);
    final controller = await _controller.future;

    setState(() {
      _currentLatLng = newLatLng;
      _markers = {
        Marker(
          markerId: const MarkerId("current_location"),
          position: newLatLng,
          icon: _personIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: "You are here"),
          rotation: pos.heading,
          anchor: const Offset(0.5, 0.5),
        ),
      };
    });

    if (moveCamera && mounted) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newLatLng,
            zoom: 18.5,
            bearing: pos.heading,
            tilt: 45,
          ),
        ),
      );
    }
  }

  /// ✅ Resume auto-follow and re-center camera
  Future<void> _recenterCamera() async {
    if (_currentLatLng == null) return;
    final controller = await _controller.future;
    setState(() => _isAutoFollow = true);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLatLng!, zoom: 18.5, tilt: 45),
      ),
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialCameraPosition == null) {
      return const Scaffold(body: Center(child: CenterLoaderWidget()));
    }

    return Scaffold(
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is FetchMapPageDataState) {
            return Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  compassEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: _initialCameraPosition!,
                  markers: {
                    ..._markers,
                    ...state.routePointsList.expand((route) {
                      // 🟦 Marker Points
                      final markerPoints = route.markerList.map((marker) {
                        return Marker(
                          markerId: MarkerId(
                            'marker_${marker.gpsy.toString()}',
                          ),
                          position: LatLng(
                            double.parse(marker.gpsy.toString()),
                            double.parse(marker.gpsx.toString()),
                          ),
                          infoWindow: InfoWindow(
                            title: marker.markerName ?? "Marker",
                          ),
                          icon:
                              marker.markerType.toString() == "1"
                                  ? _bpIcon ?? BitmapDescriptor.defaultMarker
                                  : marker.markerType.toString() == "12"
                                  ? _kmIcon ?? BitmapDescriptor.defaultMarker
                                  : marker.markerType.toString() == "15"
                                  ? _wmIcon ?? BitmapDescriptor.defaultMarker
                                  : marker.markerType.toString() == "8"
                                  ? _directionIcon ??
                                      BitmapDescriptor.defaultMarker
                                  : BitmapDescriptor.defaultMarker,
                        );
                      });

                      // 🟢 TLPs
                      final tlpMarkers =
                          route.tlpList
                              .where(
                                (tlp) =>
                                    tlp.id != null &&
                                    tlp.gpsx != null &&
                                    tlp.gpsy != null,
                              )
                              .map(
                                (tlp) => Marker(
                                  markerId: MarkerId(
                                    'tlp_${route.sectionCode}_${tlp.id}',
                                  ),
                                  position: LatLng(tlp.gpsy!, tlp.gpsx!),
                                  // Note: Check if gpsx = longitude, gpsy = latitude
                                  infoWindow: InfoWindow(
                                    title: tlp.type ?? "TLP",
                                  ),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueGreen,
                                  ),
                                ),
                              )
                              .toList();

                      return [...markerPoints, ...tlpMarkers];
                    }),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controller.isCompleted)
                      _controller.complete(controller);
                  },
                  onCameraMoveStarted: () {
                    // 👇 Stop auto-follow when user moves camera
                    if (_isAutoFollow) setState(() => _isAutoFollow = false);
                  },

                  /// ✅ Draw multiple colored polylines
                  polylines:
                      state.routes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final route = entry.value;
                        final polylinePoints =
                            route
                                .map((p) => LatLng(p.y ?? 0.0, p.x ?? 0.0))
                                .toList();

                        return Polyline(
                          polylineId: PolylineId('route_$index'),
                          points: polylinePoints,
                          color:
                              Colors.primaries[index % Colors.primaries.length],
                          width: 4,
                        );
                      }).toSet(),

                  /// ✅ Draw rounded buffer polygons (5m)
                  polygons:
                      state.routes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final route = entry.value;
                        final polylinePoints =
                            route
                                .map((p) => LatLng(p.y ?? 0.0, p.x ?? 0.0))
                                .toList();
                        final mapData =
                            BlocProvider.of<MapBloc>(context).mapData;
                        final link = AppConfig.instanceInit()?.groupRoles.link;
                        final double buffer =
                            (mapData.buffer is num)
                                ? mapData.buffer.toDouble()
                                : double.tryParse(mapData.buffer.toString()) ??
                                    0.0;
                        final polygonPoints = MapHelper.createBufferPolygon(
                          polylinePoints,
                          buffer,
                        );

                        return Polygon(
                          polygonId: PolygonId('buffer_$index'),
                          points: polygonPoints,
                          fillColor: Colors
                              .primaries[index % Colors.primaries.length]
                              .withOpacity(0.25),
                          strokeColor: Colors.transparent,
                          strokeWidth: 0,
                        );
                      }).toSet(),
                ),
                _actionButtons(dataState: state),
              ],
            );
          } else {
            return const Center(child: CenterLoaderWidget());
          }
        },
      ),
    );
  }

  /// ✅ Recenter + action buttons
  Widget _actionButtons({required FetchMapPageDataState dataState}) {
    return Positioned(
      top: 50,
      left: 10,
      child:
          dataState.isLoader == false
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _backButton(),

                  dataState.isStartPatrolling == true
                      ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      )
                      : const SizedBox.shrink(),

                  dataState.isStartPatrolling == true
                      ? _statusButton(dataSate: dataState)
                      : const SizedBox.shrink(),
                  dataState.taskData.taskStatus != TaskStatus.notStarted && dataState.taskData.taskStatus != TaskStatus.completed
                      ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      )
                      : const SizedBox.shrink(),

                  dataState.taskData.taskStatus != TaskStatus.notStarted && dataState.taskData.taskStatus != TaskStatus.completed
                      ? _endPatrollingButton(dataSate: dataState)
                      : const SizedBox.shrink(),

                  dataState.isStartPatrolling == false &&
                          dataState.isEndPatrolling == false
                      ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      )
                      : const SizedBox.shrink(),

                  //  dataState.isStartPatrolling == false &&
                  //      dataState.isEndPatrolling == false ?
                  // _navigationButton(dataState: dataState)
                  //      : const SizedBox.shrink(),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.03),
                  _recentButton(),
                  _vertical(),
                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? _addMarkerButton()
                      : const SizedBox.shrink(),
                  // dataState.taskData.taskStatus == TaskStatus.started ||
                  //         dataState.taskData.taskStatus == TaskStatus.resume
                  //     ? SizedBox(
                  //       height: MediaQuery.of(context).size.width * 0.03,
                  //     )
                  //     : const SizedBox.shrink(),

                  // dataState.taskData.taskStatus == TaskStatus.started ||
                  //         dataState.taskData.taskStatus == TaskStatus.resume
                  //     ? _addCrossingButton()
                  //     : const SizedBox.shrink(),
                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? _vertical()
                      : const SizedBox.shrink(),

                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? _addIncidentButton()
                      : const SizedBox.shrink(),
                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? _vertical()
                      : const SizedBox.shrink(),

                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? _addEncroachmentButton()
                      : const SizedBox.shrink(),

                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? _vertical()
                      : const SizedBox.shrink(),

                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? _addDeviationButton()
                      : const SizedBox.shrink(),
                ],
              )
              : const DottedLoaderWidget(),
    );
  }

  Widget _backButton() {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
    );
  }

  // Widget _addMarkerButton() {
  //   return SizedBox(
  //     height: MediaQuery.of(context).size.width * 0.10,
  //     child: TextButton.icon(
  //       label: TextWidget(
  //         'Marker',
  //         color: AppColor.black,
  //         fontSize: AppFont.font_11,
  //       ),
  //       icon: Icon(
  //         Icons.location_searching_sharp,
  //         color: EnvironmentConfig.of(context)!.primaryTheme,
  //         size: MediaQuery.of(context).size.width * 0.05,
  //       ),
  //       onPressed: () {
  //         BlocProvider.of<AddMarkerBloc>(
  //           context,
  //         ).add(AddMarkerPageLoadEvent(context: context, data: ""));
  //         Navigator.push(
  //           !context.mounted ? context : context,
  //           FadeRoute(page: const AddMarkerPage()),
  //         );
  //       },
  //       style: ButtonStyle(
  //         backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
  //         foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
  //         elevation: WidgetStateProperty.all<double>(3.0),
  //         shadowColor: WidgetStateProperty.all<Color>(Colors.black),
  //       ),
  //     ),
  //   );
  // }

  Widget _statusButton({required FetchMapPageDataState dataSate}) {
    final current = dataSate.taskData.taskStatus;

    return TextButtonIconWidget(
      visible: current != TaskStatus.completed,
      icon: Icons.task_outlined,
      label: switch (current) {
        TaskStatus.notStarted => AppString.start,
        TaskStatus.started => AppString.pause,
        TaskStatus.pause => AppString.resume,
        TaskStatus.resume => AppString.pause,
        _ => AppString.completed,
      },
      onPressed: () {
        final next = switch (current) {
          TaskStatus.notStarted => TaskStatus.started,
          TaskStatus.started => TaskStatus.pause,
          TaskStatus.pause => TaskStatus.resume,
          TaskStatus.resume => TaskStatus.pause,
          _ => TaskStatus.notStarted,
        };
        BlocProvider.of<MapBloc>(
          context,
        ).add(MapPageUpdateTaskEvent(context: context, taskStatus: next));
      },
    );
  }

  Widget _endPatrollingButton({required FetchMapPageDataState dataSate}) {
    return TextButtonIconWidget(
      label: AppString.end,
      icon: Icons.task_outlined,
      onPressed: () {
        BlocProvider.of<MapBloc>(context).add(
          MapPageUpdateTaskEvent(
            context: context,
            taskStatus: TaskStatus.completed,
          ),
        );
      },
    );
  }

  Widget _addMarkerButton() {
    return TextButtonIconWidget(
      label: 'Asset',
      icon: Icons.location_searching_sharp,
      onPressed: _showMarkerOptions,
    );
  }
  /// ✅ Bottom sheet with Marker / Asset options
  void _showMarkerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.location_searching_sharp,
                    color: EnvironmentConfig.of(context)!.primaryTheme,
                  ),
                  title: const Text('Marker'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openAddMarker();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.inventory_2_outlined,
                    color: EnvironmentConfig.of(context)!.primaryTheme,
                  ),
                  title: const Text('Asset'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openAddAsset();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ✅ Existing marker flow
  void _openAddMarker() {
    if (!mounted) return;
    BlocProvider.of<AddMarkerBloc>(context)
        .add(AddMarkerPageLoadEvent(context: context, data: ""));
    Navigator.push(context, FadeRoute(page: const AddMarkerPage()));
  }

  /// ✅ Asset flow
  void _openAddAsset() {
    if (!mounted) return;

    // // Option A: reuse AddMarkerPage and tell it this is an asset
    // BlocProvider.of<AddMarkerBloc>(context)
    //     .add(AddMarkerPageLoadEvent(context: context, data: "marker"));
    // Navigator.push(context, FadeRoute(page: const AddMarkerPage()));

   // Option B: if you have a separate asset screen, use that instead:
    BlocProvider.of<AddAssetBloc>(context)
        .add(AddAssetPageLoadEvent(context: context, data: ""));
    Navigator.push(context, FadeRoute(page: const AddAssetPage()));
  }

  Widget _addCrossingButton() {
    return TextButtonIconWidget(
      label: 'Crossing',
      icon: Icons.transgender_outlined,
      onPressed: () {
        BlocProvider.of<AddCrossingBloc>(
          context,
        ).add(AddCrossingPageLoadEvent(context: context));
        Navigator.push(context, FadeRoute(page: const AddCrossingPage()));
      },
    );
  }

  Widget _addIncidentButton() {
    return TextButtonIconWidget(
      label: 'Report Incident',
      icon: Icons.gpp_maybe_sharp,
      iconColor: AppColor.cardBlue,
      onPressed: () {
        BlocProvider.of<AddIncidentBloc>(
          context,
        ).add(AddIncidentPageLoadEvent(context: context));
        Navigator.push(context, FadeRoute(page: const AddIncidentPage()));
      },
    );
  }

  Widget _addEncroachmentButton() {
    return TextButtonIconWidget(
      label: 'Add Structures',
      icon: Icons.fence_rounded,
      onPressed: () {
        BlocProvider.of<EncroachmentBloc>(
          context,
        ).add(PageLoadEvent(context: context));
        Navigator.push(context, FadeRoute(page: const EncroachmentPage()));
      },
    );
  }

  Widget _addDeviationButton() {
    return TextButtonIconWidget(
      label: 'Add Deviation',
      icon: Icons.developer_board,
      onPressed: () {
        BlocProvider.of<DeviationBloc>(
          context,
        ).add(DeviationPageLoadEvent(context: context));
        Navigator.push(context, FadeRoute(page: const DeviationPage()));
      },
    );
  }

  Widget _recentButton() {
    return TextButtonIconWidget(
      label: 'Re-centre',
      fontSize: 13,
      icon: Icons.gps_fixed,
      iconColor: Colors.blue,
      onPressed: _recenterCamera,
    );
  }

  _vertical() {
    return SizedBox(height: MediaQuery.of(context).size.width * 0.03);
  }
}
