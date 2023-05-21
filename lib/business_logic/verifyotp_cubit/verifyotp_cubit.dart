import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postreal/business_logic/auth_bloc/auth_bloc.dart';
import 'package:postreal/data/models/user_repo.dart';
import 'package:postreal/data/repository/auth_repository.dart';
import 'package:postreal/main.dart';

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
        BlocProvider.of<AuthBloc>(navKey.currentContext!)
            .add(OTPVerifiedEvent());
      }
      // issue receiving access/refresh tokens
      else {
        emit(MessageState(authTokenResp["message"]));
      }
    }
    // issue verifying otp
    else {
      emit(MessageState(userVerifyingOTP.message));
    }
  }
}
