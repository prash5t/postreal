import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:postreal/constants/routes.dart';
import 'package:postreal/data/firestore_methods.dart';
import 'package:postreal/main.dart';

// function to call when payment button is clicked
payWithKhalti() {
  KhaltiScope.of(navKey.currentContext!).pay(
      config: superuserProductConfig,
      onSuccess: superUserPaymentSuccess,
      onFailure: superUserPaymentFailed,
      onCancel: superUserPaymentCancelled,
      preferences: [
        PaymentPreference.khalti,
        PaymentPreference.mobileBanking,
        PaymentPreference.eBanking,
        PaymentPreference.connectIPS,
        PaymentPreference.sct,
      ]);
}

// payment config
PaymentConfig superuserProductConfig = PaymentConfig(
    amount: 100, productIdentity: "PostReal", productName: "Super User");

// function to call when payment is succeed
void superUserPaymentSuccess(PaymentSuccessModel successModel) async {
  await FirestoreMethods().savePayment(successModel);
  Fluttertoast.showToast(msg: "You are now a super user.");
  Navigator.of(navKey.currentContext!)
      .pushNamedAndRemoveUntil(AppRoutes.homescreen, (route) => false);
}

// function to call when payment is failed
void superUserPaymentFailed(PaymentFailureModel failureModel) {
  Fluttertoast.showToast(msg: failureModel.message);
  Navigator.of(navKey.currentContext!).pop();
}

// function to call when payment is cancelled
void superUserPaymentCancelled() {
  debugPrint("Cancelled Payment");
}
