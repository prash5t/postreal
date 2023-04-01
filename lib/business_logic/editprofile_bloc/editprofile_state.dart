part of 'editprofile_bloc.dart';

abstract class EditProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileProcessing extends EditProfileState {}

class ProfileUpdatedState extends EditProfileState {}

class UpdateErrorState extends EditProfileState {
  final String? message;
  UpdateErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}
