import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/register/presentation/cubit/register_cubit.dart';
import 'package:event_connect/features/register/presentation/widget/text_fields.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            showLoadingDialog(context);
          }
          if (state is RegisterSuccessful) {
            hideLoadingDialog(context);
            Navigator.popAndPushNamed(
              context,
              completeProfileInfoScreenRoute,
            );
          } else if (state is RegisterErrorState) {
            hideLoadingDialog(context);
            showErrorDialog(
              context: context,
              message: state.message,
            );
          }
        },
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF6C63FF),
                          Color(0xFFFF6584),
                          Color(0xFFFFB74D)
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(48),
                        bottomRight: Radius.circular(48),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            'Create Account',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Join our community today',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sign Up",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6C63FF),
                              ),
                            ),
                            const SizedBox(height: 24),
                            customTextField(
                              controller: _emailController,
                              labelText: 'Email Address',
                              hintText: 'example@ex.com',
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<RegisterCubit, RegisterState>(
                              builder: (context, state) {
                                bool isObsecure = true;
                                if (state is PasswordVisible) {
                                  isObsecure = state.currentPasswordVisibility;
                                }
                                return customTextField(
                                  controller: _passwordController,
                                  labelText: 'Password',
                                  hintText: 'Create a password',
                                  icon: isObsecure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  isObsecure: isObsecure,
                                  onTap: () => cubit.togglePasswordVisibility(),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<RegisterCubit, RegisterState>(
                              builder: (context, state) {
                                bool isObsecure = true;
                                if (state is PasswordVisible) {
                                  isObsecure =
                                      state.currentRepeatPasswordVisibility;
                                }
                                return customTextField(
                                  controller: _repeatPassController,
                                  labelText: 'Confirm Password',
                                  hintText: 'Repeat your password',
                                  icon: isObsecure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  isObsecure: isObsecure,
                                  onTap: () =>
                                      cubit.toggleRepeatPasswordVisibility(),
                                );
                              },
                            ),
                            const SizedBox(height: 32),
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
                                    cubit.registerUser(
                                      email: _emailController,
                                      password: _passwordController,
                                      repeatPassword: _repeatPassController,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Center(
                                    child: Text(
                                      "Create Account",
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
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
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
                                    "Sign In",
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
