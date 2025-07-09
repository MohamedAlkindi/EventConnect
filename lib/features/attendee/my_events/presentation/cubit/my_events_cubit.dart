import 'dart:async';
import 'dart:developer' as log;

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/attendee/my_events/business_logic/my_events_bl.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'my_events_state.dart';

class MyEventsCubit extends Cubit<MyEventsState> {
  MyEventsCubit() : super(MyEventsInitial());
  final MyEventsBL _myEventsBL = MyEventsBL();

  // Stream controller for real-time event updates
  final BehaviorSubject<List<EventModel>> _eventsSubject =
      BehaviorSubject<List<EventModel>>();
  Stream<List<EventModel>> get eventsStream => _eventsSubject.stream;

  List<EventModel> _events = [];

  @override
  Future<void> close() {
    _eventsSubject.close();
    return super.close();
  }

  Future<void> getAllEventsByUserID({required bool forceRefresh}) async {
    emit(MyEventsLoading());
    try {
      if (_events.isEmpty || forceRefresh) {
        log.log("Reset again");
        List<EventModel> allEvents = await _myEventsBL.getAllEventsByUserID();
        _events = allEvents;
      }

      // Update stream for real-time listeners
      _eventsSubject.add(List<EventModel>.from(_events));
    } catch (e) {
      emit(MyEventsError(message: e.toString()));
    }
  }

  // Delete event from user's events.
  Future<void> deleteEventFromUserEvents({required String documentID}) async {
    try {
      await _myEventsBL.deleteEventFromUserEvents(documentID);
      // Refresh the events list after deleting
      // Remove the event from the local list
      _events.removeWhere((event) => event.eventID == documentID);
      // Update stream with the new list
      _eventsSubject.add(List<EventModel>.from(_events));
      emit(MyEventsDeletedEvent());
      // Notification logic will be handled by a listener, not here
    } catch (e) {
      emit(MyEventsError(message: e.toString()));
    }
  }

  Future<void> forceRefreshEvents() async {
    await getAllEventsByUserID(forceRefresh: true);
  }

  // This method will take the newly added user event and put it in the list.
  void getAndAddUserEvent(EventModel event) {
    _events.add(event);
    _eventsSubject.add(List<EventModel>.from(_events));
    // Notification logic will be handled by a listener, not here
  }

  // method to reset cubit and all cached data after logging out or deleting account.
  void reset() {
    emit(MyEventsInitial());
  }

  static String getCategoryDisplay(String value, AppLocalizations l10n) {
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
