import 'package:flutter_gail/utils/commonClass/app_config.dart';

import 'enums.dart';

class AppIcon {
  static get gailLogo => "assets/logo/upims_logo.png";

  static get oilLogo => "assets/oil.png";
  static get hpOILLogo => "assets/logo/hp_oil_logo.png";
  static get hpclLogo => "assets/logo/hpcl_logo.png";

  static get unistalLogo => "assets/logo/unistal_logo.png";
  static get transperentBackground => "assets/transperent_background.png";

  static get gpsMovedIcon => "assets/ic_gps_moved.png";

  static get startLocationIcon => "assets/ic_pin_loc.png";

  static get endLocationIcon => "assets/ic_flag_end.png";

  static get wmIcon => "assets/ic_wm.png";

  static get kmIcon => "assets/ic_km.png";

  static get dmIcon => "assets/ic_dm.png";

  static get tlpIcon => "assets/ic_tlp.png";

  static get bpIcon => "assets/ic_bp.png";

  static get railCrossingIcon => "assets/ic_railcrossing.png";

  static get riverCrossingIcon => "assets/ic_rivercrossing.png";

  static get roadCrossingIcon => "assets/ic_roadcrossing.png";

  static get incidentIcon => "assets/ic_incident.png";

  static get warningIcon => "assets/ic_warning.png";

  static get arrowIcon => "assets/arrow_icon.png";

  static get personLocation => "assets/ic_location_person.png";

  static get pointerIcon => "assets/pointer.png";

  static get flagIcon => "assets/flag.png";

  static get gpsIcon => "assets/gps.png";

  static get mapIcon => "assets/map.png";

  static get arcGISImageryIcon => "assets/ic_arcGISImagery.png";

  static get arcGISStreetsIcon => "assets/ic_arcGISStreets.png";


  static String logo() {
    switch ( AppConfig.instanceInit()!.client) {
      case Client.hpoil:
        return AppIcon.hpOILLogo;
      case Client.hpcl:
        return AppIcon.hpclLogo;
        default:
    return AppIcon.unistalLogo;
    }
  }
  static String loginTitle() {
    switch ( AppConfig.instanceInit()!.client) {
      case Client.hpoil:
        return "HPOIL Login";
      case Client.hpcl:
        return "HPCL Login";
      default:
        return "Unistal Login";
    }
  }

}