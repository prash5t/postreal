import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:postreal/data/auth_methods.dart';
import 'package:postreal/data/models/user.dart' as model;
import 'package:postreal/data/models/user_repo.dart';
import 'package:postreal/data/repository/auth_repository.dart';
import 'package:postreal/utils/shared_prefs_helper.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoadingState()) {
    on<AuthCheckerEvent>(_authChecker);
    on<LoginClickedEvent>(_loginClick);
    on<LogoutClickedEvent>(_logoutClick);
    on<RegisterClickedEvent>(_registerClick);
    on<OTPVerifiedEvent>(_otpVerifiedEvent);
  }
  final AuthMethods _authMethods = AuthMethods();
  model.User? _currentUser;

  model.User get getCurrentUser => _currentUser!;

  FutureOr<void> _otpVerifiedEvent(
      OTPVerifiedEvent otpVerifiedEvent, Emitter<AuthState> emit) {
    emit.call(LoggedInState());
  }

  FutureOr<void> _logoutClick(
    LogoutClickedEvent logoutClickedEvent,
    Emitter<AuthState> emit,
  ) async {
    await _authMethods.signOut();
    emit.call(LoggedOutState());
  }

  FutureOr<void> _authChecker(
    AuthCheckerEvent authCheckerEvent,
    Emitter<AuthState> emit,
  ) async {
    emit.call(AppOpeningState());
    final String? accessToken = await SharedPrefsHelper.getAccessToken();
    final String? refreshToken = await SharedPrefsHelper.getRefreshToken();
    if (accessToken == null || refreshToken == null) {
      emit.call(LoggedOutState());
    } else {
      emit.call(LoggedInState());
    }
  }

  FutureOr<void> _loginClick(
    LoginClickedEvent loginClickedEvent,
    Emitter<AuthState> emit,
  ) async {
    emit.call(LoadingState());

    Map<String, dynamic> loginAuthTokenResp =
        await AuthDataRepository.getAuthToken(
            loginClickedEvent.email, loginClickedEvent.password);

    if (loginAuthTokenResp['success']) {
      emit.call(LoggedInState());
    }
    // issue receiving tokens while logging in
    else {
      emit.call(MessageState(message: loginAuthTokenResp['message']));
    }

    // final String loginMsg = await _authMethods.loginUser(
    //   loginClickedEvent.email,
    //   loginClickedEvent.password,
    // );

    // if (loginMsg == "success") {
    //   await _bringCurrentUserToGlobalSpace();
    //   emit.call(LoggedInState());
    // } else {
    //   emit.call(LoggedOutState());
    //   emit.call(MessageState(message: loginMsg));
    // }
  }

  FutureOr<void> _registerClick(RegisterClickedEvent registerClickedEvent,
      Emitter<AuthState> emit) async {
    emit.call(LoadingState());

    UserRepo pendingUser = await AuthDataRepository.registerUser(
        personTryingToRegister: registerClickedEvent.personTryingToRegister);

    if (pendingUser.success) {
      emit.call(VerifyOTPState(
          registerClickedEvent.personTryingToRegister.email,
          registerClickedEvent.personTryingToRegister.password!));
    } else {
      emit.call(MessageState(message: pendingUser.message));
    }
  }

  // need current user information in home screen,
  // so making it ready from the auth stage by keeping it in global space
  Future<void> _bringCurrentUserToGlobalSpace() async {
    final currentUser = _authMethods.auth.currentUser;
    DocumentSnapshot snapshot = await _authMethods.firestore
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    _currentUser = model.User.fromSnap(snapshot);
  }
}
