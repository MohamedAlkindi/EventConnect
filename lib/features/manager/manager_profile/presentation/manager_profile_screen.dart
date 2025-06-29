import 'dart:io';
import 'dart:ui';

import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/manager/manager_profile/presentation/cubit/manager_profile_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ManagerProfileScreen extends StatelessWidget {
  const ManagerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManagerProfileCubit()..getUserPicAndName(),
      child: const ManagerProfileScreenView(),
    );
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
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                              color: Colors.black.withOpacity(0.12),
                              width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.18),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: BlocConsumer<ManagerProfileCubit,
                            ManagerProfileState>(
                          listener: (context, state) {
                            if (state is ManagerProfileError) {
                              showErrorDialog(
                                context: context,
                                message: state.message,
                              );
                            }
                          },
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
                                        'My Profile',
                                        style: GoogleFonts.poppins(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF6C63FF),
                                          shadows: [
                                            Shadow(
                                              color: Colors.black
                                                  .withOpacity(0.08),
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
                                                  .withOpacity(0.12),
                                              blurRadius: 20,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 80,
                                              backgroundColor: Colors.grey[200],
                                              backgroundImage: (File(
                                                              state.userInfo
                                                                  .profilePic)
                                                          .existsSync()
                                                      ? FileImage(
                                                          File(
                                                              state.userInfo
                                                                  .profilePic))
                                                      : const AssetImage(
                                                          'assets/images/generic_user.png'))
                                                  as ImageProvider,
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
                                                .withOpacity(0.18),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            // TODO: Here'll be the edit page...
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         const EditProfileScreen(),
                                            //   ),
                                            // );
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
                                                  'Edit Account',
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
                                            color:
                                                Colors.black.withOpacity(0.1),
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
                                              titleText: 'Sign out😐',
                                              contentText:
                                                  'Are you sure you want to sign out?',
                                              buttonText: 'Yes',
                                              onPressed: () {
                                                context
                                                    .read<ManagerProfileCubit>()
                                                    .userSignOut();
                                                Navigator.pop(context);
                                              },
                                              secondButtonText: 'No',
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
                                                  'Sign Out',
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
                                            color:
                                                Colors.black.withOpacity(0.1),
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
                                              titleText: 'Delete Account 😐',
                                              contentText:
                                                  'Are you sure you want to delete your account?',
                                              buttonText: 'Delete',
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
                                              secondButtonText: 'Cancel',
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
                                                  'Delete Account',
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
