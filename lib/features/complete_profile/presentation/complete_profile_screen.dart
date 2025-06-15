import 'dart:io';

import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/complete_profile/presentation/cubit/complete_profile_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<CompleteProfileCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Complete Profile",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<CompleteProfileCubit, CompleteProfileState>(
        listener: (context, state) {
          if (state is CompleteProfileLoading) {
            showLoadingDialog(context);
          } else if (state is CompleteProfileSuccessul) {
            hideLoadingDialog(context);
            showMessageDialog(
              context: context,
              titleText: 'Success! 🥳',
              contentText: "You have successfully completed your profile!",
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Stack(
                  children: [
                    BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
                      builder: (context, state) {
                        return CircleAvatar(
                            radius: 80,
                            backgroundImage: cubit.selectedImagePath != null
                                ? FileImage(File(cubit.selectedImagePath!))
                                    as ImageProvider
                                : AssetImage(cubit.defaultImagePath)
                                    as ImageProvider);
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: cubit.pickImage,
                        child: CircleAvatar(
                          radius: 18,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
                builder: (context, state) {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Your City",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    value: cubit.defaultCity,
                    items: cubit.yemeniCities.map((city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
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
              ElevatedButton(
                onPressed: () {
                  cubit.completeProfile();
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: const Color.fromARGB(255, 0, 136, 186),
                ),
                child: const Text(
                  "Finalize",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
