import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/constants/event_categories.dart';
import 'package:event_connect/core/constants/gender_restrictions.dart';
import 'package:event_connect/core/constants/user_cities.dart';
import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/manager/manager_events/business_logic/manager_events_bl.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/manager_events_cubit.dart';
import 'package:flutter/material.dart';
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

  String selectedLocation = 'Al Mukalla';
  void selectLocation(String? location) {
    if (location != null) {
      selectedLocation = location;
      emit(SelectedLocation(selectedLocation: selectedLocation));
    }
  }

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

  Widget getImageForClipRRect() {
    if (eventImage != null) {
      return Image.file(
        File(eventImage!.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Container(
      color: const Color.fromARGB(255, 230, 232, 241),
      child: const Center(
        child: Icon(
          Icons.event,
          size: 64,
          color: Color(0xFF6C63FF),
        ),
      ),
    );
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
    final idx = eventCategories.indexOf(value);
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
    final idx = cities.indexOf(value);
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
