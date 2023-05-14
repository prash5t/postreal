import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postreal/business_logic/auth_bloc/auth_bloc.dart';
import 'package:postreal/data/models/user_repo.dart';
import 'package:postreal/data/repository/auth_repository.dart';
import 'package:postreal/main.dart';
import 'package:postreal/utils/shared_prefs_helper.dart';

part 'verifyotp_state.dart';

class VerifyOTPCubit extends Cubit<VerifyOTPState> {
  VerifyOTPCubit() : super(VerifyOTPInitial());

  void verifyOTP(final String emailOrUserame, final String password,
      final String otp) async {
    emit(LoadingState());
    UserRepo userVerifyingOTP =
        await AuthDataRepository.verifyOTP(emailOrUserame, otp);
    if (userVerifyingOTP.success) {
      emit(MessageState(userVerifyingOTP.message));
      // get token
      emit(LoadingState());
      Map<String, dynamic> authTokenResp =
          await AuthDataRepository.getAuthToken(emailOrUserame, password);
      // fyi: when tokens are received, save them to securestorage and navigate to home
      if (authTokenResp["success"]) {
        await SharedPrefsHelper.setAccessToken(authTokenResp['data']['access']);
        await SharedPrefsHelper.setRefreshToken(
            authTokenResp['data']['refresh']);
        BlocProvider.of<AuthBloc>(navKey.currentContext!)
            .add(OTPVerifiedEvent());
      } else {
        emit(MessageState(authTokenResp["message"]));
      }
    } else {
      emit(MessageState(userVerifyingOTP.message));
    }
  }
}
