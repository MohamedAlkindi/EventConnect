import 'package:event_connect/features/attendee/all_events/presentation/all_events_screen.dart';
import 'package:event_connect/features/attendee/my_events/presentation/my_events_screen.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/my_profile_screen.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/user_homescreen.dart';
import 'package:event_connect/features/complete_profile/presentation/complete_profile_screen.dart';
import 'package:event_connect/features/email_confirmation/presentation/email_confirmation_screen.dart';
import 'package:event_connect/features/forgot_password/presentaion/forgot_password_screen.dart';
import 'package:event_connect/features/forgot_password/presentaion/reset_pass_confirmation_screen.dart';
import 'package:event_connect/features/login/presentation/login_screen.dart';
import 'package:event_connect/features/manager/manager_events/presentation/add_event_screen.dart';
import 'package:event_connect/features/manager/manager_homescreen/presentation/manager_homescreen.dart';
import 'package:event_connect/features/register/presentation/register_screen.dart';
import 'package:flutter/material.dart';

const String loginPageRoute = '/LoginPage';
const String registerPageRoute = '/RegisterPage';
const String forgotPasswordPageRoute = '/ForgotPasswordScreen';
const String resetPasswordConfirmationPageRoute =
    '/ResetPasswordConfirmationPage';
const String completeProfileInfoScreenRoute = '/CompleteProfileScreenView';
const String attendeeHomeScreenPageRoute = '/UserHomeScreen';
const String allEventsRoute = '/AllEventsScreen';
const String myEventsRoute = '/MyEventsScreen';
const String attendeeProfileRoute = '/MyProfileScreen';
const String emailConfirmationnRoute = '/EmailConfirmationScreen';
const String managerHomeScreenPageRoute = '/ManagerHomescreen';
const String addEventScreenPageRoute = '/AddEventScreen';

Map<String, Widget Function(BuildContext)> routes = {
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
};
