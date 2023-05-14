part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppOpeningState extends AuthState {}

class LoadingState extends AuthState {}

class LoggedOutState extends AuthState {}

class LoggedInState extends AuthState {}

class MessageState extends AuthState {
  final String message;
  MessageState({required this.message});
  @override
  List<Object?> get props => [message];
}

class VerifyOTPState extends AuthState {
  final String emailOrUserame;
  final String password;

  VerifyOTPState(this.emailOrUserame, this.password);
  @override
  List<Object?> get props => [emailOrUserame, password];
}
