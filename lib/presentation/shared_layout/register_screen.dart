import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postreal/business_logic/auth_bloc/auth_bloc.dart';
import 'package:postreal/presentation/shared_layout/home_screen.dart';
import 'package:postreal/presentation/widgets/bool_bottom_sheet.dart';
import 'package:postreal/utils/image_picker.dart';
import 'package:postreal/utils/validator.dart';
import 'package:postreal/constants/presentation_constants.dart';
import 'package:postreal/constants/routes.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _userSelfie;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
  }

  void selectSelfie() async {
    File? img = await pickImage(defaultTargetPlatform == TargetPlatform.iOS
        ? kDebugMode
            ? ImageSource.gallery
            : ImageSource.camera
        : ImageSource.camera);
    setState(() {
      _userSelfie = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    final state = authBloc.state;
    if (state is LoggedInState) {
      return const HomeScreen();
    } else if (state is ErrorState) {
      Fluttertoast.showToast(msg: state.message!);
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
              key: _registerKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("PostReal", style: TextStyle(fontSize: 40)),
                    SizedBox(height: size.height * 0.02),
                    Stack(children: [
                      _userSelfie != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: FileImage(_userSelfie!))
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: AssetImage(
                                  "lib/presentation/assets/selfie.png")),
                      Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            iconSize: 37,
                            onPressed: () {
                              selectSelfie();
                            },
                            icon: const Icon(Icons.add_a_photo),
                          ))
                    ]),
                    _userSelfie != null
                        ? const Text("Perfect!!!")
                        : const Text("Take a cool selfie"),
                    SizedBox(height: size.height * 0.02),
                    TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return TextFieldValidator.validateUsername(value);
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            hintText: "Username",
                            prefixIcon: Icon(CupertinoIcons.at))),
                    SizedBox(height: size.height * 0.02),
                    TextFormField(
                        controller: _bioController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return TextFieldValidator.bioValidator(value);
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            hintText: "Short bio",
                            prefixIcon:
                                Icon(Icons.sentiment_satisfied_alt_rounded))),
                    SizedBox(height: size.height * 0.02),
                    TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return TextFieldValidator.emailValidator(value);
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(CupertinoIcons.mail))),
                    SizedBox(height: size.height * 0.02),
                    TextFormField(
                        controller: _passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return TextFieldValidator.passwordValidator(value);
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(CupertinoIcons.padlock))),
                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_registerKey.currentState!.validate()) {
                                // if user did not take selfie
                                if (_userSelfie == null) {
                                  Fluttertoast.showToast(
                                      msg: noRegistrationSelfie);
                                }
                                // if user took selfie, we'll try to register them
                                else {
                                  authBloc.add(RegisterClickedEvent(
                                      _emailController.text,
                                      _usernameController.text,
                                      _bioController.text,
                                      _passwordController.text,
                                      _userSelfie!));
                                }
                              }
                            },
                            child: (state is LoadingState)
                                ? const LinearProgressIndicator()
                                : const Text(
                                    "Sign up",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  )),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    const Text("Returning User?"),
                    TextButton(
                        onPressed: (state is LoadingState)
                            ? null
                            : () {
                                authBloc.add(InitialEvent());
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.loginscreen,
                                );
                              },
                        child: const Text(
                          "Login Instead",
                          style: TextStyle(fontSize: 16),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
