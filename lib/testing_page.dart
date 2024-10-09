import 'package:flutter/material.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'package:flutter_gail/feature/login/presentations/Widgets/header_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        setState(() {});
        getLocation();
      }
    }else{
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() { });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 0, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457
      print("Speed Accuracy ${position.speedAccuracy}");
      long = position.longitude.toString();
      lat = position.latitude.toString();
      _add();

      setState(() {
        //refresh UI on update
      });
    });
  }
  final double _headerHeight = 180;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
       backgroundColor: const Color(0xFF292C29),
        body:  SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true, Icons.person),
              ),
              SafeArea(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    margin: const EdgeInsets.fromLTRB(
                        20, 10, 20, 10), // This will be the login form
                    child:  Column(
                      children: [
                        Text(
                          'Welcome GoPlanners!',
                          style: TextStyle(
                              fontSize: 60,
                              color: Colors.indigoAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          decoration:BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.7),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            )
                          ]),
                          child: TextField(
                            decoration: textInputDecoration(
                                'User Name', 'Enter your user name'),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
    );
  }

  InputDecoration textInputDecoration([String lableText="", String hintText = ""]){
    return InputDecoration(
      labelText: lableText,
      hintText: hintText,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  void _add() {
    var markerIdVal = DateTime.now().timeZoneOffset.toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(lat),
        double.parse(long),
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        // _onMarkerTapped(markerId);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  Widget _marker() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: LatLng(-33.852, 151.211),
        zoom: 11.0,
      ),
      markers: Set<Marker>.of(markers.values), // YOUR MARKS IN MAP
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    const marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(9.669111, 80.014007),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[const MarkerId('place_name')] = marker;
    });
  }
}




class ShapeClipper extends CustomClipper<Path> {
  List<Offset> _offsets = [];
  ShapeClipper(this._offsets);
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height-20);

    // path.quadraticBezierTo(size.width/5, size.height, size.width/2, size.height-40);
    // path.quadraticBezierTo(size.width/5*4, size.height-80, size.width, size.height-20);

    path.quadraticBezierTo(_offsets[0].dx, _offsets[0].dy, _offsets[1].dx,_offsets[1].dy);
    path.quadraticBezierTo(_offsets[2].dx, _offsets[2].dy, _offsets[3].dx,_offsets[3].dy);

    // path.lineTo(size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.close();


    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}