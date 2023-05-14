part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckerEvent extends AuthEvent {}

class LogoutClickedEvent extends AuthEvent {}

class OTPVerifiedEvent extends AuthEvent {}

class LoginClickedEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginClickedEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterClickedEvent extends AuthEvent {
  final model.User personTryingToRegister;

  const RegisterClickedEvent({required this.personTryingToRegister});

  @override
  List<Object> get props => [personTryingToRegister];
}

class VerifyOTPClickedEvent extends AuthEvent {
  final String emailOrUserame;
  final String otp;

  const VerifyOTPClickedEvent(this.emailOrUserame, this.otp);
  @override
  List<Object> get props => [emailOrUserame, otp];
}
