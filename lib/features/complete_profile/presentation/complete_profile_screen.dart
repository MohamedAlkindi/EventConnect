import 'dart:io';

import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialog.dart';
import 'package:event_connect/features/complete_profile/presentation/cubit/complete_profile_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  //default selected city.
  String _selectedCity = "Al Mukalla";
  String defaultImagePath = "assets/images/generic_user.png";
  final List<String> _yemeniCities = [
    'Hadramout',
    "San'aa",
    'Aden',
    'Taiz',
    'Ibb',
    'Al Hudaydah',
    'Marib',
    'Al Mukalla'
  ];

  // default generic image.
  XFile _imageFile = XFile('assets/images/generic_user.png');

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<CompleteProfileCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complete Profile",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
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
            showMessageDialog(
              context: context,
              titleText: 'Ouch! 😓',
              contentText: state.message,
              icon: Icons.error_outline_rounded,
              iconColor: Colors.red,
              buttonText: 'Try Again',
              onPressed: () {
                Navigator.pop(context);
              },
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
                    CircleAvatar(
                      radius: 80,
                      // Use default image first, otheriwse use the selected one...
                      backgroundImage: _imageFile.path == defaultImagePath
                          ? AssetImage(_imageFile.path)
                          : FileImage(File(_imageFile.path)) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
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
              // SizedBox(height: 35),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Select Your City",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                value: _selectedCity,
                items: _yemeniCities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value!;
                  });
                },
              ),
              // SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  try {
                    cubit.completeProfile(
                      image: _imageFile.path == defaultImagePath
                          ? null
                          : _imageFile,
                      city: _selectedCity,
                    );
                  } catch (e) {
                    // Handle errors
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Color.fromARGB(255, 0, 136, 186),
                ),
                child: Text(
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
