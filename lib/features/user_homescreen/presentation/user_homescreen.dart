import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/all_events/presentation/all_events_screen.dart';
import 'package:event_connect/features/my_events/presentation/my_events_screen.dart';
import 'package:event_connect/features/my_profile/presentation/my_profile_screen.dart';
import 'package:event_connect/features/user_homescreen/presentation/cubit/user_homescreen_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "EventsConnect",
          style: TextStyle(
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.pink.shade400,
                offset: const Offset(2, 2),
                blurRadius: 3,
              ),
              Shadow(
                color: Colors.purple.shade300,
                offset: const Offset(-2, -2),
                blurRadius: 3,
              ),
            ],
            fontSize: 24,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
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
      body: BlocListener<UserHomescreenCubit, UserHomescreenState>(
        listener: (context, state) {
          if (state is UserSignedOutSuccessfully) {
            Navigator.popAndPushNamed(context, loginPageRoute);
          }
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<UserHomescreenCubit, UserHomescreenState>(
                builder: (context, state) {
                  return PageView(
                    controller:
                        context.read<UserHomescreenCubit>().pageController,
                    onPageChanged: (index) => context
                        .read<UserHomescreenCubit>()
                        .onPageChanged(index),
                    children: const [
                      AllEventsScreen(),
                      MyEventsScreen(),
                      MyProfileScreen(),
                    ],
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: BlocBuilder<UserHomescreenCubit, UserHomescreenState>(
                builder: (context, state) {
                  return BottomNavigationBar(
                    currentIndex: state.currentIndex,
                    onTap: (index) => context
                        .read<UserHomescreenCubit>()
                        .onBottomNavTap(index),
                    items: [
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.event_note_rounded),
                        label: "All Events",
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.event),
                        label: "My Events",
                      ),
                      BottomNavigationBarItem(
                        icon: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey.shade300,
                          child: state.imageFile != null
                              ? CircleAvatar(
                                  radius: 15,
                                  backgroundImage: FileImage(state.imageFile!),
                                )
                              : const Icon(Icons.person, color: Colors.white),
                        ),
                        label: "My Profile",
                      ),
                    ],
                    selectedItemColor: Theme.of(context).primaryColor,
                    unselectedItemColor: Colors.grey,
                    showUnselectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
