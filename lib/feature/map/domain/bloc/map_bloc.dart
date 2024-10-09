import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gail/feature/map/domain/model/map_model.dart';
import 'package:flutter_gail/feature/map/helper/map_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  bool isLoader =  false;
  List<MapModel> mapList  = [];
  MapModel mapData =  MapModel();

  MapBloc() : super(MapInitial()) {
    on<MapPageLoadEvent>(_pageLoadEvent);
    on<MapRouteDirection>(_routeDirection);
  }

  _pageLoadEvent(MapPageLoadEvent event, emit) async {
    isLoader = false;
    mapList = [];
    _eventComplete(emit);
  }

  _routeDirection(MapRouteDirection event, emit) async {
    isLoader =  true;
    _eventComplete(emit);
    var res =  await MapHelper.fetchRouteDirection(
        startPoint: const LatLng(0.0, 0.0),
        endPoint: const LatLng(0.0, 0.0));
    if(res != null) {

    }
    isLoader =  false;
    _eventComplete(emit);
  }

  _eventComplete(Emitter<MapState> emit) {
    emit(FetchMapPageDataState(
        isLoader: isLoader,
        mapList: mapList,
    ));
  }
}
