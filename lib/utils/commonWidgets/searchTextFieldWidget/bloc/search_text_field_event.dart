part of 'search_text_field_bloc.dart';

abstract class SearchTextFieldEvent extends Equatable {
  const SearchTextFieldEvent();
}

class SearchTextFieldPageLoadEvent extends SearchTextFieldEvent {
  final List<dynamic> list;
  final String controllerValue;

  const SearchTextFieldPageLoadEvent(
      {required this.list, required this.controllerValue});

  @override
  List<Object?> get props => [list, controllerValue];
}

class SearchTextFieldSearchKeyWordEvent extends SearchTextFieldEvent {
  final String keyWord;

  const SearchTextFieldSearchKeyWordEvent({required this.keyWord});

  @override
  List<Object?> get props => [keyWord];
}

class SearchTextFieldSelectListItemEvent extends SearchTextFieldEvent {
  final String listValue;

  const SearchTextFieldSelectListItemEvent({required this.listValue});

  @override
  List<Object?> get props => [listValue];
}

class SearchTextFieldSetListValueEvent extends SearchTextFieldEvent {
  final String listValue;

  const SearchTextFieldSetListValueEvent({required this.listValue});

  @override
  List<Object?> get props => [listValue];
}
