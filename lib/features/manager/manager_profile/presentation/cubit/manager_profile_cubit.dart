import 'dart:io';

import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/manager/manager_edit_profile/presentation/manager_edit_profile_screen.dart';
import 'package:event_connect/features/manager/manager_profile/business_logic/manager_profile_bl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'manager_profile_state.dart';

class ManagerProfileCubit extends Cubit<ManagerProfileState> {
  ManagerProfileCubit() : super(ManagerProfileInitial());

  final _businessLogic = ManagerProfileBl();

  Future<void> getManagerPicAndLocation() async {
    try {
      final result = await _businessLogic.getManagerPicAndLocation();
      emit(GotManagerProfileInfo(userInfo: result));
    } catch (e) {
      emit(ManagerProfileError(message: e.toString()));
    }
  }

  ImageProvider<Object>? returnManagerPic({
    required String? cachedPicturePath,
    required String profilePicUrl,
  }) {
    if (cachedPicturePath != null && File(cachedPicturePath).existsSync()) {
      return FileImage(File(cachedPicturePath));
    } else if (cachedPicturePath == null ||
        File(cachedPicturePath).existsSync()) {
      return NetworkImage(profilePicUrl);
    }
    return const AssetImage('assets/images/generic_user.png');
  }

  Future<void> changeAccountSettings(
      {required BuildContext context, required UserModel userModel}) async {
    // final managerProfileCubit = context.read<ManagerProfileCubit>();
    // final managerHomescreenCubit = context.read<ManagerHomescreenCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManagerEditProfileScreen(
          userModel: userModel,
        ),
      ),
    );
    // if (result != null) {
    // managerProfileCubit.getManagerPicAndLocation();
    // managerHomescreenCubit.getManagerProfilePic();
    // }
  }

  void signOutDialog({required BuildContext context}) {
    showMessageDialog(
      context: context,
      icon: Icons.warning_rounded,
      iconColor: Colors.orangeAccent,
      titleText: AppLocalizations.of(context)!.signOutTitle,
      contentText: AppLocalizations.of(context)!.signOutContent,
      buttonText: AppLocalizations.of(context)!.yes,
      onPressed: () {
        userSignOut();
        Navigator.pop(context);
      },
      secondButtonText: AppLocalizations.of(context)!.no,
      secondOnPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Future<void> userSignOut() async {
    try {
      await _businessLogic.signOut();
      emit(ManagerSignedOutSuccessfully());
    } catch (e) {
      emit(ManagerProfileError(message: e.toString()));
    }
  }

  void deleteUserDialog({required BuildContext context}) {
    showMessageDialog(
      context: context,
      icon: Icons.warning_rounded,
      iconColor: Colors.red,
      titleText: AppLocalizations.of(context)!.deleteAccountTitle,
      contentText: AppLocalizations.of(context)!.deleteAccountContent,
      buttonText: AppLocalizations.of(context)!.delete,
      onPressed: () {
        deleteUser();
        Navigator.pop(context);
      },
      secondButtonText: AppLocalizations.of(context)!.cancel,
      secondOnPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Future<void> deleteUser() async {
    try {
      await _businessLogic.deleteUser();
      emit(ManagerDeletedSuccessfully());
    } catch (e) {
      emit(ManagerProfileError(message: e.toString()));
    }
  }
}
