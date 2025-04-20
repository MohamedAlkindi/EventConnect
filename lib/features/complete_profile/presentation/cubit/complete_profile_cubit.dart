import 'package:bloc/bloc.dart';
import 'package:event_connect/features/complete_profile/business_logic/complete_profile_bl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'complete_profile_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  CompleteProfileCubit() : super(CompleteProfileInitial());

  final CompleteProfileBl _bl = CompleteProfileBl();

  Future<void> completeProfile(
      {required XFile? image, required String city}) async {
    emit(CompleteProfileLoading());
    try {
      await _bl.finalizeProfile(
        imageFile: image,
        city: city,
      );
      emit(CompleteProfileSuccessul());
    } catch (e) {
      emit(CompleteProfileError(message: e.toString()));
    }
  }
}
