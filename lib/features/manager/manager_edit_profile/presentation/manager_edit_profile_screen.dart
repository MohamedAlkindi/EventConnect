import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/localization_extensions.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/manager_widgets/manager_profile_widgets.dart';
import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/features/manager/manager_edit_profile/presentation/cubit/manager_edit_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class ManagerEditProfileScreen extends StatefulWidget {
  final UserModel userModel;
  const ManagerEditProfileScreen({super.key, required this.userModel});

  @override
  State<ManagerEditProfileScreen> createState() =>
      _ManagerEditProfileScreenState();
}

class _ManagerEditProfileScreenState extends State<ManagerEditProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ManagerEditProfileCubit>();
    return Scaffold(
      body: BlocListener<ManagerEditProfileCubit, ManagerEditProfileState>(
        listener: (context, state) {
          if (state is ManagerEditProfileLoading) {
            showLoadingDialog(context);
          }
          if (state is ManagerEditProfileError) {
            hideLoadingDialog(context);
            final l10n = AppLocalizations.of(context)!;
            final errorMsg = l10n.tryTranslate(state.message);
            showErrorDialog(
              context: context,
              message: errorMsg,
            );
          } else if (state is ManagerEditProfileSuccess) {
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
            profileFrostedContainerWidget(
              childWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context, cubit.editedManagerModel);
                        },
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: Colors.black,
                        // iconSize: 28,
                        tooltip: 'Back',
                      ),
                      managerProfileHeader(
                        headerText: AppLocalizations.of(context)!.editProfile,
                      )
                    ],
                  ),
                  const SizedBox(height: 35),
                  // Profile picture with modern styling
                  BlocBuilder<ManagerEditProfileCubit, ManagerEditProfileState>(
                    builder: (context, state) {
                      return managerProfilePicture(
                          backgroundImage:
                              cubit.getProfileImage(widget.userModel),
                          onPressed: cubit.pickImage);
                    },
                  ),
                  const SizedBox(height: 48),

                  // Modern form card
                  managerFormCard(
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
                        BlocBuilder<ManagerEditProfileCubit,
                            ManagerEditProfileState>(
                          builder: (context, state) {
                            return managerCityDropDownMenu(
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
                        managerSaveButton(
                          context: context,
                          onTap: () {
                            cubit.updateManagerProfile(
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
