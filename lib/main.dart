import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/firebase/config/firebase_options.dart';
import 'package:event_connect/features/complete_profile/presentation/complete_profile_screen.dart';
import 'package:event_connect/features/complete_profile/presentation/cubit/complete_profile_cubit.dart';
import 'package:event_connect/features/forgot_password/presentaion/cubit/reset_password_cubit.dart';
import 'package:event_connect/features/forgot_password/presentaion/forgot_password_screen.dart';
import 'package:event_connect/features/forgot_password/presentaion/reset_pass_confirmation_screen.dart';
import 'package:event_connect/features/login/presentation/cubit/login_cubit.dart';
import 'package:event_connect/features/login/presentation/login_screen.dart';
import 'package:event_connect/features/register/presentation/cubit/register_cubit.dart';
import 'package:event_connect/features/register/presentation/register_screen.dart';
import 'package:event_connect/features/welcome_screen/presentation/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String loginPageRoute = '/LoginPage';
String registerPageRoute = '/RegisterPage';
String forgotPasswordPageRoute = '/ForgotPasswordScreen';
String resetPasswordConfirmationPageRoute = '/ResetPasswordConfirmationPage';
String completeProfileInfoScreenRoute = '/CompleteProfileInfoScreen';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppDatabase.initializeDB();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (context) => ResetPasswordCubit(),
        ),
        BlocProvider(
          create: (context) => CompleteProfileCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
        routes: {
          loginPageRoute: (context) => LoginPage(),
          registerPageRoute: (context) => RegisterPage(),
          forgotPasswordPageRoute: (context) => ForgotPasswordScreen(),
          resetPasswordConfirmationPageRoute: (context) =>
              ResetPasswordConfirmationPage(),
          completeProfileInfoScreenRoute: (context) => CompleteProfileScreen(),
        },
      ),
    );
  }
}
