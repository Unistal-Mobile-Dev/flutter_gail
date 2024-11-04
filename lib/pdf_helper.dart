import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_gail/services/location/location_helper.dart';
import 'package:flutter_gail/utils/commonClass/directory_util.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'dart:math' as math show pow;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:fixnum/fixnum.dart';

class PdfHelper {


  static Future<dynamic> createPolyLine() async {
    try{

      var encodePloyLine = PolylineCodec.encode([[27.488592219198303,95.38253265223325], [27.489379586844993,95.38314414154719], [27.489434684795622,95.38318749818922]]);
      print(encodePloyLine);
      String value =  "}trhBscw}LEBGD_@ZA??????????@??????jGhJ????????????????HCTGVI`@M\\Kd@OPGZKZITIVI^KXIVIVIXIXK`@K\\MZIXIXINE\\Kd@MNENE`@O`@MTIRGTIZKf@QVI\\KRIb@M\\M^MTIZK^KNGRGVIHC`@O^M^Mf@Qb@MZK^MXKXI`@MTIVGVIVIXKXI\\KZIZKZKXIZMXKVITKZKVKj@QVGXITIRGZK\\KVITGRGVKRGTIn@UNIDCBA@ADE@A@ADGFIHIFIHIDIDGDMDKDMDKBKBGBIBK@G@K?QBYB[Di@dAyJDc@Jm@RyAHk@Hk@Hc@Hc@Lg@DMNi@Ja@J_@Le@La@JYFMLQNSTULMHGLIPGREVEXEl@GNAdAMPCPCRExGkANEXKh@Qh@Qn@Uz@Yl@Sb@OVK\\Kt@Wp@Uj@SJEJCFEFEJKLIDEDCDEDEFEBCDEFEDCLMDETSlAaATSf@a@\\[VS\\Y^[VUTQ\\Y\\[JIFEDCFGDEDCDIBEDGDIFKBEHMXg@Va@T]Vc@PYRY^o@JQPWHMn@iAVa@Ze@Zk@@A@C?A@CDKBG@EDKPi@Lc@J]J[ZeANa@Pg@ZcANa@JWJ]FOFUBGBKBEDOHWDMBGBEDGDGFEBCDEJKb@c@FEPSb@c@b@a@d@e@Z]x@w@d@c@\\]JKv@u@\\]\\_@l@k@VU\\]\\]PQNOFGBCDEDEDEDEDGFKDKDMb@iADM`@eAPc@^cAx@wBPa@Ri@`@gA^cA^aATm@Pg@N[JUHKDEHGJIJIDCNIVQRMfAy@b@]ZW`@]\\Wh@c@ZYXUXW\\Y`@[^[f@_@^[\\YTSLQJWN]P_@Zq@Re@BG@A?C?C?AWyAAC?A?C@A@C?A@ABCXWXWX[XYX[`@c@b@e@Z_@Za@Xg@Zg@Vc@T_@`@s@NWZk@Zi@T_@R]FM\\m@\\m@\\k@Zi@d@w@Zc@d@i@f@k@f@m@X_@`@m@NWHKVYNMJKFEHEFEVMLGRMb@URKPKRKPKpCqAn@YPGZOlAk@\\QHCVMl@YVK^MJENGHEXMJGXMd@U^Q^Q\\QZOZOf@U|@a@DCd@SbAe@f@Wh@UZOPIf@S\\Ob@Ud@Uh@Ud@Ud@Sd@Sd@Ul@W`Ae@`@Qr@[h@Wb@Sd@S`@SXMl@WZOb@W`@U`@Sh@]`@Uj@]d@Yh@[l@]RMZSb@WXQb@WZQb@YZS^S^SVQ`Ak@`@W^S`@W^UZS`Ak@^Uf@Yb@W^UZQd@YXQVO\\WNIRQ@ARWTWVYFIDC@CBCBCDCf@[`@S^QZOd@Sb@S^Q\\Q^QTMZOZQTOj@Yb@WXMHGBABCBADABABCBABCBC@CDGV_@Va@HKXc@Zg@T]V_@BCDIBEBGBGXm@JSNYTk@HQP_@P]JUPa@N[HQFSFUHSFUFSFUHQFUFSHSFUBI@ADM?CBEBK@E?A?A?A?A?AACi@iBAE?A???A?A??@ADENSt@eALQt@eAZc@LQXa@h@s@PWn@}@\\g@RY`@k@Zc@LYL]H]BU?UCWCYEUESQ[MWEGGKAECECEGOGKACEIEECEGEEEEEYUGGGI[U[[a@Yg@_@KGKIY[U]W]UYU[k@w@KOEEEEEICECECGCICGEMK_@yAuEUq@]{@Ys@Ys@O]CGEIEIEGEGIGWUMO_@[a@_@_@]e@_@[YIIGIEGCGIMGKGKKSKQGKACAC?C?C?O?U?S?m@@yA?k@?U?Q@Q?KBU@KBQ@G@Q?O?IAGKi@GSGUIQS[SWKQMQW_@CEMOEIEGGMMa@Oa@Qg@M_@EMEICKCMEOCOCIGUGWAE?I?EAI@G?E@K@C@WB[B]Be@Da@Dk@Ba@Dk@@S@O@I?G?G?GAKAGEUMq@Ia@GYIg@Mk@CICKEKMUMOAAIIGEWY][SWUSYYc@e@]YIIUWe@e@a@a@c@c@a@_@]]_@_@EGGGGEGGCEEEKICECCEGGMCICIACQaAO}@Km@Km@Ig@Ms@COEWCOKm@Kk@Oa@IQM[Wo@Ui@CGCIEIEICGGKIOk@k@e@i@c@c@a@c@k@k@]a@g@g@e@g@g@i@]]a@c@SUGEe@g@UU_@_@QUYYc@e@WW_@a@]_@][_@a@]_@_@_@c@e@w@{@UWeAgA[[_@a@c@e@a@a@IMIGEEKGKGOIOGc@S_@Qk@Ws@Ye@Uk@Uo@Yg@Uq@[m@W{@_@_Ac@w@]o@Wm@Wk@Wa@QIEMEMGKGGAWK_@YKMEIIQGKIQQ_@IQIOGWCWAWEe@?WBWBa@B[BYFYFY@IBOAIAICGEGs@y@q@u@m@o@aA_Au@s@w@w@a@e@g@o@]a@]c@aAmA_@a@i@q@iC}CkB{Bg@o@a@i@a@g@KMg@q@[c@Y[SWSWOQ_@e@u@y@_@c@Y]uYe^]_@w@aAo@w@QSWYEECGCGAG?G?IBSDW@I@O?KA[GSEMMQEEGGIEIEGCGEGCGC}Bu@[GQCE?OEIAEEGCMKKMKIIIOMOEQGMAQ?I?E?K?W@Y?sA@O?w@@oA@Q?i@@U?K?O?S?iABO?O?E?W@Q?Q?U@Q?G?K?I?M?M?OAO?Y?UAG?O?QAO?K?U?OAQ?M?QAU?Q?OAO?[?UAY?Q?QA]AW?O?WA_@?[AK?q@AOAS?WAW?SAW?YA{A?UAU?SASAY?SAO?eAAU?oCESAO?M?MAMCKCWG]KWGSGUGYIUGQE[ISGYIUGWG[IUG]KQEICSEUEUCSCUAU?Y?W?S?W?[AS?[?c@?W?Y?g@AW?s@AsAAg@AY?m@AU?c@Am@Ag@?a@Ae@?a@Ag@A_@?[?[Ac@?WAW?m@Am@Aa@?]?_@Ac@?]Aa@?q@A{@Ag@Am@?o@Ai@Ae@?[AI?K@I@IBa@L[J_@JWH[Hg@PkDv@o@LYFa@Hg@Ja@H_@F_@Hc@Js@L{@PI@GBIBGDWNGDEDABEFCFCFGRCJCHAH?JAX?NAT?FAFCFCFCDEDGBEBG@A@M@IBO@YFK@A?KBKBIDKBIDWNa@V[R]R]Ta@T]Ra@TOJ[V]X]V[Vk@d@qAfAWRMJMJMJ]Xe@^YT[V[VmAbA[Ts@f@m@d@k@b@m@b@]VYTWRg@^e@\\]Vm@b@a@Zc@\\eAt@a@ZIFSLw@b@QJULC@??????????????????????????????A@?@A@GLABIPINIPGJGLOZINIRKPS`@Q^Q\\Sb@Q\\[p@Q\\Ud@S^Sb@S^KTKR????????????????A@??A?KFIDE@[N[Na@Rk@Ve@Tc@Rg@Vc@Ri@Ve@Tm@Xq@Zq@Zw@^UJ]N]PYNYLWLUJWLSHSJ]P[N[N[N]NWLg@TULYL[NQHSJWLUJWLYL[NUJYLWL]P_@P]Na@RWL_@PIDm@X]Ng@Vy@^UJWL[Ni@V]P_@Pe@Ra@Rc@Rg@Va@Pe@Te@TkAh@e@Tc@Te@R_@PSHi@V]P]N[NQHk@XUJSJa@RYLe@TYLWLKDg@Va@RMDo@Zq@TMBYFaAPe@HKBe@H]FG@g@J]FKBa@H_@FWFSDYDc@H]Fg@J]Fi@Je@Ha@F]H]FI@IBQBOBUDWFKByAX]FUDUDYFSDa@Fc@Ja@F[HYFa@J_@JYFMDKBKBMBWF_@JOBQ@K?K@S?_@AO?e@AI?G?iABK?I@MDSFWJ]L]JUHKDg@P_@La@Ng@Pa@La@Nm@VYHSFKFs@T]L_@LYJk@Rw@Xo@Tm@RKDg@Pe@P_@L_@LKDMDSH_@J[L_@La@Nc@Le@Pi@Rm@Re@Pw@Xm@RoAd@g@N]Ls@Vm@Ro@Tk@Re@Pw@Xk@P]LKDMDOFiAZw@Xu@V{@Xe@PIDE@OFSHIBIDSPUTe@b@YXMLIHm@l@c@b@OL]\\KHEDGDIBEBUDa@LODc@JWHSFUDe@NYFQFSDMDODi@N_@L[H_@HSF_@JWFUFWHSFWHg@Lq@PIBIBA?M@K@KAKAa@Eo@Kw@Km@Ko@Iq@KGAMAKAOCcAOmAQcAOaAMeAOcAOy@Ms@KcAMgAQeAOyASs@KoAQ[ESC_@Gk@I_AMcAOcAOgAOy@Mm@ISCgAOk@Im@KQCIAYE_@Gi@Gi@Ie@I_@Ey@MYEMC[CIAGAK?K???E@K?K?E@O?[BS@M?i@Bg@@e@B]@A?g@BI?K@C?I?AAK?a@Ew@GcAGOA[Ci@EWCMAMASCo@Ew@G]C_@Co@G[CUAi@Gw@GOAWAe@Ei@Ec@E_@C[Cm@K_@Ew@Kw@KaAM}@Ki@I}@MaAMy@KcAOeAM}@MqAO_AOq@I{@KiAOy@MMAgAOYEKA}@M}@Mw@KMA{@MaAM_AOaAMuAQ_AMiAOo@I}AS[E[G{@KgAOq@Kg@Gk@Io@Im@Is@Iw@M{@K]Gk@Gw@KOCSC_@Gi@GeAO_@GUC]AaAA}@E_@As@Ek@CeAE]Cc@Ci@CK?YAa@Cm@Cy@Em@Cy@C_AE}@Es@C_@COAK?Q@k@Bc@BO?E?g@Bo@@u@B}@BY@Q@m@Bs@Bk@@s@D}@BaABm@BM@{ADoCJs@@sAD[@i@B_AB[@S@[?]@_@B_@@[@Y@]@]@I?I?YBw@Bo@BM?C@G?EBG@EBOJUNKDIFYP[Pe@XUNYNc@T[ROHYPSL_@RSJGDKFUNc@TKFIFYP_@Rk@\\[PYP[RSL[PWNSJGBA@EBEBYHa@N_@Lu@Va@Lc@N_@LEBKB]La@LYJi@PQFGBGB[Jo@TYHc@Nc@Ng@P]JGBKDIDIFaBfAc@Zg@\\[TYRUPKHWPEDID_@XUPOJUNWPSP_@VMJw@j@QNYPIHIDOLQL[TYRMHEDGDg@^_@Vc@Z]VID_@Xi@^]V_@Vi@^a@ZQNOJWPWPe@ZWROJWP[VUNQLYR[Ta@Zm@b@c@Xm@d@k@`@]T_@Ze@ZSNa@X]TWRa@Xc@Zg@^e@Za@Za@Z[Rg@^]T[T_@VUPWPSNQLSNKFWRWP_@VYRUPWP]TSNSNMJOJOPOPWZGHUTOPIHILEDOROPOPKJEFKJa@d@KLGFCBC@IFG@QFYJYF[J]Jg@Nc@NYHc@Ni@Nk@P]JQFg@Nm@Pu@Ti@Nk@Pu@Tg@Nk@Pa@Le@L]JKDWHUFaAZWHQDYHWHYJSFSFYHWHSHODSFODSF_@LUFSFWH[J_@JYJQDIBGB]JYHSHKBKBQF_@Jc@Le@NYJ[HYHSFOFSFKBIBSFMDQDKDIBOFYJk@Pg@L]L_@JWHaBf@a@La@LIBKBYJa@Lm@PQFUFg@Nc@NUFGBUFGBIB[HSF[Jk@PWHSFUFe@Nc@Lc@LOFC@ODG@OFa@Ja@Lc@Lc@LYHm@Pg@P_@JSF_@JODIBKDc@Li@N_@Lm@Pk@Pe@Ns@R[JKBKBYH_@LWH_@Lc@LWH_@JWHMDID[HMD[JSFUHWFWHSFOFQD_@J[J[J]J]JWHUFGBMB?@a@J[J]JYHk@Pc@Lg@N[H]LKBGBYLc@P[Lc@R_@N[L_@Pa@PIBWJOFEBG@MDGBE@UHA?[J_@Lg@Pa@NUH_@LQFGBMBOFQFg@PIBIBUHWJWHaAZa@Nm@Rq@Ta@LMFKDa@XUPUP[V_@X_@VUP[TC@WRQLGDKHSNQLSL[V_@Xa@XSN]VMHeGvDKHSLUP_@Xg@\\u@h@SNQJKFIFWPMHGDWNe@VYPc@V_@TIDGBKFOJOJWNi@Xa@VOHG@IBe@FUBWBI@k@Fo@H]Bg@Fe@F_@DI@I?OB]B[DUBYD]Dc@DYB[By@JYBu@Jc@DYBYDk@Fg@Fs@Hg@D]Da@D_@DA?]De@Di@Ho@F}@Jq@FWBa@Da@De@Fi@Dm@Hc@DOBM@K@a@D}@Jq@H]D_@D{@HOBI@OBK@m@Fa@Di@FSBK@G@WD]BI@I@G@YDK@YBM@K?OBQAOAI?SAK?_@A]ASAI?IA]AKAG?[AO?KAa@AOAG?IAYAWEIAQAOAMCMAOAUA]A]AYAK?O?SAQ?OAOAGCMCKGGCMKQSGKKIOSOOUYKKSUIGIKq@u@UWSSOQGGIK[_@SUGGCG]u@Se@Se@Q_@CICEMWKWO[MYEKEGEGGEGEGEGCIA]IYIUGGAGAGAKAG?G?O@c@HUDUBUDMBMBE?Q@U@Y@]@[B{@DO@I?G@U@S@[@oAFQ@W@O@Y@cCLWBa@Bo@FWDSBy@Hc@Da@D[HYH_@J]He@LYHKBKBa@FYFODODMFMFMH?@OJMJQLODQFSFSFMBIB]JKBI@K?K?K?ICKCSG??c@MUIMCe@ESCYEYIQKOGIEKEKAKCIAK?I@Q?Q?W@Q?[?U@_@?O@E?K@K@ODYJ_@N[JUHYJODKDMD[LWHWHUJYJ_@LQFe@Pw@X]JKDYJSHSFSHSFg@POFQHKDUPC@SPQNUPYTSN]VOJMLMHSNKFEBEBeA^ODQFSDO@U@_@BK@K@KBKBIDQJ[NaBv@_@R[L]PUJWLk@Xg@T]NWL]Pa@RCB[NYLSJc@Ro@Zo@Xi@VKFa@RQHqAn@UL]Nk@Vk@Xa@Ra@RYJ[JYHGBMBe@Ji@Nm@Lc@Ja@Jk@LSFc@JWFu@Pk@L]HWFy@Rc@J_@HODo@Nm@Nk@Ns@Nw@Pe@Le@Lm@LQDi@Lc@Jc@Lu@P[Fo@NMDe@Jm@LmAZUD_@JYFk@Lq@Pm@Nm@LUF[Hc@Jc@H_@Fq@Js@Jo@Ja@FSDe@F[Fa@Di@J]D}@N{@Ls@JG@YFy@Lg@F]Fw@Lc@Fi@HWDU@O?Q@U@i@B]Bs@BO@OBMBMDODMFC@QHOJIDGFGFEHEHKXQf@M\\MZGNMZM`@OZM\\O`@GRWr@KVYv@INSf@O`@On@Or@Kh@Id@Ml@I\\Mj@S~@Kl@Mj@IZEXMh@UlAOp@??EROr@Kj@Or@EPGPKVQh@IVQh@M^KXQh@Od@Ob@KX?BKXM`@M\\Ob@Od@M\\M\\GTM\\Qf@ELM^ELELEFCHEFEDQTWXY\\[`@UVQRQRUZKJQTMLKLMNCBEDCDMPGHIFIFIDKDKBK@SD??QBG@MBg@He@Ha@FOBc@He@HYDMBUDUD]Fc@Hc@Fi@HYFK@UDi@He@Ho@HYFSB_@H??e@Hg@HQBi@HMB[Fk@Hi@Ja@FOBe@HKBIBKFa@Xc@Zk@`@[Tg@\\c@Zg@^[Ta@Xi@^SLc@\\_@VUPSLo@b@s@f@i@^QLi@^c@ZWPa@Z[Pe@\\WRSNMHGDIFm@b@m@`@k@`@k@b@w@h@GDGFGFa@h@q@z@aBvBqA`BmChD_BtBi@t@k@t@IHIJKHIFe@ZiBhAaBfA]R]VUNIJINGN?FIl@E^E^Ir@Gd@Il@K`AOfAGh@Mh@Wn@Sd@O^KTMXIRKRSb@MXO^[t@_@x@MXQ`@Wh@On@}Gv^????A@G\\EPs@pDm@|Cg@hCc@zBk@vC_@fBI`@Mp@GXGZET?DABEHEJEJGHSTGHEJq@tAELELGV[lAk@xB_@vAo@fCi@tBiAjEc@hBu@xCu@nCs@tC{@dDcAzDgAlEo@dCQt@Qp@Ol@Mj@E\\c@zCOfAa@rCKr@M|@OfAKv@GXITcApC]bA}@bCy@|Bs@rBq@nBYx@Wp@Qh@Sh@s@~De@hCSfAKl@ENMr@GXKn@Mn@G^GdAD~C?nD?rBBh@@vA?L?FAHAFGXA@?@?@ABABA@CBC@A@E?MBG?E?_@?M@K@KBc@H{@TUDSDWDI@G@G?G?EAYG??A?????????GDIHON_@`@";
      List<PointLatLngModel> pointsList = decodePolyline(value).cast<PointLatLngModel>();
      for(var data in pointsList){
        print(data.latitude);
        print(data.longitude);
      }
    }catch(_){}
  }

  static Future<dynamic> createPdf() async {
    var response  = await [
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();

    final pdf = pw.Document();
    String value =  await getFileData("assets/test.txt");
    List<dynamic> singleList =  value.split("\n");
    int  lineIndex = 60;
    List<dynamic> tempList = [];
    int pageIndex = 0;

/*    for(int i = 0; i < singleList.length; i++){
      tempList.add(singleList[i].toString());
      if(i == 60){
        print(tempList.toString());
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Center(
                child: pw.Text(tempList.toString().substring(0, 1000))),
          ),
        );
        await Future.delayed(const Duration(seconds:1));
        tempList = [];
        lineIndex += 60;
        pageIndex += 1;
      }
      else  if(i == 120){
        print(tempList.toString());
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Center(
                child: pw.Text(tempList.toString().substring(0, 1000))),
          ),
        );
        await Future.delayed(const Duration(seconds:1));
        tempList = [];
        lineIndex += 60;
        pageIndex += 1;
      }
    }*/

    print("Total Lenght ==== ${singleList.length}");

    pdf.addPage(
      MultiPage(
        maxPages: 80000,
        build: (Context context) => <Widget>[
          Wrap(
            children: List<Widget>.generate(10000, (int index) {
              final issue = singleList[index];
              return Text("Description :  $issue",
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 15));
            }),
          ),
        ],
      ),
    );

/*    ByteData data = await rootBundle.load("assets/test.txt");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);*/

/*    pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Text(value.substring(29000, 50000)),
          ),
        ));*/

    bool isStoragePermission = await LocationHelper.checkStoragePermission();
    if(isStoragePermission == true){
       final File file = await DirectoryUtil.getDirPath("example_${DateTime.now().millisecondsSinceEpoch}.pdf");
       await file.writeAsBytes(await pdf.save(), flush: true);
      // await file.writeAsBytes(bytes, flush: true);
      print("Completed--------------------");
      await OpenFile.open(file.path);
    }
  }

  static Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }


  static List<PointLatLngModel> decodePolyline(String polyline,
      {int accuracyExponent = 5}) {
    final accuracyMultiplier = math.pow(10, accuracyExponent);
    List<PointLatLngModel> coordinates = [];
    int index = 0;
    int lat = 0;
    int lng = 0;
    while (index < polyline.length) {
      int char;
      int shift = 0;
      int result = 0;

      int getCoordinate() {
        do {
          char = polyline.codeUnitAt(index++) - 63;
          result |= (char & 0x1f) << shift;
          shift += 5;
        } while (char >= 0x20);
        final value = result >> 1;
        final coordinateChange =
        (result & 1) != 0 ? (~BigInt.from(value)).toInt() : value;

        shift = result = 0;
        return coordinateChange;
      }
      lat += getCoordinate();
      lng += getCoordinate();
      coordinates.add(
          PointLatLngModel(lat / accuracyMultiplier, lng / accuracyMultiplier));
    }
    return coordinates;
  }

}

class PointLatLngModel {
  final double? latitude;
  final double? longitude;

  PointLatLngModel(this.latitude, this.longitude);

  @override
  String toString() {
    return "enlem: $latitude / boylam: $longitude";
  }
}


class PolylineCodec {
  PolylineCodec._();

  static num _py2Round(num value) {
    return (value.abs() + 0.5).floor() * (value >= 0 ? 1 : -1);
  }

  static String _encode(num current, num previous, num factor) {
    current = _py2Round(current * factor);
    previous = _py2Round(previous * factor);
    Int32 coordinate = Int32(current as int) - Int32(previous as int) as Int32;
    coordinate <<= 1;
    if (current - previous < 0) {
      coordinate = ~coordinate;
    }
    var output = "";
    while (coordinate >= Int32(0x20)) {
      try {
        Int32 v = (Int32(0x20) | (coordinate & Int32(0x1f))) + 63 as Int32;
        output += String.fromCharCodes([v.toInt()]);
      } catch (err) {
        print(err);
      }
      coordinate >>= 5;
    }
    output += ascii.decode([coordinate.toInt() + 63]);
    return output;
  }

  static List<List<num>> decode(String str, {int precision = 5}) {
    final List<List<num>> coordinates = [];
    var index = 0,
        lat = 0,
        lng = 0,
        shift = 0,
        result = 0,
        factor = math.pow(10, precision);
    int? latitudeChange, longitudeChange, byte;

    while (index < str.length) {
      byte = null;
      shift = 0;
      result = 0;

      do {
        byte = str.codeUnitAt(index++) - 63;
        result |= ((Int32(byte) & Int32(0x1f)) << shift).toInt();
        shift += 5;
      } while (byte >= 0x20);

      latitudeChange =
          ((result & 1) != 0 ? ~(Int32(result) >> 1) : (Int32(result) >> 1))
              .toInt();

      shift = result = 0;

      do {
        byte = str.codeUnitAt(index++) - 63;
        result |= ((Int32(byte) & Int32(0x1f)) << shift).toInt();
        shift += 5;
      } while (byte >= 0x20);
      longitudeChange =
          ((result & 1) != 0 ? ~(Int32(result) >> 1) : (Int32(result) >> 1))
              .toInt();
      lat += latitudeChange;
      lng += longitudeChange;
      coordinates.add([lat / factor, lng / factor]);
    }
    return coordinates;
  }

  static String encode(List<List<num>> coordinates, {int precision = 5}) {
    if (coordinates.isEmpty) {
      return "";
    }
    final factor = math.pow(10, precision);
    var output = _encode(coordinates[0][0], 0, factor) +
        _encode(coordinates[0][1], 0, factor);
    for (var i = 1; i < coordinates.length; i++) {
      var a = coordinates[i], b = coordinates[i - 1];
      output += _encode(a[0], b[0], factor);
      output += _encode(a[1], b[1], factor);
    }
    return output;
  }

}