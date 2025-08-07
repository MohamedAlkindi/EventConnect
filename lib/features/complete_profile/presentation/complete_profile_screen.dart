import 'package:event_connect/core/routes/routes.dart';
import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/localization_extensions.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/features/complete_profile/presentation/cubit/complete_profile_cubit.dart';
import 'package:event_connect/features/complete_profile/presentation/widgets/screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/attendee_widgets/user_profile_widgets.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompleteProfileCubit(),
      child: const CompleteProfileScreenView(),
    );
  }
}

class CompleteProfileScreenView extends StatelessWidget {
  const CompleteProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CompleteProfileCubit>();
    return Scaffold(
      // Receive the route name as an argument
      body: BlocListener<CompleteProfileCubit, CompleteProfileState>(
        listener: (context, state) {
          if (state is CompleteProfileLoading) {
            showLoadingDialog(context);
          } else if (state is CompleteProfileSuccessful) {
            hideLoadingDialog(context);
            showMessageDialog(
              context: context,
              titleText: AppLocalizations.of(context)!.profileSuccessTitle,
              contentText: AppLocalizations.of(context)!.profileSuccessContent,
              icon: Icons.check_circle_outline_rounded,
              iconColor: Colors.green,
              buttonText: AppLocalizations.of(context)!.proceed,
              onPressed: () {
                cubit.isEmailConfirmed();
              },
            );
          } else if (state is EmailConfirmed) {
            state.isConfirmed
                ? cubit.showUserHomescreen()
                : Navigator.of(context).pushNamedAndRemoveUntil(
                    emailConfirmationnRoute,
                    (Route<dynamic> route) => false,
                  );
          } else if (state is UserHomescreenRoute) {
            Navigator.pushReplacementNamed(
              context,
              state.userHomeScreenPageRoute,
            );
          } else if (state is CompleteProfileError) {
            hideLoadingDialog(context);
            final l10n = AppLocalizations.of(context)!;
            final errorMsg = l10n.tryTranslate(state.message);
            showErrorDialog(
              context: context,
              message: errorMsg,
            );
          }
        },
        child: Stack(
          children: [
            // Modern background with gradient and subtle overlay
            appBackgroundColors(),
            // Main frosted glass content
            userProfileBackground(
              childWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      completeProfileHeader(context: context),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // Profile Pic.
                  BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
                    builder: (context, state) {
                      return userProfilePicture(
                        backgroundImage: cubit.getImage(cubit: cubit),
                        onPressed: () {
                          cubit.pickImage();
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 48),

                  formCard(
                    childWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.selectYourCity,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6C63FF),
                          ),
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
                          builder: (context, state) {
                            return cityDropDownMenu(
                              context: context,
                              formFieldValue: cubit.selectedCity,
                              onChanged: (value) {
                                if (value != null) {
                                  cubit.selectCity(value);
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        Text(
                          AppLocalizations.of(context)!.youAre,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withAlpha((0.8 * 255).round()),
                          ),
                        ),
                        const SizedBox(height: 12),
                        BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                radioTileWidget(
                                  isSelected: true,
                                  valueText: 'Attendee',
                                  groupValue: cubit.selectedRole,
                                  onChanged: (value) {
                                    if (value != null) {
                                      cubit.selectRole(value);
                                    }
                                  },
                                  buttonTitle: AppLocalizations.of(context)!
                                      .roleAttendee,
                                ),
                                const SizedBox(width: 8),
                                radioTileWidget(
                                  isSelected: false,
                                  valueText: 'Manager',
                                  groupValue: cubit.selectedRole,
                                  onChanged: (value) {
                                    if (value != null) {
                                      cubit.selectRole(value);
                                    }
                                  },
                                  buttonTitle:
                                      AppLocalizations.of(context)!.roleManager,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        finalizeButton(
                          context: context,
                          onTap: () => context
                              .read<CompleteProfileCubit>()
                              .completeProfile(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
