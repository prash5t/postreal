part of 'verifyotp_cubit.dart';

abstract class VerifyOTPState extends Equatable {
  const VerifyOTPState();

  @override
  List<Object> get props => [];
}

class VerifyOTPInitial extends VerifyOTPState {}

class LoadingState extends VerifyOTPState {}

class MessageState extends VerifyOTPState {
  final String message;

  const MessageState(this.message);
}

// class SuccessState extends VerifyOTPState {}
