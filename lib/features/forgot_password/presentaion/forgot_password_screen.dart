import 'dart:ui';

import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/features/forgot_password/presentaion/cubit/reset_password_cubit.dart';
import 'package:event_connect/features/forgot_password/presentaion/widgets.dart';
import 'package:event_connect/features/register/presentation/widget/text_fields.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:event_connect/core/utils/localization_extensions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ResetPasswordCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          appBackgroundColors(),
          BlocListener<ResetPasswordCubit, ResetPasswordState>(
            listener: (context, state) {
              if (state is ResetPasswordLoading) {
                showLoadingDialog(context);
              } else if (state is ResetPasswordEmailSend) {
                hideLoadingDialog(context);
                Navigator.pushReplacementNamed(
                  context,
                  resetPasswordConfirmationPageRoute,
                );
              } else if (state is ResetPasswordError) {
                hideLoadingDialog(context);
                final l10n = AppLocalizations.of(context)!;
                final errorMsg = l10n.tryTranslate(state.message);
                showErrorDialog(
                  context: context,
                  message: errorMsg,
                );
              }
            },
            child: backgroundContainer(
              childWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.resetPassword,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.helpRecoverPassword,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black.withAlpha((0.7 * 255).round()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  customTextField(
                    controller: _emailController,
                    labelText: AppLocalizations.of(context)!.emailAddress,
                    hintText: AppLocalizations.of(context)!.emailHint,
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 40),
                  buttonWidget(
                    onTap: () {
                      cubit.resetPassword(
                        emailController: _emailController,
                      );
                    },
                    buttonText: AppLocalizations.of(context)!.sendResetLink,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.rememberPassword,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            loginPageRoute,
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.signIn,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6C63FF),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
