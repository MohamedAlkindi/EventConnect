import 'dart:ui';

import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/app_background.dart';
import 'package:event_connect/core/widgets/authentication_widgets.dart';
import 'package:event_connect/features/login/presentation/cubit/login_cubit.dart';
import 'package:event_connect/features/register/presentation/widget/text_fields.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:event_connect/core/utils/localization_extensions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<LoginCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          appBackgroundColors(),
          BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginLoading) {
                showLoadingDialog(context);
              } else if (state is LoginSuccessful) {
                context.read<LoginCubit>().isEmailConfirmed();
              } else if (state is EmailConfirmed) {
                // if the user has confirmed his email, activate to check user's info.
                if (state.isConfirmed) {
                  context.read<LoginCubit>().isDataCompleted();
                } else {
                  hideLoadingDialog(context);
                  Navigator.pushReplacementNamed(
                    context,
                    emailConfirmationnRoute,
                  );
                }
              } else if (state is DataCompleted) {
                // if user info is completed.. show the homescreen.
                // otherwise show the complete data.
                if (state.isDataCompleted) {
                  context.read<LoginCubit>().showUserHomescreen();
                } else {
                  hideLoadingDialog(context);
                  Navigator.pushReplacementNamed(
                    context,
                    completeProfileInfoScreenRoute,
                  );
                }
              } else if (state is UserHomescreenState) {
                hideLoadingDialog(context);
                Navigator.pushReplacementNamed(
                  context,
                  state.userHomeScreenRoute,
                );
              } else if (state is LoginError) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  titleWidget(
                    titleText: AppLocalizations.of(context)!.welcomeBack,
                  ),
                  const SizedBox(height: 18),
                  subtitleWidget(
                    subtitleText:
                        AppLocalizations.of(context)!.signInToContinue,
                  ),
                  const SizedBox(height: 38),
                  customTextField(
                    controller: _emailController,
                    labelText: AppLocalizations.of(context)!.emailAddress,
                    hintText: AppLocalizations.of(context)!.emailHint,
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 28),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      bool isObsecure = true;
                      if (state is PasswordVisible) {
                        isObsecure = state.currentVisibility;
                      }
                      return customTextField(
                        controller: _passwordController,
                        labelText: AppLocalizations.of(context)!.password,
                        hintText: AppLocalizations.of(context)!.enterPassword,
                        icon: isObsecure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        isObsecure: isObsecure,
                        onTap: () => cubit.togglePasswordVisibility(isObsecure),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          forgotPasswordPageRoute,
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forgotPassword,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6C63FF),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 38),
                  authButton(
                    onTap: () {
                      cubit.firebaseLogin(
                        emailController: _emailController,
                        passwordController: _passwordController,
                      );
                    },
                    buttonText: AppLocalizations.of(context)!.signIn,
                  ),
                  const SizedBox(height: 32),
                  moreInfo(
                    text: AppLocalizations.of(context)!.dontHaveAccountYet,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        registerPageRoute,
                      );
                    },
                    textButtonText: AppLocalizations.of(context)!.signUp,
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
