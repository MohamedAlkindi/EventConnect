import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/all_events/presentation/all_events_screen.dart';
import 'package:event_connect/features/my_events/presentation/my_events_screen.dart';
import 'package:event_connect/features/my_profile/presentation/my_profile_screen.dart';
import 'package:event_connect/features/user_homescreen/presentation/cubit/user_homescreen_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserHomescreenCubit(),
      child: const UserHomeScreenView(),
    );
  }
}

class UserHomeScreenView extends StatelessWidget {
  const UserHomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    return Scaffold(
      body: Stack(
        children: [
          // Modern gradient header
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48), // For balance
                  Text(
                    "EventsConnect 🎉",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: Colors.white),
                    onPressed: () {
                      showMessageDialog(
                        context: context,
                        icon: Icons.warning_amber_rounded,
                        titleText: "Logout 😰",
                        contentText: "Are you sure you want to logout?",
                        iconColor: const Color.fromARGB(255, 207, 169, 18),
                        buttonText: "Yes",
                        onPressed: () {
                          context.read<UserHomescreenCubit>().userSignOut();
                        },
                        secondButtonText: "No",
                        secondOnPressed: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: BlocListener<UserHomescreenCubit, UserHomescreenState>(
              listener: (context, state) {
                if (state is UserSignedOutSuccessfully) {
                  Navigator.popAndPushNamed(context, loginPageRoute);
                }
              },
              child: Column(
                children: [
                  Expanded(
                    child:
                        BlocBuilder<UserHomescreenCubit, UserHomescreenState>(
                      builder: (context, state) {
                        return PageView(
                          controller: context
                              .read<UserHomescreenCubit>()
                              .pageController,
                          onPageChanged: (index) {
                            confettiController.play();
                            context
                                .read<UserHomescreenCubit>()
                                .onPageChanged(index);
                          },
                          children: const [
                            AllEventsScreen(),
                            MyEventsScreen(),
                            MyProfileScreen(),
                          ],
                        );
                      },
                    ),
                  ),
                  // Modern bottom navigation
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child:
                        BlocBuilder<UserHomescreenCubit, UserHomescreenState>(
                      builder: (context, state) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BottomNavigationBar(
                            currentIndex: state.currentIndex,
                            onTap: (index) {
                              confettiController.play();
                              context
                                  .read<UserHomescreenCubit>()
                                  .onBottomNavTap(index);
                            },
                            items: [
                              BottomNavigationBarItem(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: state.currentIndex == 0
                                        ? const Color(0xFF6C63FF)
                                            .withOpacity(0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.celebration),
                                ),
                                label: "All Events",
                              ),
                              BottomNavigationBarItem(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: state.currentIndex == 1
                                        ? const Color(0xFF6C63FF)
                                            .withOpacity(0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child:
                                      const Icon(Icons.event_available_rounded),
                                ),
                                label: "My Events",
                              ),
                              BottomNavigationBarItem(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: state.currentIndex == 2
                                        ? const Color(0xFF6C63FF)
                                            .withOpacity(0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.purple.shade100,
                                    child: state.imageFile != null
                                        ? CircleAvatar(
                                            radius: 12,
                                            backgroundImage:
                                                FileImage(state.imageFile!),
                                          )
                                        : const Icon(Icons.person,
                                            color: Colors.white, size: 16),
                                  ),
                                ),
                                label: "Profile",
                              ),
                            ],
                            selectedItemColor: const Color(0xFF6C63FF),
                            unselectedItemColor: Colors.grey,
                            showUnselectedLabels: true,
                            type: BottomNavigationBarType.fixed,
                            backgroundColor: Colors.white,
                            elevation: 0,
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
              numberOfParticles: 15,
              maxBlastForce: 15,
              minBlastForce: 5,
            ),
          ),
        ],
      ),
    );
  }
}
