part of 'editprofile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class EditClickedEvent extends EditProfileEvent {
  final String newUsername;
  final String newBio;
  final String oldUsername;
  final String oldBio;
  final String userId;

  const EditClickedEvent(
      {required this.newUsername,
      required this.newBio,
      required this.oldUsername,
      required this.oldBio,
      required this.userId});

  @override
  List<Object> get props => [newUsername, newBio, oldBio, oldUsername, userId];
}
