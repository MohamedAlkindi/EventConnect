import 'dart:io';

import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/attendee/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:event_connect/features/attendee/edit_profile/presentation/edit_profile_screen.dart';
import 'package:event_connect/features/attendee/my_events/presentation/cubit/my_events_cubit.dart';
import 'package:event_connect/features/attendee/my_profile/business_logic/my_profile_bl.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/cubit/user_homescreen_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/shared/image_caching_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit() : super(MyProfileInitial());
  final MyProfileBL _businessLogic = MyProfileBL();
  final _imageCaching = ImageCachingSetup();

  Future<void> getUserInfo({required UserModel? editedUserModel}) async {
    try {
      // that editUserModel will be given from the edit profile when the user makes any changes.
      // If that is null then the user just launched the app, otherwise the user has changed some things.
      if (editedUserModel != null) {
        emit(GotMyProfileInfo(userModel: editedUserModel));
      } else {
        emit(GotMyProfileInfo(userModel: globalUserModel!));
      }
    } catch (e) {
      emit(MyProfileError(message: e.toString()));
    }
  }

  Future<void> changeAccountSettings({
    required BuildContext context,
    required UserModel userModel,
  }) async {
    final myProfileCubit = context.read<MyProfileCubit>();
    final userHomescreenCubit = context.read<UserHomescreenCubit>();
    final UserModel? editedUserModel = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          userModel: userModel,
        ),
      ),
    );
    if (editedUserModel != null) {
      myProfileCubit.getUserInfo(editedUserModel: editedUserModel);
      userHomescreenCubit.getUserProfilePic(
          editedImagePath: editedUserModel.cachedPicturePath);
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
      emit(UserSignedOutSuccessfully());
    } catch (e) {
      emit(MyProfileError(message: e.toString()));
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
      print('MyProfileCubit: Starting delete user process...');
      emit(MyProfileLoading());
      await _businessLogic.deleteUser();
      print(
          'MyProfileCubit: Delete user successful, emitting UserDeletedSuccessfully');
      emit(UserDeletedSuccessfully());
    } catch (e) {
      print('MyProfileCubit: Delete user failed with error: $e');
      emit(MyProfileError(message: e.toString()));
    }
  }

  ImageProvider getPicturePath(GotMyProfileInfo state) {
    if (state.userModel.cachedPicturePath != null &&
        File(
          state.userModel.cachedPicturePath!,
        ).existsSync()) {
      return FileImage(File(state.userModel.cachedPicturePath!));
    } else if (state.userModel.profilePicUrl.isNotEmpty &&
        state.userModel.profilePicUrl.startsWith("http")) {
      return NetworkImage(
        "${state.userModel.profilePicUrl}${state.userModel.profilePicUrl.contains('?') ? '&' : '?'}updated=${DateTime.now().millisecondsSinceEpoch}",
      );
    }
    return AssetImage('assets/images/generic_user.png');
  }

  // method to reset cubit and all cached data after logging out or deleting account.
  Future<void> resetAllCubits({required BuildContext context}) async {
    // Capture cubits before async gap
    final allEventsCubit = context.read<AllEventsCubit>();
    final myEventsCubit = context.read<MyEventsCubit>();
    final userHomescreenCubit = context.read<UserHomescreenCubit>();

    // Clear cached data and reset global variables
    await _imageCaching.clearAllCachedData();

    // Reset all cubits
    allEventsCubit.reset();
    myEventsCubit.reset();
    userHomescreenCubit.reset();
    emit(MyProfileInitial());
  }
}
