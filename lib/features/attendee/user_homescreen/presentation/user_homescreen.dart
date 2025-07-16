import 'package:event_connect/core/widgets/app_background.dart';
import 'package:event_connect/features/attendee/all_events/presentation/all_events_screen.dart';
import 'package:event_connect/features/attendee/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/cubit/my_events_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/my_events_screen.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/my_profile_screen.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/cubit/user_homescreen_cubit.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/widgets/bottom_nav_bar_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // these will reset and refetch the data when the user signs out and in with another account.
    context.read<AllEventsCubit>().getAllEvents(forceRefresh: true);
    context.read<MyEventsCubit>().getAllEventsByUserID(forceRefresh: true);
    context.read<MyProfileCubit>().getUserPic();
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
          appBackgroundColors(),
          SafeArea(
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                      final cubit = context.read<UserHomescreenCubit>();
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
                            bottomNavBarItem(
                              state: state,
                              icon: Icons.celebration,
                              itemLabel:
                                  AppLocalizations.of(context)!.allEvents,
                              itemIndex: 0,
                              cubit: null,
                            ),
                            bottomNavBarItem(
                              state: state,
                              icon: Icons.event_available_rounded,
                              itemLabel: AppLocalizations.of(context)!.myEvents,
                              itemIndex: 1,
                              cubit: null,
                            ),
                            bottomNavBarItem(
                              state: state,
                              icon: null,
                              itemLabel: AppLocalizations.of(context)!.profile,
                              itemIndex: 2,
                              cubit: cubit,
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
