import 'package:bloc/bloc.dart';
import 'package:event_connect/core/constants/event_categories.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/manager/manager_events/business_logic/manager_events_bl.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/manager_events_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'add_event_state.dart';

class AddEventCubit extends Cubit<AddEventState> {
  final ManagerEventsCubit managerCubit;
  AddEventCubit(this.managerCubit) : super(AddEventInitial());
  final _businessLogic = ManagerEventsBl();

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

  Future<void> addEventInfo({
    required String name,
    required String dateAndTime,
    required String description,
  }) async {
    try {
      emit(ManagerEventsLoading());
      if (name.trim().isEmpty ||
          dateAndTime.trim().isEmpty ||
          description.trim().isEmpty ||
          eventImage == null) {
        throw GenericException("Please enter valid inputs");
      } else {
        EventModel event = await _businessLogic.addEvent(
            name: name,
            category: selectedCategory,
            picturePath: eventImage!.path,
            location: selectedLocation,
            dateAndTime: dateAndTime,
            description: description,
            genderRestriction: selectedGenderRestriction);
        managerCubit.addEventToStream(event);
        emit(EventAddedSuccessfully());
      }
    } catch (e) {
      emit(AddEventError(message: e.toString()));
    }
  }

  List<String> getLocalizedCategories(AppLocalizations l10n) => [
        l10n.categoryMusic,
        l10n.categoryArt,
        l10n.categorySports,
        l10n.categoryFood,
        l10n.categoryBusiness,
        l10n.categoryTechnology,
        l10n.categoryEducation,
      ];
  String getCategoryDisplay(String value, AppLocalizations l10n) {
    final idx = categories.indexOf(value);
    return idx >= 0 ? getLocalizedCategories(l10n)[idx] : value;
  }

  List<String> getLocalizedCities(AppLocalizations l10n) => [
        l10n.cityHadramout,
        l10n.citySanaa,
        l10n.cityAden,
        l10n.cityTaiz,
        l10n.cityIbb,
        l10n.cityHudaydah,
        l10n.cityMarib,
        l10n.cityMukalla,
      ];
  String getCityDisplay(String value, AppLocalizations l10n) {
    final idx = yemeniCities.indexOf(value);
    return idx >= 0 ? getLocalizedCities(l10n)[idx] : value;
  }

  List<String> getLocalizedGenderRestrictions(AppLocalizations l10n) => [
        l10n.genderNoRestrictions,
        l10n.genderMaleOnly,
        l10n.genderFemaleOnly,
      ];
  String getGenderRestrictionDisplay(String value, AppLocalizations l10n) {
    final idx = genderRestrictions.indexOf(value);
    return idx >= 0 ? getLocalizedGenderRestrictions(l10n)[idx] : value;
  }
}
