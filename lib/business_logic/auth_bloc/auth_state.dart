part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppOpeningState extends AuthState {}

class LoadingState extends AuthState {}

class LoggedOutState extends AuthState {}

class LoggedInState extends AuthState {}

class ErrorState extends AuthState {
  final String? message;
  ErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}
