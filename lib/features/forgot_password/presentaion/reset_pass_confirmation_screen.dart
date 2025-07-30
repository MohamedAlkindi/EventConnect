import 'dart:ui';

import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/features/forgot_password/presentaion/widgets.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPasswordConfirmationPage extends StatelessWidget {
  const ResetPasswordConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Modern background with gradient and subtle overlay
          appBackgroundColors(),
          // Main frosted glass content
          backgroundContainer(
            childWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mark_email_read_rounded,
                  size: 150,
                  color: const Color(0xFF6C63FF),
                ),
                SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.resetPassEmail,
                  style: TextStyle(
                    color: const Color(0xFF6C63FF),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 55),
                Text(
                  AppLocalizations.of(context)!.resetMessage,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 55),
                buttonWidget(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      loginPageRoute,
                    );
                  },
                  buttonText: AppLocalizations.of(context)!.signIn,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
