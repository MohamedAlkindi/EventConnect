import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';

class ManagerHomescreen extends StatelessWidget {
  const ManagerHomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Delete later.. testing purposes only!
    final user = FirebaseUser();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              user.signOut();
              Navigator.pushReplacementNamed(context, loginPageRoute);
            },
            icon: Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Text("Hola Manager!"),
        ),
      ),
    );
  }
}
