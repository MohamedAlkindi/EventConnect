import 'package:event_connect/features/welcome_screen/presentation/cubit/welcome_screen_cubit.dart';
import 'package:event_connect/features/welcome_screen/presentation/widgets/carrousel.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WelcomeScreenCubit(),
      child: const WelcomeScreenView(),
    );
  }
}

class WelcomeScreenView extends StatelessWidget {
  const WelcomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink.shade300,
              Colors.orange.shade300,
              Colors.yellow.shade300,
              Colors.green.shade300,
              Colors.cyan.shade300,
              Colors.blue.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;
                return SizedBox(
                  child: Stack(
                    children: [
                      BlocBuilder<WelcomeScreenCubit, WelcomeScreenState>(
                        builder: (context, state) {
                          return PageView(
                            controller: context
                                .read<WelcomeScreenCubit>()
                                .pageController,
                            onPageChanged: (page) => context
                                .read<WelcomeScreenCubit>()
                                .onPageChanged(page),
                            children: [
                              carrousel(
                                context: context,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                imageName: 'welcome',
                                imageText:
                                    "Welcome to EventConnect - Your Ultimate Event Companion!",
                              ),
                              carrousel(
                                context: context,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                imageName: 'calendar',
                                imageText:
                                    "Discover Events Near You - Never Miss Out!",
                              ),
                              carrousel(
                                context: context,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                imageName: 'post',
                                imageText:
                                    "Get all the Details - Plan Your Perfect Day!",
                              ),
                              carrousel(
                                context: context,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                imageName: 'join',
                                imageText: "Join Our Community Now!",
                              ),
                            ],
                          );
                        },
                      ),
                      BlocBuilder<WelcomeScreenCubit, WelcomeScreenState>(
                        builder: (context, state) {
                          return Positioned(
                            bottom: 180,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  width: state.currentPage == index ? 12 : 8,
                                  height: state.currentPage == index ? 12 : 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: state.currentPage == index
                                        ? const Color.fromARGB(255, 0, 136, 186)
                                        : Colors.grey.shade400,
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 30,
                        left: 20,
                        right: 20,
                        child: Center(
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.popAndPushNamed(
                                    context,
                                    registerPageRoute,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 136, 186),
                                ),
                                child: const Text(
                                  "Get Started",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already a user?",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.popAndPushNamed(
                                        context,
                                        loginPageRoute,
                                      );
                                    },
                                    child: const Text(
                                      "Sign in here",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 4, 151, 205),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
