import 'dart:io';
import 'dart:ui';

import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/complete_profile/presentation/cubit/complete_profile_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocListener<CompleteProfileCubit,
                              CompleteProfileState>(
                            listener: (context, state) {
                              if (state is CompleteProfileLoading) {
                                showLoadingDialog(context);
                              } else if (state is CompleteProfileSuccessul) {
                                hideLoadingDialog(context);
                                showMessageDialog(
                                  context: context,
                                  titleText: 'Success! 🥳',
                                  contentText:
                                      "You have successfully completed your profile!",
                                  icon: Icons.check_circle_outline_rounded,
                                  iconColor: Colors.green,
                                  buttonText: 'Head to Login',
                                  onPressed: () {
                                    Navigator.popAndPushNamed(
                                      context,
                                      loginPageRoute,
                                    );
                                  },
                                );
                              } else if (state is CompleteProfileError) {
                                hideLoadingDialog(context);
                                showErrorDialog(
                                  context: context,
                                  message: state.message,
                                );
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Complete Your Profile",
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Add your profile picture and location to get started",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Center(
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: BlocBuilder<CompleteProfileCubit,
                                            CompleteProfileState>(
                                          builder: (context, state) {
                                            final cubit = context
                                                .read<CompleteProfileCubit>();
                                            return CircleAvatar(
                                              radius: 80,
                                              backgroundColor: Colors.white,
                                              backgroundImage: cubit
                                                          .selectedImagePath !=
                                                      null
                                                  ? FileImage(File(cubit
                                                          .selectedImagePath!))
                                                      as ImageProvider
                                                  : AssetImage(cubit
                                                          .defaultImagePath)
                                                      as ImageProvider,
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6C63FF),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () => context
                                                .read<CompleteProfileCubit>()
                                                .pickImage(),
                                            icon: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Select Your City",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF6C63FF),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      BlocBuilder<CompleteProfileCubit,
                                          CompleteProfileState>(
                                        builder: (context, state) {
                                          final cubit = context
                                              .read<CompleteProfileCubit>();
                                          return DropdownButtonFormField<
                                              String>(
                                            decoration: InputDecoration(
                                              labelText: "City",
                                              labelStyle: GoogleFonts.poppins(
                                                color: Colors.grey,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF6C63FF),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF6C63FF),
                                                ),
                                              ),
                                            ),
                                            value: cubit.defaultCity,
                                            items:
                                                cubit.yemeniCities.map((city) {
                                              return DropdownMenuItem<String>(
                                                value: city,
                                                child: Text(
                                                  city,
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                cubit.selectCity(value);
                                              }
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 32),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () => context
                                              .read<CompleteProfileCubit>()
                                              .completeProfile(),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF6C63FF),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            elevation: 5,
                                          ),
                                          child: Text(
                                            "Finalize Profile",
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
