import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/core/widgets/shared/homescreen_appbar_widget.dart';
import 'package:event_connect/features/manager/manager_events/presentation/show_manager_events_screen.dart';
import 'package:event_connect/features/manager/manager_homescreen/presentation/cubit/manager_homescreen_cubit.dart';
import 'package:event_connect/features/manager/manager_homescreen/presentation/widgets/manager_navbar_container.dart';
import 'package:event_connect/features/manager/manager_homescreen/presentation/widgets/manager_navbar_items.dart';
import 'package:event_connect/features/manager/manager_profile/presentation/manager_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_connect/l10n/app_localizations.dart';

class ManagerHomescreen extends StatelessWidget {
  const ManagerHomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<ManagerHomescreenCubit>()
        .getManagerProfilePic(editedImagePath: null);
    return ManagerHomescreenView();
  }
}

class ManagerHomescreenView extends StatelessWidget {
  const ManagerHomescreenView({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ManagerHomescreenCubit>();
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
                          ManagerProfileScreen(),
                        ],
                      );
                    },
                  ),
                ),
                // Modern bottom navigation
                managerNavBarContainer(
                  childWidget: BlocBuilder<ManagerHomescreenCubit,
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
                            bottomNavBarItem(
                              state: state,
                              icon: Icons.celebration,
                              itemLabel:
                                  AppLocalizations.of(context)!.manageEvents,
                              itemIndex: 0,
                              cubit: cubit,
                            ),
                            bottomNavBarItem(
                              state: state,
                              icon: null,
                              itemLabel: AppLocalizations.of(context)!.profile,
                              itemIndex: 1,
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
