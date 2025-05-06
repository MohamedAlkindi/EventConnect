import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/register/presentation/cubit/register_cubit.dart';
import 'package:event_connect/features/register/presentation/widget/text_fields.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _repeatPassController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPassController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
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
                        controller: _usernameController,
                        labelText: 'Enter Username',
                        hintText: 'At least 6 characters',
                        icon: Icons.person,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      customTextField(
                        controller: _emailController,
                        labelText: 'Enter Email',
                        hintText: 'example@ex.com',
                        icon: Icons.email,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      BlocBuilder<RegisterCubit, RegisterState>(
                        builder: (context, state) {
                          bool isObsecure = true; // Default value
                          if (state is PasswordVisible) {
                            isObsecure = state.currentPasswordVisibility;
                          }
                          return customTextField(
                            controller: _passwordController,
                            labelText: 'Enter Password',
                            hintText: 'At least 6 characters',
                            icon: isObsecure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            isObsecure: isObsecure,
                            onTap: () => cubit.togglePasswordVisibility(),
                          );
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      BlocBuilder<RegisterCubit, RegisterState>(
                        builder: (context, state) {
                          bool isObsecure = true; // Default value
                          if (state is PasswordVisible) {
                            isObsecure = state.currentRepeatPasswordVisibility;
                          }
                          return customTextField(
                            controller: _repeatPassController,
                            labelText: 'Repeat Password',
                            hintText: 'At least 6 characters',
                            icon: isObsecure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            isObsecure: isObsecure,
                            onTap: () => cubit.toggleRepeatPasswordVisibility(),
                          );
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    cubit.registerUser(
                      userName: _usernameController,
                      email: _emailController,
                      password: _passwordController,
                      repeatPassword: _repeatPassController,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Color.fromARGB(255, 0, 136, 186),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Made a mistake?",
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
                        "Head back to login",
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
        ),
      ),
    );
  }
}
