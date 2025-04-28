import 'package:event_connect/core/utils/message_dialog.dart';
import 'package:event_connect/features/all_events/presentation/all_events_screen.dart';
import 'package:event_connect/features/my_events/presentation/my_events_screen.dart';
import 'package:event_connect/features/my_profile/presentation/my_profile_screen.dart';
import 'package:event_connect/features/user_homescreen/presentation/cubit/user_homescreen_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This page has only the signout button and the user's image.
class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<UserHomescreenCubit>().getUserProfilePic();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<UserHomescreenCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "EventsConnect",
          style: TextStyle(
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.pink.shade400,
                offset: Offset(2, 2),
                blurRadius: 3,
              ),
              Shadow(
                color: Colors.purple.shade300,
                offset: Offset(-2, -2),
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
            icon: Icon(Icons.logout_rounded),
            onPressed: () {
              showMessageDialog(
                context: context,
                icon: Icons.warning_amber_rounded,
                titleText: "Logout 😰",
                contentText: "Are you sure you want to logout?",
                iconColor: const Color.fromARGB(255, 207, 169, 18),
                buttonText: "Yes",
                onPressed: () {
                  cubit.userSignOut();
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
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  AllEventsScreen(),
                  MyEventsScreen(),
                  MyProfileScreen(),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: BlocBuilder<UserHomescreenCubit, UserHomescreenState>(
                builder: (context, state) {
                  return BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      _pageController.animateToPage(
                        index,
                        duration: Duration(microseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.event_note_rounded),
                        label: "All Events",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.event),
                        label: "My Events",
                      ),
                      BottomNavigationBarItem(
                        icon: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey.shade300,
                          child: state is GotUserProfilePic
                              ? CircleAvatar(
                                  radius: 15,
                                  backgroundImage: FileImage(
                                    state.imageFile,
                                  ),
                                )
                              : Icon(Icons.person, color: Colors.white),
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
