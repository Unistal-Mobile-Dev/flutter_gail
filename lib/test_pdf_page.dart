import 'dart:convert';

import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gail/feature/map/helper/map_helper.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/domain/model/task_data_model.dart';
import 'package:flutter_gail/feature/taskManagement/viewTask/helper/view_task_helper.dart';

class TestPdfPage extends StatefulWidget {
  const TestPdfPage({super.key});

  @override
  State<TestPdfPage> createState() => _TestPdfPageState();
}

class _TestPdfPageState extends State<TestPdfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}

void main() async {
/*  List<ArcGISPoint> list =   MapHelper.decodePolyline("}xenDseuvM@KCGOIl@sA\\s@NMHg@j@Tf@Hf@L~B\\vADXS~BNfCNx@BzBRPJv@DNwD@Ub@B`BFrAF~BNf@JxDxAvClA~A`@`A`@dDtAxB|@nAj@xB~@tFxBhGjCbFxB|@`@zAl@lChAjBx@jAd@lAl@zG~ClEnB~D`BbBl@fCv@pB`@rAXz@VBUZkBTc@vA{BfAm@vCmAtAk@\\EvBu@x@_@l@c@d@c@hA}AX\\\\b@pB}B\\[LKLCX?j@Q|As@bAa@|Aq@lBm@fAWhAEf@IhBMjCOb@Ef@EfBU~@?`@GfDi@fFq@~AY`A]~@i@r@s@`AgAdAu@~G_Ht@q@nFoDtIcGtGsEbI}FxB_B|C{B`BoAhAw@|AaAp@g@dBmAjAq@xAo@t@UhBa@rBa@bGoArG{A~A]~DuA|CuB`McKpC{B\\SzH}GrAeAv@o@~@w@`DiChFkErAmAnB_BjBaBzHwGbDqCtCmC\\_@h@y@Ve@Xu@Pi@R{@TmBBeCSmFA]\\KbDaAjDyA~CmAvAe@pA]vCcAfFcB|EwA~@W`@QhE}AhEiAjDkASs@iBqH}@_Ea@cCYmBKGOUGKEi@BYO_@i@wBkAiFoByIa@}AIi@Sw@WiAq@eEm@yC}A}G{A}G{B_KkCwLo@yCIs@MqASeDIsF?}@B}B?k@?mC?cH?gFAcM@eCHqMBkG@yB@cE@qOJss@?_MBkNDgV@mW@wAUq@O[c@e@QO[Ow@WOSI]Ae@Jm@RUZWxDoCp@]fBg@d@Kz@KpA?hCFzFFzC@vH@~GTrBDfJb@hDJJ}ABaAt@kSLiEPyDP{Ep@uTJuDjCHxJd@nCPvI^vCRbCDfI^X?tBLJqD");
  for(var data in list){
    var json = {
      "login_id":"10",
      "lat": "${data.y}",
      "log": "${data.x}",
      "address":"Location",
      "date":"2024-11-19",
      "gps":"1","network":"1","battery":"100",
      "dt":"2024-11-19",
      "status":"1",
      "flight_mode":"0","distance":"1","geofencing":[]
    };
    print("${jsonEncode(json)},");
  }*/

}
