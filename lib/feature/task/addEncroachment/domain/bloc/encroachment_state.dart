part of 'encroachment_bloc.dart';

sealed class EncroachmentState extends Equatable {
  const EncroachmentState();
}

final class EncroachmentInitial extends EncroachmentState {
  @override
  List<Object> get props => [];
}


final class EncroachmentPageLoadState extends EncroachmentInitial {
  @override
  List<Object> get props => [];
}


final class FetchEncroachmentDataState extends EncroachmentState {

  final String location;
  final List<EncroachmentModel> encroachmentList;
  final EncroachmentModel encroachmentData;
  final File file;
  final bool isLoader;
  final bool isFileLoader;
  final TextEditingController chainageController;

  const FetchEncroachmentDataState({
    required this.location,
    required this.isLoader,
    required this.chainageController,
    required this.encroachmentData,
    required this.encroachmentList,
    required this.file,
    required this.isFileLoader,
});

  @override
  List<Object> get props => [
    location,
    isLoader,
    chainageController,
    encroachmentData,
    encroachmentList,
    file,
    isFileLoader,
  ];
}
