import 'dart:io';

import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/manager/manager_edit_profile/presentation/manager_edit_profile_screen.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/manager_events_cubit.dart';
import 'package:event_connect/features/manager/manager_homescreen/presentation/cubit/manager_homescreen_cubit.dart';
import 'package:event_connect/features/manager/manager_profile/business_logic/manager_profile_bl.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/shared/image_caching_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'manager_profile_state.dart';

class ManagerProfileCubit extends Cubit<ManagerProfileState> {
  ManagerProfileCubit() : super(ManagerProfileInitial());

  final _businessLogic = ManagerProfileBl();
  final _imageCaching = ImageCachingSetup();

  Future<void> getManagerInfo({required UserModel? updatedManagerModel}) async {
    try {
      if (updatedManagerModel != null) {
        emit(GotManagerProfileInfo(userInfo: updatedManagerModel));
      } else {
        // final result = await _businessLogic.getManagerPicAndLocation();
        emit(GotManagerProfileInfo(userInfo: globalUserModel!));
      }
    } catch (e) {
      emit(ManagerProfileError(message: e.toString()));
    }
  }

  ImageProvider<Object>? returnManagerPic(
      {required GotManagerProfileInfo state}) {
    if (state.userInfo.cachedPicturePath != null &&
        File(
          state.userInfo.cachedPicturePath!,
        ).existsSync()) {
      return FileImage(File(state.userInfo.cachedPicturePath!));
    } else if (state.userInfo.profilePicUrl.isNotEmpty &&
        state.userInfo.profilePicUrl.startsWith("http")) {
      return NetworkImage(
        "${state.userInfo.profilePicUrl}${state.userInfo.profilePicUrl.contains('?') ? '&' : '?'}updated=${DateTime.now().millisecondsSinceEpoch}",
      );
    }
    return AssetImage('assets/images/generic_user.png');
  }

  Future<void> changeAccountSettings({
    required BuildContext context,
    required UserModel userModel,
  }) async {
    final managerProfileCubit = context.read<ManagerProfileCubit>();
    final managerHomescreenCubit = context.read<ManagerHomescreenCubit>();
    final UserModel? managerModel = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManagerEditProfileScreen(
          userModel: userModel,
        ),
      ),
    );
    if (managerModel != null) {
      managerProfileCubit.getManagerInfo(updatedManagerModel: managerModel);
      managerHomescreenCubit.getManagerProfilePic(
        editedImagePath: managerModel.cachedPicturePath,
      );
    }
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
      print('ManagerProfileCubit: Starting delete user process...');
      emit(ManagerProfileLoading());
      await _businessLogic.deleteUser();
      print(
          'ManagerProfileCubit: Delete user successful, emitting ManagerDeletedSuccessfully');
      emit(ManagerDeletedSuccessfully());
    } catch (e) {
      print('ManagerProfileCubit: Delete user failed with error: $e');
      emit(ManagerProfileError(message: e.toString()));
    }
  }

  // method to reset cubit and all cached data after logging out or deleting account.
  Future<void> resetAllCubits({required BuildContext context}) async {
    // Clear cached data and reset global variables
    await _imageCaching.clearAllCachedData();

    // Reset all cubits
    context.read<ManagerEventsCubit>().reset();
    context.read<ManagerHomescreenCubit>().reset();
    emit(ManagerProfileInitial());
  }
}
