import 'dart:io';

import 'package:event_connect/features/attendee/all_events/presentation/all_events_screen.dart';
import 'package:event_connect/features/attendee/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/cubit/my_events_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/my_events_screen.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/my_profile_screen.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/cubit/user_homescreen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // these will reset and refetch the data when the user signs out and in with another account.
    context.read<AllEventsCubit>().getAllEvents(forceRefresh: true);
    context.read<MyEventsCubit>().getAllEventsByUserID(forceRefresh: true);
    context.read<MyProfileCubit>().getUserPicAndName();
    context.read<UserHomescreenCubit>().getUserProfilePic();
    return UserHomeScreenView();
  }
}

class UserHomeScreenView extends StatelessWidget {
  const UserHomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background to match All Events screen
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
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 48), // For balance
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFF6C63FF),
                        Color(0xFFFF6584),
                        Color(0xFFFFB74D)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Text(
                    "EventConnect 🎉",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha((0.18 * 255).round()),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<UserHomescreenCubit, UserHomescreenState>(
                    builder: (context, state) {
                      return PageView(
                        controller:
                            context.read<UserHomescreenCubit>().pageController,
                        onPageChanged: (index) {
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
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.1 * 255).round()),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: BlocBuilder<UserHomescreenCubit, UserHomescreenState>(
                    builder: (context, state) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BottomNavigationBar(
                          currentIndex: state.currentIndex,
                          onTap: (index) {
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
                                          .withAlpha((0.1 * 255).round())
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
                                          .withAlpha((0.1 * 255).round())
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
                                          .withAlpha((0.1 * 255).round())
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.purple.shade100,
                                  child: state.imageFile != null
                                      ? CircleAvatar(
                                          radius: 12,
                                          backgroundImage: state.imageFile!
                                                  .startsWith("https:/")
                                              ? NetworkImage(
                                                  "${state.imageFile!}?updated=${DateTime.now().millisecondsSinceEpoch}")
                                              : FileImage(
                                                  File(state.imageFile!),
                                                ),
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
        ],
      ),
    );
  }
}
