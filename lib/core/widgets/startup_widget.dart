import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/user_homescreen.dart';
import 'package:event_connect/features/authentication/email_confirmation/presentation/email_confirmation_screen.dart';
import 'package:event_connect/features/complete_profile/presentation/complete_profile_screen.dart';
import 'package:event_connect/features/manager/manager_homescreen/presentation/manager_homescreen.dart';
import 'package:event_connect/features/welcome_screen/presentation/welcome_screen.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';

Future<Widget> whichWidget() async {
  final user = FirebaseUser();

  if (user.getUser == null) {
    return WelcomeScreen();
  }
  if (!await user.isVerified) {
    return EmailConfirmationScreen();
  }
  if (!await user.isUserDataCompleted()) {
    return CompleteProfileScreen();
  }
  globalUserModel = await user.getUserInfo();
  final role = await user.getUserRole();
  if (role == "Attendee") {
    return UserHomeScreen();
  }
  if (role == "Manager") {
    return ManagerHomescreen();
  }
  return WelcomeScreen();
}
