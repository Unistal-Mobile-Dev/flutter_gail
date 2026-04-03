import 'package:flutter_gail/ExportFile/app_export_file.dart';
import 'hpOil_dashboard_event.dart';
import 'hpOil_dashboard_state.dart';

class HpOilDashboardBloc extends Bloc<HpOilDashboardEvent, HpOilDashboardState> {

  bool isLoader = false;
  LoginDataModel userData = LoginDataModel();

  HpOilDashboardBloc() : super(HpOilDashboardInitial()) {
    on<HpOilDashboardPageLoadEvent>(_pageLoad);
  }

  _pageLoad(HpOilDashboardPageLoadEvent event, emit) async {
    isLoader = false;
    userData =  AppConfig.instanceInit()!.userData;
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<HpOilDashboardState> emit) {
    emit(FetchHpOilDashboardDataState(
      isLoader: isLoader,
      userData: userData,
    ));
  }
}
