import 'dart:io';
import 'dart:ui';

import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EditProfileCubit>().getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<EditProfileCubit>();
    return Scaffold(
      body: BlocListener<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileError) {
            showErrorDialog(
              context: context,
              message: state.message,
            );
          } else if (state is EditProfileSuccess) {
            showMessageDialog(
              context: context,
              titleText: 'Success! 🎉',
              contentText: 'Profile updated successfully!',
              icon: Icons.check_circle_outline_rounded,
              iconColor: Colors.green,
              buttonText: 'Okay',
              onPressed: () {
                Navigator.popAndPushNamed(
                  context,
                  userProfileRoute,
                );
              },
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
                    child: SafeArea(
                      child: CustomScrollView(
                        slivers: [
                          // Modern header
                          SliverAppBar(
                            expandedHeight: 200,
                            pinned: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF6C63FF),
                                      Color(0xFFFF6584)
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 40),
                                      Text(
                                        'Edit Profile',
                                        style: GoogleFonts.poppins(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              offset: const Offset(2, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Update your personal information',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            leading: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  // Profile picture with modern styling
                                  Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFF6C63FF),
                                              Color(0xFFFF6584)
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF6C63FF)
                                                  .withOpacity(0.3),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: BlocBuilder<EditProfileCubit,
                                            EditProfileState>(
                                          builder: (context, state) {
                                            if (state is GotUserProfile) {
                                              return CircleAvatar(
                                                radius: 80,
                                                backgroundColor: Colors.white,
                                                backgroundImage: cubit
                                                            .newSelectedImagePath !=
                                                        null
                                                    ? FileImage(File(cubit
                                                        .newSelectedImagePath!))
                                                    : FileImage(File(state
                                                            .userProfile
                                                            .profilePic))
                                                        as ImageProvider,
                                              );
                                            }
                                            return const CircleAvatar(
                                              radius: 80,
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.person,
                                                size: 80,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 10,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () => cubit.pickImage(),
                                            icon: const Icon(
                                              Icons.camera_alt_rounded,
                                              color: Color(0xFF6C63FF),
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                  // Modern form card
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Location section
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF6C63FF)
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: const Icon(
                                                Icons.location_on_rounded,
                                                color: Color(0xFF6C63FF),
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              "Location",
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF6C63FF),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        BlocBuilder<EditProfileCubit,
                                            EditProfileState>(
                                          builder: (context, state) {
                                            if (state is GotUserProfile) {
                                              cubit.previouslySelectedCity =
                                                  state.userProfile.location;
                                              return DropdownButtonFormField<
                                                  String>(
                                                decoration: InputDecoration(
                                                  labelText: "Select your city",
                                                  labelStyle:
                                                      GoogleFonts.poppins(
                                                    color: Colors.grey,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    borderSide: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    borderSide: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Color(0xFF6C63FF),
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.grey
                                                      .withOpacity(0.05),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 20,
                                                    vertical: 16,
                                                  ),
                                                ),
                                                value: cubit
                                                    .previouslySelectedCity,
                                                items: cubit.yemeniCities
                                                    .map((String city) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: city,
                                                    child: Text(
                                                      city,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  if (newValue != null) {
                                                    cubit.selectCity(newValue);
                                                  }
                                                },
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                        const SizedBox(height: 24),
                                        // Save button
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              cubit.updateUserProfile();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF6C63FF),
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: Text(
                                              'Save Changes',
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
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
                          ),
                        ],
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
