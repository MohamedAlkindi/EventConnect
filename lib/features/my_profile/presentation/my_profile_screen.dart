import 'dart:io';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/edit_profile/presentation/edit_profile_screen.dart';
import 'package:event_connect/features/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyProfileCubit()..getUserPicAndName(),
      child: const MyProfileScreenView(),
    );
  }
}

class MyProfileScreenView extends StatelessWidget {
  const MyProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    return Scaffold(
      body: Stack(
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
            child: Container(
              margin: const EdgeInsets.only(
                  top: 40, left: 12, right: 12, bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                    color: Colors.white.withOpacity(0.3), width: 1.2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: BlocConsumer<MyProfileCubit, MyProfileState>(
                    listener: (context, state) {
                      if (state is MyProfileError) {
                        showErrorDialog(
                          context: context,
                          message: state.message,
                        );
                      }
                      if (state is GotMyProfileInfo) {
                        confettiController.play();
                      }
                    },
                    builder: (context, state) {
                      if (state is GotMyProfileInfo) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 60),
                                // Profile header
                                Text(
                                  'My Profile',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),
                                // Profile picture with modern styling
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
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
                                        backgroundImage: (File(state
                                                        .userInfo.profilePic)
                                                    .existsSync()
                                                ? FileImage(File(
                                                    state.userInfo.profilePic))
                                                : const AssetImage(
                                                    'assets/images/generic_user.png'))
                                            as ImageProvider,
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
                                const SizedBox(height: 40),
                                // Modern action buttons
                                Container(
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EditProfileScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFF6C63FF),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    icon: const Icon(Icons.edit_rounded),
                                    label: Text(
                                      'Edit Account',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
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
                                              .read<MyProfileCubit>()
                                              .deleteUser();
                                          Navigator.pop(context);
                                          Navigator.popAndPushNamed(
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: const Color(0xFFFF6584),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    icon: const Icon(Icons.delete_rounded),
                                    label: Text(
                                      'Delete Account',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
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
          // Confetti effect
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFF6C63FF),
                Color(0xFFFF6584),
                Color(0xFFFFB74D),
                Colors.white,
              ],
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 20,
              minBlastForce: 8,
            ),
          ),
        ],
      ),
    );
  }
}
