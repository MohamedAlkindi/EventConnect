import 'dart:io';
import 'dart:ui';

import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/attendee/edit_profile/presentation/cubit/edit_profile_cubit.dart';
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
                Navigator.pushReplacementNamed(
                  context,
                  attendeeHomeScreenPageRoute,
                );
              },
            );
          }
        },
        child: Stack(children: [
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
                    horizontal: 28.0, vertical: 32.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                            color: Colors.black.withOpacity(0.2), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              "Edit Your Profile",
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6C63FF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          // Profile picture with modern styling
                          Stack(
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
                                child: BlocBuilder<EditProfileCubit,
                                    EditProfileState>(
                                  builder: (context, state) {
                                    return CircleAvatar(
                                      radius: 80,
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: state is GotUserProfile
                                          // when entering the app this state will be init.

                                          // get the picture from the state.
                                          ? (File(state.userProfile.profilePic)
                                                      .existsSync()
                                                  ? FileImage(
                                                      File(state.userProfile
                                                          .profilePic),
                                                    )
                                                  : const AssetImage(
                                                      'assets/images/generic_user.png'))
                                              as ImageProvider
                                          // if the user changed the location only.
                                          // the state will be SelectedCity so all the states are false.
                                          // So get the old picture that was saved first from cubit,
                                          : state is SelectedImage
                                              ? FileImage(
                                                  File(state.selectedImagePath),
                                                ) as ImageProvider
                                              // check if the user registered a new pic first.
                                              : cubit.newSelectedImagePath ==
                                                      null
                                                  ? cubit.previouslySelectedImagePath ==
                                                          null
                                                      ? const AssetImage(
                                                              'assets/images/generic_user.png')
                                                          as ImageProvider
                                                      : FileImage(
                                                          File(cubit
                                                              .previouslySelectedImagePath!),
                                                        ) as ImageProvider
                                                  : FileImage(
                                                      File(cubit
                                                          .newSelectedImagePath!),
                                                    ),
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
                                    onPressed: () => cubit.pickImage(),
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
                          const SizedBox(height: 48),
                          // Modern form card
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Your City",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                BlocBuilder<EditProfileCubit, EditProfileState>(
                                  builder: (context, state) {
                                    return DropdownButtonFormField<String>(
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
                                            color: Colors.grey.withOpacity(0.5),
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
                                      // Same as the picture!
                                      value: state is GotUserProfile
                                          ? state.userProfile.location
                                          : state is SelectedCity
                                              ? state.selectedCity
                                              : cubit.newSelectedCity == null
                                                  ? cubit.previouslySelectedCity
                                                  : cubit.newSelectedCity!,
                                      items:
                                          cubit.yemeniCities.map((String city) {
                                        return DropdownMenuItem<String>(
                                          value: city,
                                          child: Text(
                                            city,
                                            style: GoogleFonts.poppins(),
                                          ),
                                        );
                                      }).toList(),
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
                                        cubit.updateUserProfile();
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Center(
                                        child: Text(
                                          'Save Changes',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
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
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
