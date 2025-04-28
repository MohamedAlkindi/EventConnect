import 'dart:io';

import 'package:event_connect/core/tables/user_table.dart';
import 'package:event_connect/core/utils/message_dialog.dart';
import 'package:event_connect/features/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:event_connect/features/register/presentation/widget/text_fields.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  XFile? _imageFile;
  late TextEditingController _usernameController;
  String _selectedLocation = '';

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
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    context.read<EditProfileCubit>().getUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is GotUserProfile) {
            // Only set initial values if they haven't been set yet
            if (_usernameController.text.isEmpty) {
              _usernameController.text =
                  state.userProfile[UserTable.userNameColumnName];
            }
            if (_selectedLocation.isEmpty) {
              _selectedLocation =
                  state.userProfile[UserTable.userLocationColumnName];
            }
            _imageFile ??=
                state.userProfile[UserTable.userProfilePicColumnName];
          } else if (state is EditProfileSuccess) {
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
        builder: (BuildContext context, EditProfileState state) {
          if (state is GotUserProfile) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: _imageFile != null
                              ? FileImage(File(_imageFile!.path))
                                  as ImageProvider
                              : null,
                          child: _imageFile == null
                              ? const Icon(Icons.person, size: 80)
                              : null,
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
                  SizedBox(height: 35),
                  customTextField(
                    controller: _usernameController,
                    labelText: 'Enter Username',
                    hintText: 'At least 6 characters',
                    icon: Icons.person,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Your City",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    value:
                        _selectedLocation.isNotEmpty ? _selectedLocation : null,
                    items: _yemeniCities.map((city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLocation = value!;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<EditProfileCubit>().updateUserProfile(
                            name: _usernameController.text,
                            location: _selectedLocation,
                            profilePic: _imageFile!,
                          );
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
