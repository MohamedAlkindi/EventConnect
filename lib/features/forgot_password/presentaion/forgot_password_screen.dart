import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialog.dart';
import 'package:event_connect/features/forgot_password/presentaion/cubit/reset_password_cubit.dart';
import 'package:event_connect/features/register/presentation/widget/text_fields.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordLoading) {
            showLoadingDialog(context);
          } else if (state is ResetPasswordEmailSend) {
            hideLoadingDialog(context);
            Navigator.popAndPushNamed(
              context,
              resetPasswordConfirmationPageRoute,
            );
          } else if (state is ResetPasswordError) {
            hideLoadingDialog(context);
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return dialog(
                  icon: Icons.error_outline_rounded,
                  iconColor: Colors.red,
                  titleText: 'Ouch! 😓',
                  contentText: state.message,
                  buttonText: 'Try Again',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.jpg',
                  height: 300,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  child: Column(
                    children: [
                      customTextField(
                        controller: _emailController,
                        labelText: 'Enter Email',
                        hintText: 'example@ex.com',
                        icon: Icons.email,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          cubit.resetPassword(
                            emailController: _emailController,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Color.fromARGB(255, 0, 136, 186),
                        ),
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Wanna try again?",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(
                                context,
                                loginPageRoute,
                              );
                            },
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 136, 186),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
