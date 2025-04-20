import 'package:flutter/material.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PesonaState();
}

// TODO: Use this screen after signing up for the first time, if the user hasn't added a picture and location, show this screen otherwise shpw the events screen ... think of a better design for this page!
class _PesonaState extends State<PersonalInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.jpg',
              height: 300,
            ),
            Padding(
              padding: EdgeInsets.all(9),
              child: Column(
                children: [],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.popAndPushNamed(
                //   context,
                //   registerPageRoute,
                // );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Color.fromARGB(255, 0, 136, 186),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
