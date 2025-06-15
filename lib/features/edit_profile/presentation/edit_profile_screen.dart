import 'dart:io';

import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocListener<EditProfileCubit, EditProfileState>(
        listener: (context, state) async {
          if (state is EditProfileSuccess) {
            showMessageDialog(
              context: context,
              icon: Icons.check_circle_outline_rounded,
              iconColor: Colors.green,
              titleText: 'Success! 🥳',
              contentText: "You have successfully updated your profile!",
              buttonText: 'Head to Home',
              onPressed: () {
                Navigator.popAndPushNamed(
                  context,
                  userHomeScreenPageRoute,
                );
              },
            );
          } else if (state is EditProfileError) {
            showMessageDialog(
              context: context,
              icon: Icons.error_outline_rounded,
              iconColor: Colors.red,
              titleText: 'Error!',
              contentText: state.message,
              buttonText: 'OK',
              onPressed: () {
                Navigator.pop(context);
              },
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: BlocBuilder<EditProfileCubit, EditProfileState>(
                          builder: (context, state) {
                            return CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: state is GotUserProfile
                                  // when entering the app this state will be init.
                                  // get the picture from the state.
                                  ? FileImage(
                                      File(state.userProfile.profilePic),
                                    ) as ImageProvider
                                  // if the user changed the location only.
                                  // the state will be SelectedCity so all the states are false.
                                  // So get the old picture that was saved first from cubit,
                                  : state is SelectedImage
                                      ? FileImage(
                                          File(state.selectedImagePath),
                                        ) as ImageProvider
                                      // check if the user registered a new pic first.
                                      : cubit.newSelectedImagePath == null
                                          ? FileImage(
                                              File(cubit
                                                  .previouslySelectedImagePath!),
                                            ) as ImageProvider
                                          : FileImage(File(
                                              cubit.newSelectedImagePath!)),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: cubit.pickImage,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: BlocBuilder<EditProfileCubit, EditProfileState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "Select Your City",
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
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
                        items: cubit.yemeniCities.map((city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(
                              city,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          cubit.selectCity(value);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        cubit.updateUserProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
