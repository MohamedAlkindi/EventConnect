import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/firebase/config/firebase_options.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/features/all_events/presentation/all_events_screen.dart';
import 'package:event_connect/features/complete_profile/presentation/complete_profile_screen.dart';
import 'package:event_connect/features/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:event_connect/features/forgot_password/presentaion/cubit/reset_password_cubit.dart';
import 'package:event_connect/features/forgot_password/presentaion/forgot_password_screen.dart';
import 'package:event_connect/features/forgot_password/presentaion/reset_pass_confirmation_screen.dart';
import 'package:event_connect/features/login/business_logic/firebase_login.dart';
import 'package:event_connect/features/login/presentation/cubit/login_cubit.dart';
import 'package:event_connect/features/login/presentation/login_screen.dart';
import 'package:event_connect/features/my_events/presentation/my_events_screen.dart';
import 'package:event_connect/features/my_profile/presentation/my_profile_screen.dart';
import 'package:event_connect/features/register/presentation/cubit/register_cubit.dart';
import 'package:event_connect/features/register/presentation/register_screen.dart';
import 'package:event_connect/features/user_homescreen/presentation/user_homescreen.dart';
import 'package:event_connect/features/welcome_screen/presentation/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

FirebaseUser user = FirebaseUser();
FirebaseLogin loginCheckup = FirebaseLogin();

String loginPageRoute = '/LoginPage';
String registerPageRoute = '/RegisterPage';
String forgotPasswordPageRoute = '/ForgotPasswordScreen';
String resetPasswordConfirmationPageRoute = '/ResetPasswordConfirmationPage';
String completeProfileInfoScreenRoute = '/CompleteProfileInfoScreen';
String userHomeScreenPageRoute = '/UserHomeScreen';
String allEventsRoute = '/AllEventsScreen';
String myEventsRoute = '/MyEventsScreen';
String userProfileRoute = '/MyProfileScreen';

bool isUserSignedIn = user.getUser != null;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppDatabase.initializeDatabase();
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
          create: (context) => EditProfileCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: isUserSignedIn
        //     ? isUserCompleted
        //         ? UserHomeScreen()
        //         : WelcomeScreen()
        //     : WelcomeScreen(),
        home: WelcomeScreen(),
        routes: {
          loginPageRoute: (context) => LoginPage(),
          registerPageRoute: (context) => RegisterPage(),
          forgotPasswordPageRoute: (context) => ForgotPasswordScreen(),
          resetPasswordConfirmationPageRoute: (context) =>
              ResetPasswordConfirmationPage(),
          completeProfileInfoScreenRoute: (context) => CompleteProfileScreen(),
          userHomeScreenPageRoute: (context) => UserHomeScreen(),
          allEventsRoute: (context) => AllEventsScreen(),
          myEventsRoute: (context) => MyEventsScreen(),
          userProfileRoute: (context) => MyProfileScreen(),
        },
      ),
    );
  }
}
