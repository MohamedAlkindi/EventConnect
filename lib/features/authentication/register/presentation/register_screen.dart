import 'package:event_connect/core/routes/routes.dart';
import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/localization_extensions.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/core/widgets/shared/authentication_widgets.dart';
import 'package:event_connect/features/authentication/register/presentation/cubit/register_cubit.dart';
import 'package:event_connect/features/authentication/register/presentation/widget/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_connect/l10n/app_localizations.dart';

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
          appBackgroundColors(),
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
            child: backgroundContainer(
              childWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  titleWidget(
                    titleText: AppLocalizations.of(context)!.createAccount,
                  ),
                  const SizedBox(height: 12),
                  subtitleWidget(
                    subtitleText: AppLocalizations.of(context)!.joinCommunity,
                  ),
                  const SizedBox(height: 40),
                  customTextField(
                    controller: _emailController,
                    labelText: AppLocalizations.of(context)!.emailAddress,
                    hintText: AppLocalizations.of(context)!.emailHint,
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 28),
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      bool isObsecure = true;
                      if (state is PasswordVisible) {
                        isObsecure = state.currentPasswordVisibility;
                      }
                      return customTextField(
                        controller: _passwordController,
                        labelText: AppLocalizations.of(context)!.password,
                        hintText: AppLocalizations.of(context)!.createPassword,
                        icon: isObsecure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        isObsecure: isObsecure,
                        onTap: () {
                          cubit.togglePasswordVisibility();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      bool isObsecure = true;
                      if (state is PasswordVisible) {
                        isObsecure = state.currentRepeatPasswordVisibility;
                      }
                      return customTextField(
                        controller: _repeatPassController,
                        labelText:
                            AppLocalizations.of(context)!.confirmPassword,
                        hintText: AppLocalizations.of(context)!.repeatPassword,
                        icon: isObsecure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        isObsecure: isObsecure,
                        onTap: () {
                          cubit.toggleRepeatPasswordVisibility();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  authButton(
                    onTap: () {
                      cubit.registerUser(
                        email: _emailController,
                        password: _passwordController,
                        repeatPassword: _repeatPassController,
                      );
                    },
                    buttonText: AppLocalizations.of(context)!.createAccount,
                  ),
                  const SizedBox(height: 32),
                  moreInfo(
                    text: AppLocalizations.of(context)!.alreadyHaveAccount,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        loginPageRoute,
                      );
                    },
                    textButtonText: AppLocalizations.of(context)!.signIn,
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
