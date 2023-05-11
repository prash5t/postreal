import 'dart:convert';
import 'package:postreal/data/auth_methods.dart';
import 'package:postreal/my_keys.dart';
import 'package:http/http.dart' as http;

createPaymentIntent() async {
  final String loggedInUserEmail =
      AuthMethods().auth.currentUser!.email ?? "null";
  Map<String, String> stripeHeader = {
    'Authorization': 'Bearer $stripeSecretKey',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  try {
    Map<String, dynamic> body = {
      "amount": "199",
      "currency": "USD",
      "receipt_email": loggedInUserEmail,
    };
    http.Response response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        headers: stripeHeader,
        body: body);
    return json.decode(response.body);
  } catch (e) {
    throw Exception(e.toString());
  }
}
