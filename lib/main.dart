import 'package:event_connect/core/firebase/config/firebase_options.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/theme/app_theme.dart';
import 'package:event_connect/features/attendee/all_events/presentation/all_events_screen.dart';
import 'package:event_connect/features/attendee/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/my_events_screen.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/my_profile_screen.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/user_homescreen.dart';
import 'package:event_connect/features/complete_profile/presentation/complete_profile_screen.dart';
import 'package:event_connect/features/email_confirmation/cubit/email_confirmation_cubit.dart';
import 'package:event_connect/features/email_confirmation/email_confirmation_screen.dart';
import 'package:event_connect/features/forgot_password/presentaion/cubit/reset_password_cubit.dart';
import 'package:event_connect/features/forgot_password/presentaion/forgot_password_screen.dart';
import 'package:event_connect/features/forgot_password/presentaion/reset_pass_confirmation_screen.dart';
import 'package:event_connect/features/login/presentation/cubit/login_cubit.dart';
import 'package:event_connect/features/login/presentation/login_screen.dart';
import 'package:event_connect/features/manager/manager_events/presentation/add_event_screen.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/add_event_cubit.dart';
import 'package:event_connect/features/manager/manager_homescreen/manager_homescreen.dart';
import 'package:event_connect/features/register/presentation/cubit/register_cubit.dart';
import 'package:event_connect/features/register/presentation/register_screen.dart';
import 'package:event_connect/features/welcome_screen/presentation/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const String loginPageRoute = '/LoginPage';
const String registerPageRoute = '/RegisterPage';
const String forgotPasswordPageRoute = '/ForgotPasswordScreen';
const String resetPasswordConfirmationPageRoute =
    '/ResetPasswordConfirmationPage';
const String completeProfileInfoScreenRoute = '/CompleteProfileInfoScreen';
const String attendeeHomeScreenPageRoute = '/UserHomeScreen';
const String allEventsRoute = '/AllEventsScreen';
const String myEventsRoute = '/MyEventsScreen';
const String attendeeProfileRoute = '/MyProfileScreen';
const String emailConfirmationnRoute = '/EmailConfirmationScreen';
const String managerHomeScreenPageRoute = '/ManagerHomescreen';
const String addEventScreenPageRoute = '/AddEventScreen';

late Widget startUpWidget;

Future<Widget> whichWidget() async {
  final user = FirebaseUser();

  if (user.getUser != null) {
    if (user.isVerified) {
      if (await user.isUserDataCompleted() == true) {
        if (await user.getUserRole() == "Attendee") {
          return UserHomeScreen();
        } else {
          return ManagerHomescreen();
        }
      } else {
        return CompleteProfileScreen();
      }
    } else {
      return EmailConfirmationScreen();
    }
  } else {
    return WelcomeScreen();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
      url: 'https://mretvbuvvmcbjdivlogc.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1yZXR2YnV2dm1jYmpkaXZsb2djIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NTM0MzgsImV4cCI6MjA2NjAyOTQzOH0.xPz552lN_TfgO1RX7CjHYheRJ04nmio0WV_Z6Yw-7Fw');
  startUpWidget = await whichWidget();
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
        BlocProvider(
          create: (context) => EmailConfirmationCubit(),
        ),
        BlocProvider(
          create: (context) => AddEventCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: startUpWidget,
        routes: {
          loginPageRoute: (context) => LoginPage(),
          registerPageRoute: (context) => RegisterPage(),
          forgotPasswordPageRoute: (context) => ForgotPasswordScreen(),
          resetPasswordConfirmationPageRoute: (context) =>
              ResetPasswordConfirmationPage(),
          completeProfileInfoScreenRoute: (context) => CompleteProfileScreen(),
          attendeeHomeScreenPageRoute: (context) => UserHomeScreen(),
          allEventsRoute: (context) => AllEventsScreen(),
          myEventsRoute: (context) => MyEventsScreen(),
          attendeeProfileRoute: (context) => MyProfileScreen(),
          emailConfirmationnRoute: (context) => EmailConfirmationScreen(),
          managerHomeScreenPageRoute: (context) => ManagerHomescreen(),
          addEventScreenPageRoute: (context) => AddEventScreen(),
        },
      ),
    );
  }
}
