import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:postreal/business_logic/auth_bloc/auth_bloc.dart';
import 'package:postreal/constants/presentation_constants.dart';
import 'package:postreal/main.dart';
import 'package:postreal/presentation/shared_layout/home_screen.dart';
import 'package:postreal/presentation/widgets/bool_bottom_sheet.dart';
import 'package:postreal/presentation/widgets/custom_text.dart';
import 'package:postreal/presentation/widgets/verify_otp_widget.dart';
import 'package:postreal/utils/validator.dart';
import '../../constants/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailField.dispose();
    _passwordField.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is MessageState) {
          Fluttertoast.showToast(msg: state.message);
        }
      },
      builder: (context, state) {
        if (state is AppOpeningState) {
          return const Material(
              child: Center(child: CircularProgressIndicator()));
        } else if (state is LoggedInState) {
          return const HomeScreen();
        } else if (state is VerifyOTPState) {
          return VerifyOTPWidget(
            emailOrUserame: state.emailOrUserame,
            password: state.password,
          );
        }
        final size = MediaQuery.of(context).size;
        return WillPopScope(
          onWillPop: () async {
            bool? shouldExit = await booleanBottomSheet(
                context: context,
                titleText: closeAppTitle,
                boolTrueText: "Close PostReal");

            try {
              return shouldExit!;
            } catch (e) {
              debugPrint(e.toString());
              return false;
            }
          },
          child: Scaffold(
              body: SafeArea(
                  child: Center(
                      child: Form(
            key: _loginKey,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const Text(
                    "PostReal",
                    style: TextStyle(fontSize: 40),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  TextFormField(
                    controller: _emailField,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return TextFieldValidator.emailValidator(value);
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(
                          CupertinoIcons.mail,
                        )),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  TextFormField(
                    controller: _passwordField,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return TextFieldValidator.passwordValidator(value);
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(CupertinoIcons.padlock)),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_loginKey.currentState!.validate()) {
                              BlocProvider.of<AuthBloc>(navKey.currentContext!)
                                  .add(LoginClickedEvent(
                                      email: _emailField.text,
                                      password: _passwordField.text));
                            }
                          },
                          child: (state is LoadingState)
                              ? const LinearProgressIndicator()
                              : const CustomText(
                                  text: "Login", isBold: true, size: 18)),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  const Text("New User?"),
                  TextButton(
                      onPressed: (state is LoadingState)
                          ? null
                          : () {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.registerscreen);
                            },
                      child: const Text("Create Account",
                          style: TextStyle(fontSize: 16))),
                ])),
          )))),
        );
      },
    );
  }
}
