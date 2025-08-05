import 'package:event_connect/core/widgets/manager_widgets/manager_profile_widgets.dart';
import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/features/manager/manager_profile/presentation/cubit/manager_profile_cubit.dart';
import 'package:event_connect/features/manager/manager_profile/presentation/widgets/screen_buttons.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManagerProfileScreen extends StatelessWidget {
  const ManagerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerProfileScreenView();
  }
}

class ManagerProfileScreenView extends StatelessWidget {
  const ManagerProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ManagerProfileCubit>();
    return Scaffold(
      body: BlocListener<ManagerProfileCubit, ManagerProfileState>(
        listener: (context, state) {
          if (state is ManagerSignedOutSuccessfully) {
            Navigator.pushReplacementNamed(
              context,
              loginPageRoute,
            );
          }
        },
        child: Stack(
          children: [
            // Modern background with gradient and subtle overlay
            appBackgroundColors(),
            // Main frosted glass content
            profileFrostedContainerWidget(
              childWidget:
                  BlocBuilder<ManagerProfileCubit, ManagerProfileState>(
                builder: (context, state) {
                  if (state is GotManagerProfileInfo) {
                    return Padding(
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
                            childWidget: managerProfilePicStack(
                              cubit: cubit,
                              cachedPicturePath:
                                  state.userInfo.cachedPicturePath,
                              profilePicUrl: state.userInfo.profilePicUrl,
                            ),
                          ),

                          const SizedBox(height: 32),
                          // Modern action buttons
                          managerActionButton(
                            colorsList: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                            onTap: () => cubit.changeAccountSettings(
                              context: context,
                              cachedImagePath:
                                  state.userInfo.cachedPicturePath!,
                            ),
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
                            onTap: () => cubit.signOutDialog(context: context),
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
                            onTap: () =>
                                cubit.deleteUserDialog(context: context),
                            icon: Icons.delete_forever_rounded,
                            iconColor: Colors.redAccent,
                            text: AppLocalizations.of(context)!.deleteAccount,
                            textColor: const Color(0xFFFF6584),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
