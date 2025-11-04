import 'package:event_connect/core/routes/routes.dart';
import 'package:event_connect/core/widgets/manager_widgets/manager_profile_widgets.dart';
import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/features/manager/manager_profile/presentation/cubit/manager_profile_cubit.dart';
import 'package:event_connect/features/manager/manager_profile/presentation/widgets/screen_buttons.dart';
import 'package:event_connect/features/welcome_screen/presentation/welcome_screen.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_connect/l10n/app_localizations.dart';

class ManagerProfileScreen extends StatelessWidget {
  const ManagerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<ManagerProfileCubit>()
        .getManagerInfo(updatedManagerModel: null);
    return ManagerProfileScreenView();
  }
}

class ManagerProfileScreenView extends StatelessWidget {
  const ManagerProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ManagerProfileCubit>();
    return BlocListener<ManagerProfileCubit, ManagerProfileState>(
      listener: (context, state) async {
        if (state is ManagerSignedOutSuccessfully) {
          // Reset cubits and global variables
          await cubit.resetAllCubits(context: context);
          Navigator.of(context).pushNamedAndRemoveUntil(
            loginPageRoute,
            (Route<dynamic> route) => false,
          );
        } else if (state is ManagerDeletedSuccessfully) {
          // Reset cubits and global variables
          await cubit.resetAllCubits(context: context);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else if (state is ManagerProfileLoading) {
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
        } else if (state is ManagerProfileError) {
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
            profileFrostedContainerWidget(
              childWidget: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    // Profile header
                    managerProfileHeader(
                      headerText: AppLocalizations.of(context)!.myProfile,
                    ),
                    const SizedBox(height: 32),
                    // Profile picture with modern styling
                    profilePicContainer(
                      childWidget:
                          BlocBuilder<ManagerProfileCubit, ManagerProfileState>(
                        builder: (context, state) {
                          if (state is GotManagerProfileInfo) {
                            return managerProfilePicStack(
                              cubit: cubit,
                              state: state,
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
                    ),

                    const SizedBox(height: 32),
                    // Modern action buttons
                    managerActionButton(
                      colorsList: [Color(0xFF6C63FF), Color(0xFFFF6584)],
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

                    managerActionButton(
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

                    managerActionButton(
                      colorsList: [
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 245, 243, 243)
                      ],
                      onTap: () {
                        cubit.deleteUserDialog(context: context);
                      },
                      icon: Icons.delete_forever_rounded,
                      iconColor: Colors.redAccent,
                      text: AppLocalizations.of(context)!.deleteAccount,
                      textColor: const Color(0xFFFF6584),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
