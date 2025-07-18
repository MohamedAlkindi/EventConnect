import 'dart:io';
import 'dart:ui';

import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/manager/manager_edit_profile/presentation/manager_edit_profile_screen.dart';
import 'package:event_connect/features/manager/manager_homescreen/presentation/cubit/manager_homescreen_cubit.dart';
import 'package:event_connect/features/manager/manager_profile/presentation/cubit/manager_profile_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFe0e7ff),
                    Color(0xFFfceabb),
                    Color(0xFFf8b6b8)
                  ],
                ),
              ),
            ),
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
                        child: BlocBuilder<ManagerProfileCubit,
                            ManagerProfileState>(
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
                                    Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.myProfile,
                                        style: GoogleFonts.poppins(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF6C63FF),
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withAlpha(
                                                  (0.08 * 255).round()),
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
                                              color: Colors.black.withAlpha(
                                                  (0.12 * 255).round()),
                                              blurRadius: 20,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 80,
                                              backgroundImage: state.userInfo
                                                      .profilePic.isNotEmpty
                                                  ? state.userInfo.profilePic
                                                          .startsWith("http")
                                                      ? NetworkImage(
                                                          state.userInfo
                                                              .profilePic,
                                                        )
                                                      : File(state.userInfo
                                                                  .profilePic)
                                                              .existsSync()
                                                          ? FileImage(File(state
                                                              .userInfo
                                                              .profilePic))
                                                          : const AssetImage(
                                                              'assets/images/generic_user.png')
                                                  : const AssetImage(
                                                      'assets/images/generic_user.png'),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF6C63FF),
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
                                    Container(
                                      width: double.infinity,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF6C63FF),
                                            Color(0xFFFF6584)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF6C63FF)
                                                .withAlpha(
                                                    (0.18 * 255).round()),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () async {
                                            // Use local variable for context.read
                                            final managerProfileCubit = context
                                                .read<ManagerProfileCubit>();
                                            final managerHomescreenCubit =
                                                context.read<
                                                    ManagerHomescreenCubit>();
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ManagerEditProfileScreen(),
                                              ),
                                            );
                                            if (result != null) {
                                              managerProfileCubit
                                                  .getManagerPicAndLocation();
                                              managerHomescreenCubit
                                                  .getManagerProfilePic();
                                            }
                                          },
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.edit_rounded,
                                                    color: Colors.white),
                                                const SizedBox(width: 8),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .editAccount,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      width: double.infinity,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withAlpha((0.1 * 255).round()),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            showMessageDialog(
                                              context: context,
                                              icon: Icons.warning_rounded,
                                              iconColor: Colors.orangeAccent,
                                              titleText:
                                                  AppLocalizations.of(context)!
                                                      .signOutTitle,
                                              contentText:
                                                  AppLocalizations.of(context)!
                                                      .signOutContent,
                                              buttonText:
                                                  AppLocalizations.of(context)!
                                                      .yes,
                                              onPressed: () {
                                                context
                                                    .read<ManagerProfileCubit>()
                                                    .userSignOut();
                                                Navigator.pop(context);
                                              },
                                              secondButtonText:
                                                  AppLocalizations.of(context)!
                                                      .no,
                                              secondOnPressed: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.logout_rounded,
                                                    color: Colors.orangeAccent),
                                                const SizedBox(width: 8),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .signOut,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.orangeAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      width: double.infinity,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withAlpha((0.1 * 255).round()),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            showMessageDialog(
                                              context: context,
                                              icon: Icons.warning_rounded,
                                              iconColor: Colors.red,
                                              titleText:
                                                  AppLocalizations.of(context)!
                                                      .deleteAccountTitle,
                                              contentText:
                                                  AppLocalizations.of(context)!
                                                      .deleteAccountContent,
                                              buttonText:
                                                  AppLocalizations.of(context)!
                                                      .delete,
                                              onPressed: () {
                                                context
                                                    .read<ManagerProfileCubit>()
                                                    .deleteUser();
                                                Navigator.pop(context);
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  loginPageRoute,
                                                );
                                              },
                                              secondButtonText:
                                                  AppLocalizations.of(context)!
                                                      .cancel,
                                              secondOnPressed: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.delete_rounded,
                                                    color: Color(0xFFFF6584)),
                                                const SizedBox(width: 8),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .deleteAccount,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xFFFF6584),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
