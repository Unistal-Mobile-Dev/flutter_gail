import 'dart:async';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/incident/add_incident/domain/bloc/add_incident_bloc.dart';
import 'package:flutter_gail/feature/incident/add_incident/presentation/page/add_incident_page.dart';
import 'package:flutter_gail/feature/map/domain/bloc/map_bloc.dart';
import 'package:flutter_gail/feature/map/helper/map_helper.dart';
import 'package:flutter_gail/feature/task/addCrossing/domain/bloc/add_crossing_bloc.dart';
import 'package:flutter_gail/feature/task/addCrossing/presentation/page/add_crossing_page.dart';
import 'package:flutter_gail/feature/task/addEncroachment/domain/bloc/encroachment_bloc.dart';
import 'package:flutter_gail/feature/task/addEncroachment/presentation/page/encroachment_page.dart';
import 'package:flutter_gail/feature/task/addMarker/domain/bloc/add_marker_bloc.dart';
import 'package:flutter_gail/feature/task/addMarker/presentation/page/add_marker_page.dart';
import 'package:flutter_gail/feature/task/deviation/domain/bloc/deviation_bloc.dart';
import 'package:flutter_gail/feature/task/deviation/presentation/page/deviation_page.dart';
import 'package:flutter_gail/utils/commonClass/fade_route.dart';
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
      // if (_currentLatLng != null &&
      //     Geolocator.distanceBetween(
      //       _currentLatLng!.latitude,
      //       _currentLatLng!.longitude,
      //       newPos.latitude,
      //       newPos.longitude,
      //     ) <
      //         1) {
      //   return;
      // }

      context.read<MapBloc>().add(
        MapRouteLocationCheck(
          context: !context.mounted ? context : context,
          currentPoint: LatLng(newPos.latitude, newPos.longitude),
          speed: newPos.speed,
          verticalAccuracy: newPos.speedAccuracy,
        ),
      );

      /*      DateTime _lastLocationUpdate = DateTime.now();
      final mapData = BlocProvider.of<MapBloc>(context).mapData;
      final double buffer = (mapData.buffer is num)
          ? mapData.buffer.toDouble()
          : double.tryParse(mapData.buffer.toString()) ?? 0.0;

      final int timeInterval = (mapData.timeInterval is int)
          ? mapData.timeInterval
          : int.tryParse(mapData.timeInterval.toString()) ?? 5;
      final now = DateTime.now();
      if (mounted && now.difference(_lastLocationUpdate).inSeconds >= timeInterval) {
        _lastLocationUpdate = now;
         // check location start button
        context.read<MapBloc>().add(MapRouteLocationCheck(
          context: context,
          currentPoint: LatLng(newPos.latitude, newPos.longitude),
          speed: newPos.speed,
          verticalAccuracy: newPos.speedAccuracy
        ));
      }*/

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
                          color:   Colors.primaries[index % Colors.primaries.length],
                          width: 4,
                        );
                      }).toSet(),

                  /// ✅ Draw rounded buffer polygons (5m)
                  polygons: state.routes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final route = entry.value;
                        final polylinePoints =
                            route.map((p) => LatLng(p.y ?? 0.0, p.x ?? 0.0)).toList();
                        final mapData = BlocProvider.of<MapBloc>(context).mapData;
                        final link = AppConfig.instanceInit()?.groupRoles.link;
                        final double buffer = (mapData.buffer is num)
                                ? mapData.buffer.toDouble()
                                : double.tryParse(mapData.buffer.toString()) ?? 0.0;
                        final polygonPoints = MapHelper.createBufferPolygon(
                          polylinePoints,
                          buffer,
                        );

                        return Polygon(
                          polygonId: PolygonId('buffer_$index'),
                          points: polygonPoints,
                          fillColor: Colors.primaries[index % Colors.primaries.length].withOpacity(0.25),
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
                  SizedBox(height: MediaQuery.of(context).size.width * 0.03),
                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? _addMarkerButton()
                      : const SizedBox.shrink(),
                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      )
                      : const SizedBox.shrink(),

                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? _addCrossingButton()
                      : const SizedBox.shrink(),
                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      )
                      : const SizedBox.shrink(),

                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? _addIncidentButton()
                      : const SizedBox.shrink(),
                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      )
                      : const SizedBox.shrink(),

                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? _addEncroachmentButton()
                      : const SizedBox.shrink(),

                  dataState.taskData.taskStatus == TaskStatus.started ||
                          dataState.taskData.taskStatus == TaskStatus.resume
                      ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      )
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

  Widget _statusButton({required FetchMapPageDataState dataSate}) {
    return dataSate.taskData.taskStatus != TaskStatus.completed
        ? SizedBox(
          height: MediaQuery.of(context).size.width * 0.10,
          child: TextButton.icon(
            label: TextWidget(
              dataSate.taskData.taskStatus == TaskStatus.notStarted
                  ? AppString.start
                  : dataSate.taskData.taskStatus == TaskStatus.started
                  ? AppString.pause
                  : dataSate.taskData.taskStatus == TaskStatus.pause
                  ? AppString.resume
                  : dataSate.taskData.taskStatus == TaskStatus.resume
                  ? AppString.pause
                  : AppString.completed,
              color: AppColor.black,
              fontSize: AppFont.font_11,
            ),
            icon: Icon(
              Icons.task_outlined,
              color: AppColor.themeColor,
              size: MediaQuery.of(context).size.width * 0.05,
            ),
            onPressed: () {
              TaskStatus taskStatus = TaskStatus.notStarted;
              if (dataSate.taskData.taskStatus == TaskStatus.notStarted) {
                taskStatus = TaskStatus.started;
              } else if (dataSate.taskData.taskStatus == TaskStatus.started) {
                taskStatus = TaskStatus.pause;
              } else if (dataSate.taskData.taskStatus == TaskStatus.pause) {
                taskStatus = TaskStatus.resume;
              } else if (dataSate.taskData.taskStatus == TaskStatus.resume) {
                taskStatus = TaskStatus.pause;
              }
              BlocProvider.of<MapBloc>(context).add(
                MapPageUpdateTaskEvent(
                  context: context,
                  taskStatus: taskStatus,
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              elevation: WidgetStateProperty.all<double>(3.0),
              shadowColor: WidgetStateProperty.all<Color>(Colors.black),
            ),
          ),
        )
        : const SizedBox.shrink();
  }

  Widget _endPatrollingButton({required FetchMapPageDataState dataSate}) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget(
          AppString.end,
          color: AppColor.black,
          fontSize: AppFont.font_11,
        ),
        icon: Icon(
          Icons.task_outlined,
          color: AppColor.themeColor,
          size: MediaQuery.of(context).size.width * 0.05,
        ),
        onPressed: () {
          BlocProvider.of<MapBloc>(context).add(
            MapPageUpdateTaskEvent(
              context: context,
              taskStatus: TaskStatus.completed,
            ),
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

  Widget _addMarkerButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget(
          'Marker',
          color: AppColor.black,
          fontSize: AppFont.font_11,
        ),
        icon: Icon(
          Icons.location_searching_sharp,
          color: AppColor.themeColor,
          size: MediaQuery.of(context).size.width * 0.05,
        ),
        onPressed: () {
          BlocProvider.of<AddMarkerBloc>(
            context,
          ).add(AddMarkerPageLoadEvent(context: context, data: ""));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(page: const AddMarkerPage()),
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
        label: TextWidget(
          'Crossing',
          color: AppColor.black,
          fontSize: AppFont.font_11,
        ),
        icon: Icon(
          Icons.transgender_outlined,
          color: AppColor.themeColor,
          size: MediaQuery.of(context).size.width * 0.05,
        ),
        onPressed: () {
          BlocProvider.of<AddCrossingBloc>(
            context,
          ).add(AddCrossingPageLoadEvent(context: context));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(page: const AddCrossingPage()),
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
        label: TextWidget(
          'Add Incident',
          color: AppColor.black,
          fontSize: AppFont.font_11,
        ),
        icon: Icon(
          Icons.gpp_maybe_sharp,
          color: AppColor.cardBlue,
          size: MediaQuery.of(context).size.width * 0.05,
        ),
        onPressed: () async {
          BlocProvider.of<AddIncidentBloc>(
            context,
          ).add(AddIncidentPageLoadEvent(context: context));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(page: const AddIncidentPage()),
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

  Widget _addEncroachmentButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget(
          'Add Structures',
          color: AppColor.black,
          fontSize: AppFont.font_11,
        ),
        icon: Icon(
          Icons.fence_rounded,
          color: AppColor.themeColor,
          size: MediaQuery.of(context).size.width * 0.05,
        ),
        onPressed: () async {
          BlocProvider.of<EncroachmentBloc>(
            context,
          ).add(PageLoadEvent(context: context));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(page: const EncroachmentPage()),
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

  Widget _addDeviationButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: TextWidget(
          'Add Deviation',
          color: AppColor.black,
          fontSize: AppFont.font_11,
        ),
        icon: Icon(
          Icons.developer_board,
          color: AppColor.themeColor,
          size: MediaQuery.of(context).size.width * 0.05,
        ),
        onPressed: () async {
          BlocProvider.of<DeviationBloc>(
            context,
          ).add(DeviationPageLoadEvent(context: context));
          Navigator.push(
            !context.mounted ? context : context,
            FadeRoute(page: const DeviationPage()),
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

  Widget _recentButton() {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.10,
      child: TextButton.icon(
        label: const Text("Re-centre", style: TextStyle(color: Colors.black)),
        icon: const Icon(Icons.gps_fixed, color: Colors.blue),
        onPressed: _recenterCamera,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          elevation: WidgetStateProperty.all<double>(3.0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
      ),
    );
  }


}
