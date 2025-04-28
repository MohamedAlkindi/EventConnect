import 'package:event_connect/core/tables/user_table.dart';
import 'package:event_connect/core/utils/message_dialog.dart';
import 'package:event_connect/features/edit_profile/presentation/edit_profile_screen.dart';
import 'package:event_connect/features/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyProfileCubit>().getUserPicAndName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyProfileCubit, MyProfileState>(
        builder: (context, state) {
          if (state is GotMyProfileInfo) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Picture Circle
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.purple.shade300,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.shade200.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: MemoryImage(
                        state.userInfo[UserTable.userProfilePicColumnName],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // User Name
                  Text(
                    "${state.userInfo[UserTable.userNameColumnName]}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Edit Account Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple.shade300, Colors.pink.shade400],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.shade200.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Edit Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Delete Account Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.shade400,
                          Colors.redAccent.shade700
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.shade200.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return dialog(
                              icon: Icons.warning_rounded,
                              iconColor: Colors.red,
                              titleText: 'Delete Account 😐',
                              contentText:
                                  'Are you sure you want to delete your account?',
                              buttonText: 'Delete',
                              onPressed: () {
                                context.read<MyProfileCubit>().deleteUser();
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
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
