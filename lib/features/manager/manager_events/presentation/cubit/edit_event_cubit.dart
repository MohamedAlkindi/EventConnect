import 'package:bloc/bloc.dart';
import 'package:event_connect/features/manager/manager_events/business_logic/manager_events_bl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'edit_event_state.dart';

class EditEventCubit extends Cubit<EditEventState> {
  EditEventCubit() : super(EditEventInitial());
  final _businessLogic = ManagerEventsBl();

  final List<String> categories = [
    'Music',
    'Art',
    'Sports',
    'Food',
    'Business',
    'Technology',
    'Education'
  ];
  String selectedCategory = 'Music';
  void selectCategoty(String? category) {
    if (category != null) {
      selectedCategory = category;
      emit(SelectedCategory(selectedCategory: selectedCategory));
    }
  }

  final List<String> yemeniCities = [
    'Hadramout',
    "San'aa",
    'Aden',
    'Taiz',
    'Ibb',
    'Al Hudaydah',
    'Marib',
    'Al Mukalla'
  ];
  String selectedLocation = 'Al Mukalla';
  void selectLocation(String? location) {
    if (location != null) {
      selectedLocation = location;
      emit(SelectedLocation(selectedLocation: selectedLocation));
    }
  }

  final List<String> genderRestrictions = [
    'No Restrictions',
    'Male Only',
    'Female Only'
  ];
  String selectedGenderRestriction = 'No Restrictions';
  void selectGenderRestriction(String? genderRestriction) {
    if (genderRestriction != null) {
      selectedGenderRestriction = genderRestriction;
      emit(SelectedGenderRestriction(
          selectedGenderRestriction: selectedGenderRestriction));
    }
  }

  XFile? eventImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      eventImage = image;
      emit(SelectedImage(selectedImagePath: image.path));
    }
  }

  Future<void> editEventInfo({
    required String docID,
    required String name,
    required String dateAndTime,
    required String description,
    required String supabaseImageUrl,
  }) async {
    try {
      await _businessLogic.editEvent(
        docID: docID,
        name: name,
        category: selectedCategory,
        // when updating the picture u need 2 things:
        // 1 is the new picture path related to device.
        // 2 is the supabase path related to the old picture.
        supabaseImageUrl: supabaseImageUrl,
        picturePath: eventImage?.path,
        location: selectedLocation,
        dateAndTime: dateAndTime,
        description: description,
        genderRestriction: selectedGenderRestriction,
      );
      emit(EventUpdatedSuccessfully());
    } catch (e) {
      emit(EditEventError(message: e.toString()));
    }
  }
}
