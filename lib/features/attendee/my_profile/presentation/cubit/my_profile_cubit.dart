import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/features/attendee/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:event_connect/features/attendee/edit_profile/presentation/edit_profile_screen.dart';
import 'package:event_connect/features/attendee/my_events/presentation/cubit/my_events_cubit.dart';
import 'package:event_connect/features/attendee/my_profile/business_logic/my_profile_bl.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/cubit/user_homescreen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meta/meta.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit() : super(MyProfileInitial());
  final MyProfileBL _businessLogic = MyProfileBL();

  Future<void> getUserPic() async {
    try {
      final result = await _businessLogic.getUserPicAndLocation();
      emit(GotMyProfileInfo(userModel: result));
    } catch (e) {
      emit(MyProfileError(message: e.toString()));
    }
  }

  Future<void> changeAccountSettings(
      {required BuildContext context, required String cachedImagePath}) async {
    final myProfileCubit = context.read<MyProfileCubit>();
    final userHomescreenCubit = context.read<UserHomescreenCubit>();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          cachedImagePath: cachedImagePath,
        ),
      ),
    );
    if (result != null) {
      myProfileCubit.getUserPic();
      userHomescreenCubit.getUserProfilePic();
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
      await _businessLogic.deleteUser();
      emit(UserDeletedSuccessfully());
    } catch (e) {
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
  void resetAllCubits({required BuildContext context}) {
    context.read<AllEventsCubit>().reset();
    context.read<MyEventsCubit>().reset();
    context.read<UserHomescreenCubit>().reset();
    emit(MyProfileInitial());
  }
}
