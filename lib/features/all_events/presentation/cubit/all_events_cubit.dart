import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/features/all_events/business_logic/all_events_bl.dart';
import 'package:flutter/material.dart';

part 'all_events_state.dart';

class AllEventsCubit extends Cubit<AllEventsState> {
  AllEventsCubit() : super(AllEventsInitial());

  final AllEventScreenBL _businessLogic = AllEventScreenBL();

  // Stream controller for real-time event updates
  final StreamController<List<EventModel>> _eventsStreamController =
      StreamController<List<EventModel>>.broadcast();

  // Expose the stream to listen for real-time updates
  Stream<List<EventModel>> get eventsStream => _eventsStreamController.stream;

  List<EventModel> _allEvents = [];

  @override
  Future<void> close() {
    _eventsStreamController.close();
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
  Future<void> getAllEvents() async {
    emit(AllEventsLoading());
    try {
      List<EventModel> allEvents = await _businessLogic.getEvents();
      _allEvents = allEvents;
      // Update stream for real-time listeners
      _eventsStreamController.add(_allEvents);
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

      // Update stream for real-time listeners
      _eventsStreamController.add(filteredEvents);
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
      _eventsStreamController.add(_allEvents);

      emit(EventAddedToUserEvents());
    } catch (e) {
      emit(AllEventsError(message: e.toString()));
    }
  }
}
