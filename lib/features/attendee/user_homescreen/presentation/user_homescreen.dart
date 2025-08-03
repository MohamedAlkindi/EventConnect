import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/core/widgets/shared/homescreen_appbar_widget.dart';
import 'package:event_connect/features/attendee/all_events/presentation/all_events_screen.dart';
import 'package:event_connect/features/attendee/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/cubit/my_events_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/my_events_screen.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/my_profile_screen.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/cubit/user_homescreen_cubit.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/widgets/attendee_navbar_container.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/widgets/button_nav_bar_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          homescreenAppBar(context: context),
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
                attendeeNavBarContainer(
                  childWidget:
                      BlocBuilder<UserHomescreenCubit, UserHomescreenState>(
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
