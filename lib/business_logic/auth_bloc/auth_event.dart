part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent extends AuthEvent {}

class AuthCheckerEvent extends AuthEvent {}

class LogoutClickedEvent extends AuthEvent {}

class LoginClickedEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginClickedEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterClickedEvent extends AuthEvent {
  final String email;
  final String username;
  final String bio;
  final String password;
  final File profilePic;

  const RegisterClickedEvent(
      this.email, this.username, this.bio, this.password, this.profilePic);

  @override
  List<Object> get props => [email, username, bio, password, profilePic];
}
