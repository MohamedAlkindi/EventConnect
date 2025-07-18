import 'dart:io';

import 'package:event_connect/features/manager/manager_events/presentation/show_manager_events_screen.dart';
import 'package:event_connect/features/manager/manager_homescreen/presentation/cubit/manager_homescreen_cubit.dart';
import 'package:event_connect/features/manager/manager_profile/presentation/manager_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManagerHomescreen extends StatelessWidget {
  const ManagerHomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerHomescreenView();
  }
}

class ManagerHomescreenView extends StatelessWidget {
  const ManagerHomescreenView({super.key});

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
                    AppLocalizations.of(context)!.eventConnect,
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
                  child: BlocBuilder<ManagerHomescreenCubit,
                      ManagerHomescreenState>(
                    builder: (context, state) {
                      return PageView(
                        controller: context
                            .read<ManagerHomescreenCubit>()
                            .pageController,
                        onPageChanged: (index) {
                          context
                              .read<ManagerHomescreenCubit>()
                              .onPageChanged(index);
                        },
                        children: const [
                          ShowManagerEventsScreen(),
                          // MyEventsScreen(),
                          ManagerProfileScreen(),
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
                  child: BlocBuilder<ManagerHomescreenCubit,
                      ManagerHomescreenState>(
                    builder: (context, state) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BottomNavigationBar(
                          currentIndex: state.currentIndex,
                          onTap: (index) {
                            context
                                .read<ManagerHomescreenCubit>()
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
                              label: AppLocalizations.of(context)!.manageEvents,
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
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.purple.shade100,
                                  child: state.imageFile != null
                                      ? CircleAvatar(
                                          radius: 12,
                                          backgroundImage: state.imageFile!
                                                  .startsWith("https:/")
                                              ? NetworkImage(state.imageFile!)
                                              : FileImage(
                                                  File(state.imageFile!),
                                                ),
                                        )
                                      : const Icon(Icons.person,
                                          color: Colors.white, size: 16),
                                ),
                              ),
                              label: AppLocalizations.of(context)!.profile,
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
