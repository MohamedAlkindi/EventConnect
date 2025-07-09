import 'dart:async';
import 'dart:developer' as log;

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/attendee/all_events/business_logic/all_events_bl.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'all_events_state.dart';

class AllEventsCubit extends Cubit<AllEventsState> {
  AllEventsCubit() : super(AllEventsInitial());

  final AllEventScreenBL _businessLogic = AllEventScreenBL();

  // Use BehaviorSubject for caching and replaying the latest value
  final BehaviorSubject<List<EventModel>> _eventsSubject =
      BehaviorSubject<List<EventModel>>();

  Stream<List<EventModel>> get eventsStream => _eventsSubject.stream;

  List<EventModel> _allEvents = [];

  @override
  Future<void> close() {
    _eventsSubject.close();
    return super.close();
  }

  final List<String> categories = [
    'All',
    'Music',
    'Art',
    'Sports',
    'Food',
    'Business',
    'Technology',
    'Education'
  ];
  String selectedCategory = 'All';

  void selectCategory(int index) {
    selectedCategory = categories[index];
    emit(CategorySelected(category: categories[index]));
    getEventsByCategory(category: categories[index]);
  }

  // Show all events.
  Future<void> getAllEvents({required bool forceRefresh}) async {
    emit(AllEventsLoading());
    try {
      if (_allEvents.isEmpty || forceRefresh) {
        List<EventModel> allEvents = await _businessLogic.getEvents();
        _allEvents = allEvents;
      }
      // Always emit the latest cached data
      _eventsSubject.add(_allEvents);
    } catch (e) {
      emit(AllEventsError(message: e.toString()));
    }
  }

  // Show events by category.
  Future<void> getEventsByCategory({required String category}) async {
    emit(AllEventsLoading());
    try {
      final filteredEvents = category == "All"
          ? _allEvents
          : _allEvents.where((event) => event.category == category).toList();
      _eventsSubject.add(filteredEvents);
    } catch (e) {
      emit(AllEventsError(message: e.toString()));
    }
  }

  // Add events to user's events.
  Future<void> addEventToUserEvents({required String documentID}) async {
    emit(AllEventsLoading());
    try {
      await _businessLogic.addEventToUserEvents(documentID);

      // Remove the event from the local list
      _allEvents.removeWhere((event) => event.eventID == documentID);

      // Update stream with the new list
      _eventsSubject.add(_allEvents);

      emit(EventAddedToUserEvents());
    } catch (e) {
      emit(AllEventsError(message: e.toString()));
    }
  }

  // This method will take the newly deleted user event and put it in the list.
  void getAndAddUserEvent(EventModel event) {
    _allEvents.add(event);
    _eventsSubject.add(List<EventModel>.from(_allEvents));
    log.log(_allEvents.last.name);
  }

  Future<void> forceRefreshAllEvents() async {
    await getAllEvents(forceRefresh: true);
  }

  Future<void> forceRefreshCategoryEvents({required String category}) async {
    await getEventsByCategory(category: category);
  }

// method to reset cubit and all cached data after logging out or deleting account.
  void reset() {
    emit(AllEventsInitial());
  }

  static String getCategoryDisplay(String value, AppLocalizations l10n) {
    if (value == 'All') return l10n.allCategories;
    const categories = [
      'Music',
      'Art',
      'Sports',
      'Food',
      'Business',
      'Technology',
      'Education',
    ];
    final idx = categories.indexOf(value);
    final localized = [
      l10n.categoryMusic,
      l10n.categoryArt,
      l10n.categorySports,
      l10n.categoryFood,
      l10n.categoryBusiness,
      l10n.categoryTechnology,
      l10n.categoryEducation,
    ];
    return idx >= 0 ? localized[idx] : value;
  }

  static String getCityDisplay(String value, AppLocalizations l10n) {
    const cities = [
      'Hadramout',
      "San'aa",
      'Aden',
      'Taiz',
      'Ibb',
      'Al Hudaydah',
      'Marib',
      'Al Mukalla',
    ];
    final idx = cities.indexOf(value);
    final localized = [
      l10n.cityHadramout,
      l10n.citySanaa,
      l10n.cityAden,
      l10n.cityTaiz,
      l10n.cityIbb,
      l10n.cityHudaydah,
      l10n.cityMarib,
      l10n.cityMukalla,
    ];
    return idx >= 0 ? localized[idx] : value;
  }

  static String getGenderRestrictionDisplay(
      String value, AppLocalizations l10n) {
    const restrictions = [
      'No Restrictions',
      'Male Only',
      'Female Only',
    ];
    final idx = restrictions.indexOf(value);
    final localized = [
      l10n.genderNoRestrictions,
      l10n.genderMaleOnly,
      l10n.genderFemaleOnly,
    ];
    return idx >= 0 ? localized[idx] : value;
  }
}
