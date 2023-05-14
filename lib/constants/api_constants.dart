class APIConstants {
  static const String baseURL = "http://43.204.38.198:8000/apis/v1/";

  static const String registerEndPoint =
      "${APIConstants.baseURL}users/register/";

  static const String verifyOTPEndPoint =
      "${APIConstants.baseURL}users/verify-otp/";

  static const String getAuthToken = "${APIConstants.baseURL}get-token/";

  static const Map<String, String> headerWithoutToken = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static const Map<String, String> headerWithoutTokenWithPic = {
    'Content-type': 'multipart/form-data'
  };
}
