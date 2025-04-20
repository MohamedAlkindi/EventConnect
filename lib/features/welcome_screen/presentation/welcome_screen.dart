import 'dart:async';

import 'package:event_connect/features/welcome_screen/presentation/widgets/carrousel.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

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
          padding: EdgeInsets.all(3),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;
                return SizedBox(
                  child: Stack(
                    children: [
                      PageView(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
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
                      ),
                      Positioned(
                        bottom: 180,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: _currentPage == index ? 12 : 8,
                              height: _currentPage == index ? 12 : 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? Color.fromARGB(255, 0, 136, 186)
                                    : Colors.grey.shade400,
                              ),
                            );
                          }),
                        ),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 0, 136, 186),
                                ),
                                child: Text(
                                  "Get Started",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
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
                                    child: Text(
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
