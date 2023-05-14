import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:postreal/business_logic/verifyotp_cubit/verifyotp_cubit.dart';
import 'package:postreal/main.dart';
import 'package:postreal/presentation/widgets/custom_text.dart';

class VerifyOTPWidget extends StatelessWidget {
  const VerifyOTPWidget({
    super.key,
    required this.emailOrUserame,
    required this.password,
  });
  final String emailOrUserame;
  final String password;
  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.email, size: 100),
            const SizedBox(height: 20),
            const CustomText(text: "OTP Verification", isBold: true),
            const SizedBox(height: 15),
            const CustomText(text: "Please check your email for OTP."),
            const SizedBox(height: 20),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Enter your OTP here.",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<VerifyOTPCubit>(navKey.currentContext!)
                        .verifyOTP(
                            emailOrUserame, password, otpController.text);
                  },
                  child: BlocConsumer<VerifyOTPCubit, VerifyOTPState>(
                    listener: (context, state) {
                      if (state is MessageState) {
                        Fluttertoast.showToast(msg: state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is LoadingState) {
                        return const LinearProgressIndicator();
                      }
                      return const Text("Verify");
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
