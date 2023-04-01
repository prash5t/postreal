part of 'addphoto_bloc.dart';

abstract class AddPhotoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ImageNotReceivedState extends AddPhotoState {}

class ChoosingPhotoState extends AddPhotoState {}

class PhotoChoosedState extends AddPhotoState {
  final File choosedPhoto;
  PhotoChoosedState({required this.choosedPhoto});
  @override
  List<Object?> get props => [choosedPhoto];
}

class PhotoPostingState extends AddPhotoState {
  final File choosedPhoto;
  PhotoPostingState({required this.choosedPhoto});
  @override
  List<Object?> get props => [choosedPhoto];
}

class PhotoPostedState extends AddPhotoState {}

class PostingErrorState extends AddPhotoState {
  final String? message;
  PostingErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}
