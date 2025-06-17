import 'dart:ui';

import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/login/presentation/cubit/login_cubit.dart';
import 'package:event_connect/features/register/presentation/widget/text_fields.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
              } else if (state is LoginSuccessfulWithData) {
                hideLoadingDialog(context);
                Navigator.popAndPushNamed(
                  context,
                  userHomeScreenPageRoute,
                );
              } else if (state is LoginSuccessfulWithoutData) {
                hideLoadingDialog(context);
                Navigator.popAndPushNamed(
                  context,
                  completeProfileInfoScreenRoute,
                );
              } else if (state is LoginError) {
                hideLoadingDialog(context);
                showErrorDialog(
                  context: context,
                  message: state.message,
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
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                                width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
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
                                  'Welcome Back!',
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
                                  'Sign in to continue',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 38),
                              customTextField(
                                controller: _emailController,
                                labelText: 'Email Address',
                                hintText: 'example@ex.com',
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
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
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
                                    "Forgot password?",
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
                                          .withOpacity(0.3),
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
                                        "Sign In",
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
                                    "Don't have an account?",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey,
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
                                      "Sign Up",
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
