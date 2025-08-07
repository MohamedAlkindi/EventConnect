// TODO: Check deleting account.
// TODO: Then check caching shit when switching accounts.

import 'dart:ui';

import 'package:event_connect/core/routes/routes.dart';
import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/widgets/screen_buttons.dart';
import 'package:event_connect/features/welcome_screen/presentation/welcome_screen.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyProfileScreenView();
  }
}

class MyProfileScreenView extends StatelessWidget {
  const MyProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<MyProfileCubit>();
    return BlocListener<MyProfileCubit, MyProfileState>(
      listener: (context, state) async {
        if (state is UserSignedOutSuccessfully) {
          // reset cubits to initial state...
          await cubit.resetAllCubits(context: context);
          Navigator.of(context).pushNamedAndRemoveUntil(
            loginPageRoute,
            (Route<dynamic> route) => false,
          );
        } else if (state is UserDeletedSuccessfully) {
          await cubit.resetAllCubits(context: context);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else if (state is MyProfileLoading) {
          // Show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Deleting account...'),
                ],
              ),
            ),
          );
        } else if (state is MyProfileError) {
          // Hide loading dialog if it's showing
          Navigator.of(context).pop();
          // Show error dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Modern background with gradient and subtle overlay
            appBackgroundColors(),
            // Main frosted glass content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 32.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.18 * 255).round()),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                              color:
                                  Colors.black.withAlpha((0.12 * 255).round()),
                              width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.white.withAlpha((0.18 * 255).round()),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 32.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 16),
                              // Profile header
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!.myProfile,
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF6C63FF),
                                    shadows: [
                                      Shadow(
                                        color: Colors.black
                                            .withAlpha((0.08 * 255).round()),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Profile picture with modern styling
                              Center(
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withAlpha((0.12 * 255).round()),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      BlocBuilder<MyProfileCubit,
                                          MyProfileState>(
                                        builder: (context, state) {
                                          if (state is GotMyProfileInfo) {
                                            return CircleAvatar(
                                              radius: 80,
                                              backgroundColor: Colors.grey[200],
                                              backgroundImage: context
                                                  .read<MyProfileCubit>()
                                                  .getPicturePath(state),
                                            );
                                          }
                                          return Container(
                                            width: 160,
                                            height: 160,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 4,
                                              ),
                                              color: Colors.blue,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.person,
                                                size: 80,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6C63FF),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 3,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.celebration,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Modern action buttons
                              actionButton(
                                colorsList: [
                                  Color(0xFF6C63FF),
                                  Color(0xFFFF6584)
                                ],
                                onTap: () {
                                  cubit.changeAccountSettings(
                                    context: context,
                                    userModel: globalUserModel!,
                                  );
                                },
                                text: AppLocalizations.of(context)!.editAccount,
                                textColor: Colors.white,
                                icon: Icons.edit,
                                iconColor: Colors.white,
                              ),
                              const SizedBox(height: 16),

                              actionButton(
                                colorsList: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(255, 245, 243, 243)
                                ],
                                onTap: () {
                                  cubit.signOutDialog(context: context);
                                },
                                icon: Icons.logout_rounded,
                                iconColor: Colors.orangeAccent,
                                text: AppLocalizations.of(context)!.signOut,
                                textColor: Colors.orangeAccent,
                              ),
                              const SizedBox(height: 16),

                              actionButton(
                                colorsList: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(255, 245, 243, 243)
                                ],
                                onTap: () {
                                  cubit.deleteUserDialog(context: context);
                                },
                                icon: Icons.delete_forever_rounded,
                                iconColor: Colors.redAccent,
                                text:
                                    AppLocalizations.of(context)!.deleteAccount,
                                textColor: const Color(0xFFFF6584),
                              ),

                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
