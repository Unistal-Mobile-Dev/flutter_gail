part of 'map_bloc.dart';

sealed class MapState extends Equatable {
  const MapState();
}

final class MapInitial extends MapState {
  @override
  List<Object> get props => [];
}

final class MapPageLoadState extends MapInitial {}

final class FetchMapPageDataState extends MapInitial {
  final bool isLoader;
  final List<MapModel> mapList;

  FetchMapPageDataState({
   required this.isLoader,
   required this.mapList,
  });

  @override
  List<Object> get props => [
    isLoader,
    mapList
  ];

}


