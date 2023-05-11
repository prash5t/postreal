import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'create_payment_intent.dart';
import 'display_payment_sheet.dart';

void makePayment() async {
  try {
    Map<String, dynamic> paymentIntent = await createPaymentIntent();
    debugPrint("create paymeny intent: $paymentIntent");
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent['client_secret'],
            merchantDisplayName: 'PostReal'));

    displayPaymentSheet(paymentIntentId: paymentIntent['id']);
  } catch (e) {
    debugPrint("Make payment failed $e");
  }
}
