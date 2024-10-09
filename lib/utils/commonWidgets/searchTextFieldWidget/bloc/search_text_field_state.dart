part of 'search_text_field_bloc.dart';

abstract class SearchTextFieldState extends Equatable {
  const SearchTextFieldState();
}

class SearchTextFieldInitial extends SearchTextFieldState {
  @override
  List<Object> get props => [];
}

class SearchTextFieldPageLoadState extends SearchTextFieldInitial {
  @override
  List<Object> get props => [];
}

class FetchSearchTextFieldDataState extends SearchTextFieldInitial {
  final List<dynamic> searchList;
  final TextEditingController searchController;

  FetchSearchTextFieldDataState(
      {required this.searchList, required this.searchController});

  @override
  List<Object> get props => [searchList, searchController];
}
