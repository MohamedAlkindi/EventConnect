import 'dart:ui';

import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/register/presentation/cubit/register_cubit.dart';
import 'package:event_connect/features/register/presentation/widget/text_fields.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:event_connect/core/utils/localization_extensions.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _repeatPassController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPassController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<RegisterCubit>();
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
          BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterLoading) {
                showLoadingDialog(context);
              }
              if (state is RegisterSuccessful) {
                hideLoadingDialog(context);
                Navigator.pushReplacementNamed(
                  context,
                  completeProfileInfoScreenRoute,
                );
              } else if (state is RegisterErrorState) {
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
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!.createAccount,
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!.joinCommunity,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black
                                        .withAlpha((0.7 * 255).round()),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              customTextField(
                                controller: _emailController,
                                labelText:
                                    AppLocalizations.of(context)!.emailAddress,
                                hintText:
                                    AppLocalizations.of(context)!.emailHint,
                                icon: Icons.email_outlined,
                              ),
                              const SizedBox(height: 28),
                              BlocBuilder<RegisterCubit, RegisterState>(
                                builder: (context, state) {
                                  bool isObsecure = true;
                                  if (state is PasswordVisible) {
                                    isObsecure =
                                        state.currentPasswordVisibility;
                                  }
                                  return customTextField(
                                    controller: _passwordController,
                                    labelText:
                                        AppLocalizations.of(context)!.password,
                                    hintText: AppLocalizations.of(context)!
                                        .createPassword,
                                    icon: isObsecure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    isObsecure: isObsecure,
                                    onTap: () =>
                                        cubit.togglePasswordVisibility(),
                                  );
                                },
                              ),
                              const SizedBox(height: 28),
                              BlocBuilder<RegisterCubit, RegisterState>(
                                builder: (context, state) {
                                  bool isObsecure = true;
                                  if (state is PasswordVisible) {
                                    isObsecure =
                                        state.currentRepeatPasswordVisibility;
                                  }
                                  return customTextField(
                                    controller: _repeatPassController,
                                    labelText: AppLocalizations.of(context)!
                                        .confirmPassword,
                                    hintText: AppLocalizations.of(context)!
                                        .repeatPassword,
                                    icon: isObsecure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    isObsecure: isObsecure,
                                    onTap: () =>
                                        cubit.toggleRepeatPasswordVisibility(),
                                  );
                                },
                              ),
                              const SizedBox(height: 40),
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
                                      cubit.registerUser(
                                        email: _emailController,
                                        password: _passwordController,
                                        repeatPassword: _repeatPassController,
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .createAccount,
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
                                  Text(
                                    AppLocalizations.of(context)!
                                        .alreadyHaveAccount,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
                                      overflow: TextOverflow.ellipsis,
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
