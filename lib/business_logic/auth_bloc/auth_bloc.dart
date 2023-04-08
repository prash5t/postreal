import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:postreal/data/auth_methods.dart';
import 'package:postreal/data/models/user.dart' as model;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoadingState()) {
    on<AuthCheckerEvent>(_authChecker);
    on<LoginClickedEvent>(_loginClick);
    on<LogoutClickedEvent>(_logoutClick);
    on<InitialEvent>(_initialEvent);
    on<RegisterClickedEvent>(_registerClick);
  }
  final AuthMethods _authMethods = AuthMethods();
  model.User? _currentUser;

  model.User get getCurrentUser => _currentUser!;

  // InitialEvent is usable to act as remover of error state once its delivered
  // in the stream when we need to navigate to another screen
  // example to register screen from login screen or vice versa
  // if the last state was error state and when we navigate between the screens
  // Error state will be provided bacause that last state was error state
  // So triggering InitialEvent when we navigate from login to register or viceversa
  // will bring LoggedOutState as the latest state.
  FutureOr<void> _initialEvent(
      InitialEvent initialEvent, Emitter<AuthState> emit) {
    emit.call(LoggedOutState());
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
    final currentUser = _authMethods.auth.currentUser;
    if (currentUser != null) {
      await _bringCurrentUserToGlobalSpace();
      emit.call(LoggedInState());
    } else {
      emit.call(LoggedOutState());
    }
  }

  FutureOr<void> _loginClick(
    LoginClickedEvent loginClickedEvent,
    Emitter<AuthState> emit,
  ) async {
    emit.call(LoadingState());

    final String loginMsg = await _authMethods.loginUser(
      loginClickedEvent.email,
      loginClickedEvent.password,
    );

    if (loginMsg == "success") {
      await _bringCurrentUserToGlobalSpace();
      emit.call(LoggedInState());
    } else {
      emit.call(LoggedOutState());
      emit.call(ErrorState(message: loginMsg));
    }
  }

  FutureOr<void> _registerClick(RegisterClickedEvent registerClickedEvent,
      Emitter<AuthState> emit) async {
    emit.call(LoadingState());

    final String registerMsg = await _authMethods.signupUser(
        email: registerClickedEvent.email,
        password: registerClickedEvent.password,
        username: registerClickedEvent.username,
        bio: registerClickedEvent.bio,
        selfieFile: registerClickedEvent.profilePic);

    if (registerMsg == "success") {
      await _bringCurrentUserToGlobalSpace();
      emit.call(LoggedInState());
    } else {
      // emit.call(LoggedOutState());
      emit.call(ErrorState(message: registerMsg));
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
