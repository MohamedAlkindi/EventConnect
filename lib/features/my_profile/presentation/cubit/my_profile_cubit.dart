import 'package:bloc/bloc.dart';
import 'package:event_connect/features/my_profile/business_logic/my_profile_ba.dart';
import 'package:meta/meta.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit() : super(MyProfileInitial());
  final MyProfileBA _businessLogic = MyProfileBA();

  Future<void> getUserPicAndName() async {
    try {
      final result = await _businessLogic.getUserPicAndName();
      emit(GotMyProfileInfo(userInfo: result));
    } catch (e) {
      emit(MyProfileError(message: e.toString()));
    }
  }

  Future<void> deleteUser() async {
    try {
      await _businessLogic.deleteUser();
      emit(UserDeletedSuccessfully());
    } catch (e) {
      emit(MyProfileError(message: e.toString()));
    }
  }
}
