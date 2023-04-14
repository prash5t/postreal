part of 'addphoto_bloc.dart';

abstract class AddPhotoEvent extends Equatable {
  const AddPhotoEvent();

  @override
  List<Object> get props => [];
}

class AddPhotoInitialEvent extends AddPhotoEvent {}

class PostClickedEvent extends AddPhotoEvent {
  final File img;
  final User user;
  final String caption;

  const PostClickedEvent({
    required this.img,
    required this.user,
    required this.caption,
  });
  @override
  List<Object> get props => [img, user, caption];
}
