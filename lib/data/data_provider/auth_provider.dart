import 'package:http/http.dart' as http;
import 'package:postreal/constants/api_constants.dart';
import 'package:postreal/data/models/user.dart';

class AuthDataProvider {
  // to invoke user register request
  static Future<http.Response> registerPostReq(
      {required final User personTryingToRegister}) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(APIConstants.registerEndPoint));
    request.headers.addAll(APIConstants.headerWithoutTokenWithPic);
    request.fields['email'] = personTryingToRegister.email;
    request.fields['password'] = personTryingToRegister.password!;
    request.fields['username'] = personTryingToRegister.username;
    request.fields['bio'] = personTryingToRegister.bio;
    request.files.add(await http.MultipartFile.fromPath(
        'profilePicUrl', personTryingToRegister.profilePicFile!.path));

    return await http.Response.fromStream(await request.send());
  }

  static Future<http.Response> verifyOTPPostReq(
      final String emailOrUserame, final String otp) async {
    Map<String, dynamic> verifyOTPBody = {
      "username": emailOrUserame,
      "otp": otp
    };
    return http.post(Uri.parse(APIConstants.verifyOTPEndPoint),
        headers: APIConstants.headerWithoutToken, body: verifyOTPBody);
  }

  static Future<http.Response> getAuthTokenPostReq(
      final String usernameOrEmail, final String password) async {
    Map<String, dynamic> getAuthTokenBody = {
      "username": usernameOrEmail,
      "password": password
    };
    return http.post(Uri.parse(APIConstants.getAuthToken),
        headers: APIConstants.headerWithoutToken, body: getAuthTokenBody);
  }

  static Future<Map<String, dynamic>> signInPostReq() async {
    return {};
  }
}
