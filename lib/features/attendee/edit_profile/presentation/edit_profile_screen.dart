import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/localization_extensions.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/attendee_widgets/user_profile_widgets.dart';
import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/features/attendee/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel userModel;
  const EditProfileScreen({
    super.key,
    required this.userModel,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<EditProfileCubit>();
    return Scaffold(
      body: BlocListener<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileLoading) {
            showLoadingDialog(context);
          }
          if (state is EditProfileError) {
            hideLoadingDialog(context);
            final l10n = AppLocalizations.of(context)!;
            final errorMsg = l10n.tryTranslate(state.message);
            showErrorDialog(
              context: context,
              message: errorMsg,
            );
          } else if (state is EditProfileSuccess) {
            hideLoadingDialog(context);
            showMessageDialog(
              context: context,
              titleText:
                  AppLocalizations.of(context)!.profileUpdateSuccessTitle,
              contentText:
                  AppLocalizations.of(context)!.profileUpdateSuccessContent,
              icon: Icons.check_circle_outline_rounded,
              iconColor: Colors.green,
              buttonText: AppLocalizations.of(context)!.okay,
              onPressed: () {
                Navigator.pop(context);
              },
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
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context, cubit.editedUserModel);
                        },
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: Colors.black,
                        // iconSize: 28,
                        tooltip: 'Back',
                      ),
                      headerText(context: context)
                    ],
                  ),
                  const SizedBox(height: 35),
                  // Profile picture with modern styling
                  BlocBuilder<EditProfileCubit, EditProfileState>(
                    builder: (context, state) {
                      return userProfilePicture(
                        backgroundImage:
                            cubit.getProfileImage(widget.userModel),
                        onPressed: () {
                          cubit.pickImage();
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 48),

                  // Modern form card
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

                        BlocBuilder<EditProfileCubit, EditProfileState>(
                          builder: (context, state) {
                            return cityDropDownMenu(
                              context: context,
                              formFieldValue:
                                  cubit.getCity(userModel: widget.userModel),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  cubit.selectCity(newValue);
                                }
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 40),
                        // Save button
                        saveButton(
                          context: context,
                          onTap: () {
                            cubit.updateUserProfile(
                              cachedImagePath:
                                  widget.userModel.cachedPicturePath!,
                              previouslySelectedCity: widget.userModel.location,
                              supabaseImageUrl: widget.userModel.profilePicUrl,
                              userRole: widget.userModel.role,
                            );
                          },
                        )
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
