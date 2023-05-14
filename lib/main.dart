import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:postreal/business_logic/auth_bloc/auth_bloc.dart';
import 'package:postreal/business_logic/switch_theme_cubit/switch_theme_cubit.dart';
import 'package:postreal/business_logic/verifyotp_cubit/verifyotp_cubit.dart';
import 'package:postreal/my_keys.dart';
import 'package:postreal/presentation/shared_layout/addphoto_screen.dart';
import 'package:postreal/presentation/shared_layout/home_screen.dart';
import 'package:postreal/presentation/shared_layout/login_screen.dart';
import 'package:postreal/presentation/shared_layout/register_screen.dart';
import 'package:postreal/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'constants/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VerifyOTPCubit>(create: (context) => VerifyOTPCubit()),
        BlocProvider<SwitchThemeCubit>(create: (context) => SwitchThemeCubit()),
        BlocProvider<AuthBloc>(
            create: (BuildContext context) =>
                AuthBloc()..add(AuthCheckerEvent())),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return BlocBuilder<SwitchThemeCubit, ThemeData>(
              builder: (context, themeToShow) {
                BlocProvider.of<SwitchThemeCubit>(context)
                    .emitAppOpeningTheme();
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    navigatorKey: navKey,
                    title: 'PostReal',
                    theme: themeToShow,
                    routes: {
                      AppRoutes.loginscreen: (context) => const LoginScreen(),
                      AppRoutes.registerscreen: (context) =>
                          const RegisterScreen(),
                      AppRoutes.addPostScreen: (context) =>
                          const AddPostScreen(),
                      AppRoutes.homescreen: (context) => const HomeScreen(),
                    },
                    home: const LoginScreen());
              },
            );
          }),
    );
  }
}
