import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:postreal/my_keys.dart';

void displayPaymentSheet({required String paymentIntentId}) async {
  try {
    await Stripe.instance.presentPaymentSheet();
  } catch (e) {
    debugPrint("Display payment sheet failed $e");
    // fyi: when failed, we need to cancel this particular payment intent
    cancelStripePaymentIntent(paymentIntentId);
  }
}

void cancelStripePaymentIntent(String paymentIntentId) async {
  final String cancelUrl =
      'https://api.stripe.com/v1/payment_intents/$paymentIntentId/cancel';
  try {
    http.post(Uri.parse(cancelUrl), headers: {
      'Authorization': 'Bearer $stripeSecretKey',
      'Content-Type': 'application/x-www-form-urlencoded'
    }).then((response) {
      final responseBody = json.decode(response.body);
      debugPrint(responseBody.toString());
    });
  } catch (e) {
    debugPrint("Error canceling payment intent: $e");
  }
}
