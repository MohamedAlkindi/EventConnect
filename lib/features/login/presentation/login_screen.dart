import 'dart:ui';

import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
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
                      context, emailConfirmationnRoute);
                }
              } else if (state is DataCompleted) {
                // if user info is completed.. show the homescreen.
                // otherwise show the complete data.
                if (state.isDataCompleted) {
                  context.read<LoginCubit>().showUserHomescreen();
                } else {
                  hideLoadingDialog(context);
                  Navigator.pushReplacementNamed(
                      context, completeProfileInfoScreenRoute);
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
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 32.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha((0.18 * 255).round()),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                                color:
                                    Colors.black.withAlpha((0.2 * 255).round()),
                                width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.white.withAlpha((0.3 * 255).round()),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!.welcomeBack,
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .signInToContinue,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black
                                        .withAlpha((0.7 * 255).round()),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 38),
                              customTextField(
                                controller: _emailController,
                                labelText:
                                    AppLocalizations.of(context)!.emailAddress,
                                hintText:
                                    AppLocalizations.of(context)!.emailHint,
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
                                    labelText:
                                        AppLocalizations.of(context)!.password,
                                    hintText: AppLocalizations.of(context)!
                                        .enterPassword,
                                    icon: isObsecure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    isObsecure: isObsecure,
                                    onTap: () => cubit
                                        .togglePasswordVisibility(isObsecure),
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
                                    AppLocalizations.of(context)!
                                        .forgotPassword,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF6C63FF),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 38),
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF6C63FF),
                                      Color(0xFFFF6584)
                                    ],
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
                                      cubit.firebaseLogin(
                                        emailController: _emailController,
                                        passwordController: _passwordController,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.signIn,
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
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .dontHaveAccountYet,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        registerPageRoute,
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.signUp,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF6C63FF),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
