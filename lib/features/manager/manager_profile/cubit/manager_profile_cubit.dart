import 'package:bloc/bloc.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/manager/manager_profile/business_logic/manager_profile_bl.dart';
import 'package:meta/meta.dart';

part 'manager_profile_state.dart';

class ManagerProfileCubit extends Cubit<ManagerProfileState> {
  ManagerProfileCubit() : super(ManagerProfileInitial());

  final _businessLogic = ManagerProfileBl();

  Future<void> getUserPicAndName() async {
    try {
      final result = await _businessLogic.getManagerPicAndLocation();
      emit(GotManagerProfileInfo(userInfo: result));
    } catch (e) {
      emit(ManagerProfileError(message: e.toString()));
    }
  }

  Future<void> userSignOut() async {
    try {
      await _businessLogic.signOut();
      emit(ManagerSignedOutSuccessfully());
    } catch (e) {
      emit(ManagerProfileError(message: e.toString()));
    }
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
