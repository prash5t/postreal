import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:postreal/data/data_provider/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:postreal/data/models/user.dart';
import 'package:postreal/data/models/user_repo.dart';
import 'package:postreal/utils/shared_prefs_helper.dart';

class AuthDataRepository {
  static Future<Map<String, dynamic>> getAuthToken(
      final String emailOrUserame, final String password) async {
    try {
      final http.Response rawResp =
          await AuthDataProvider.getAuthTokenPostReq(emailOrUserame, password);
      final Map<String, dynamic> decodedResp = json.decode(rawResp.body);
      debugPrint("Get Auth Resp: $decodedResp");
      if (decodedResp["success"]) {
        await SharedPrefsHelper.setAccessToken(decodedResp['data']['access']);
        await SharedPrefsHelper.setRefreshToken(decodedResp['data']['refresh']);
      }
      return decodedResp;
    } catch (err) {
      debugPrint("Get Auth Catch: $err");
      return {"success": false, "message": "Network Error"};
    }
  }

  static Future<UserRepo> verifyOTP(
      final String emailOrUserame, final String otp) async {
    try {
      final http.Response rawResp =
          await AuthDataProvider.verifyOTPPostReq(emailOrUserame, otp);
      final Map<String, dynamic> decodedResp = json.decode(rawResp.body);
      debugPrint("Verify OTP Resp: $decodedResp");

      return UserRepo(
          success: decodedResp['success'],
          message: decodedResp['message'],
          user: User.fromJson(decodedResp['data']));
    } catch (err) {
      debugPrint("Verify OTP Catch: $err");
      return UserRepo(success: false, message: "Network error");
    }
  }

  static Future<UserRepo> registerUser(
      {required final User personTryingToRegister}) async {
    try {
      final http.Response rawRespOfRegister =
          await AuthDataProvider.registerPostReq(
              personTryingToRegister: personTryingToRegister);
      final Map<String, dynamic> decodedResp =
          json.decode(rawRespOfRegister.body);
      debugPrint("Register resp: $decodedResp");

      return UserRepo(
          success: decodedResp['success'],
          message: decodedResp['message'],
          user: User.fromJson(decodedResp['data']));
    } catch (err) {
      debugPrint("Register User Catch: $err");
      return UserRepo(
          success: false, message: 'Error making network request', user: null);
    }
  }
}
