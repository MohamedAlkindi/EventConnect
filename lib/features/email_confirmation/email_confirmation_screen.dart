import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/email_confirmation/cubit/email_confirmation_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailConfirmationScreen extends StatefulWidget {
  const EmailConfirmationScreen({super.key});

  @override
  State<EmailConfirmationScreen> createState() => _EmailConfirmationScreen();
}

class _EmailConfirmationScreen extends State<EmailConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<EmailConfirmationCubit>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Gradient background (glossy effect)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFe0e7ff),
                  Color(0xFFfceabb),
                  Color(0xFFf8b6b8)
                ],
              ),
            ),
          ),
          BlocListener<EmailConfirmationCubit, EmailConfirmationState>(
            listener: (context, state) {
              if (state is LoadingState) {
                showLoadingDialog(context);
              } else if (state is EmailSentState) {
                hideLoadingDialog(context);
                showMessageDialog(
                  context: context,
                  titleText: AppLocalizations.of(context)!.success,
                  contentText:
                      AppLocalizations.of(context)!.confirmationEmailResent,
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: Colors.green,
                  buttonText: AppLocalizations.of(context)!.okay,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              } else if (state is EmailConfirmed) {
                hideLoadingDialog(context);
                // if the user has confirmed his email, activate to check user's info.
                state.isConfirmed
                    ? cubit.isDataCompleted()
                    : showErrorDialog(
                        context: context,
                        message:
                            AppLocalizations.of(context)!.emailNotConfirmed,
                      );
              } else if (state is DataCompleted) {
                // if user info is completed.. show the homescreen.
                // otherwise show the complete data.
                state.isDataCompleted
                    ? cubit.showUserHomescreen
                    : Navigator.pushReplacementNamed(
                        context, completeProfileInfoScreenRoute);
              } else if (state is UserHomescreenState) {
                Navigator.pushReplacementNamed(
                  context,
                  state.userHomeScreenPageRoute,
                );
              } else if (state is ErrorState) {
                hideLoadingDialog(context);
                showErrorDialog(
                    context: context, message: "Error: ${state.message}");
              }
            },
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((0.18 * 255).round()),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                          color: Colors.black.withAlpha((0.2 * 255).round()),
                          width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withAlpha((0.3 * 255).round()),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mark_email_read_rounded,
                          size: 120,
                          color: const Color(0xFF6C63FF),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.checkYourEmail,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF6C63FF),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Responsive, never-overflowing texts
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.emailSentMessage,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.justify,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6C63FF)
                                      .withAlpha((0.3 * 255).round()),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  cubit.isEmailConfirmed();
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .headToHomeScreen,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.resendEmail,
                              style: GoogleFonts.poppins(
                                  color: Colors.black, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Flexible(
                              child: TextButton(
                                onPressed: () {
                                  cubit.sendEmailConfirmation();
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.resend,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                AppLocalizations.of(context)!.wrongEmail,
                                style: GoogleFonts.poppins(
                                    color: Colors.black, fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    registerPageRoute,
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.register,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
