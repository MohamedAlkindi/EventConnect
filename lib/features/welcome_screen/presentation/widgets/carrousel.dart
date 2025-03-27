import 'package:flutter/material.dart';

Widget carrousel({
  required BuildContext context,
  required double screenHeight,
  required double screenWidth,
  required String imageName,
  required String imageText,
}) {
  return Container(
    width: screenWidth,
    height: screenHeight,
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: screenHeight * 0.20,
        ),
        SizedBox(
          width: screenWidth * 0.9,
          height: screenHeight * 0.3,
          child: Image.asset(
            "assets/images/$imageName.png",
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: screenHeight * 0.08,
        ),
        Center(
          child: Text(
            imageText,
            style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
