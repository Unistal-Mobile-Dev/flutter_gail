import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'search_text_field_event.dart';
part 'search_text_field_state.dart';

class SearchTextFieldBloc
    extends Bloc<SearchTextFieldEvent, SearchTextFieldState> {
  List<dynamic> _list = [];

  List<dynamic> get list => _list;

  List<dynamic> _searchList = [];

  List<dynamic> get searchList => _searchList;

  TextEditingController searchController = TextEditingController();

  SearchTextFieldBloc() : super(SearchTextFieldInitial()) {
    on<SearchTextFieldPageLoadEvent>(_pageLoad);
    on<SearchTextFieldSearchKeyWordEvent>(_searchKeyWord);
    on<SearchTextFieldSetListValueEvent>(_setListValue);
  }

  _pageLoad(SearchTextFieldPageLoadEvent event, emit) {
    _list = event.list;
    _searchList = [];
    searchController.text = event.controllerValue;
    _eventCompleted(emit);
  }

  _searchKeyWord(SearchTextFieldSearchKeyWordEvent event, emit) async {
    String keyWord = event.keyWord;
    _searchList = [];
    if (keyWord.isNotEmpty) {
      _searchList = _list
          .where((element) =>
              element.toString().toLowerCase().contains(keyWord.toLowerCase()))
          .toList();
      searchList.sort((a, b) => a.toString().compareTo(b.toString()));
    }
    _eventCompleted(emit);
  }

  _setListValue(SearchTextFieldSetListValueEvent event, emit) {
    searchController.text = event.listValue;
    _eventCompleted(emit);
  }

  _eventCompleted(Emitter<SearchTextFieldState> emit) {
    emit(FetchSearchTextFieldDataState(
        searchList: searchList, searchController: searchController));
  }
}
