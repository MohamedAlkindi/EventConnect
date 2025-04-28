import 'package:event_connect/core/tables/events_table.dart';
import 'package:event_connect/core/utils/message_dialog.dart';
import 'package:event_connect/core/widgets/event_elements_widget.dart';
import 'package:event_connect/features/my_events/presentation/cubit/my_events_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyEventsCubit>().getAllEventsByUserID();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<MyEventsCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Events List
          Expanded(
            child: BlocConsumer<MyEventsCubit, MyEventsState>(
              listener: (context, state) {
                if (state is MyEventsLoading) {
                  // showLoadingDialog(context);
                } else if (state is MyEventsError) {
                  //  hideLoadingDialog(context);
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return dialog(
                        icon: Icons.error_outline_outlined,
                        iconColor: Colors.red,
                        titleText: 'Ouch! 😓',
                        contentText: state.message,
                        buttonText: 'Try Again',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                } else if (state is MyEventsDeletedEvent) {
                  // hideLoadingDialog(context);
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return dialog(
                        icon: Icons.check_circle_outline_rounded,
                        iconColor: Colors.green,
                        titleText: 'Done! 🫡',
                        contentText: 'Event removed from your schedule!',
                        buttonText: 'Okay!',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }
              },
              builder: (context, state) {
                if (state is MyEventsGotEvents) {
                  return ListView.builder(
                    itemCount: state.events.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event Image
                            returnEventPicture(
                              eventPictureLink: state.events[index]
                                  [EventsTable.eventPictureColumnName],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Event Name and Location
                                  returnEventMainElements(
                                    eventName: state.events[index]
                                        [EventsTable.eventNameColumnName],
                                    eventLocation: state.events[index]
                                        [EventsTable.eventLocationColumnName],
                                  ),
                                  const SizedBox(height: 8),

                                  // Category
                                  returnEventElements(
                                    icon: Icons.category_rounded,
                                    text: state.events[index]
                                        [EventsTable.eventCategoryColumnName],
                                  ),
                                  const SizedBox(height: 8),

                                  // Date and Time
                                  returnEventElements(
                                    icon: Icons.calendar_today,
                                    icon2: Icons.access_time,
                                    text: state.events[index]
                                        [EventsTable.eventDateTimeColumnName],
                                  ),

                                  const SizedBox(height: 8),

                                  // Gender Restriction
                                  returnEventElements(
                                    icon: Icons.male_rounded,
                                    icon2: Icons.female_rounded,
                                    text: state.events[index][EventsTable
                                        .eventGenderResrictionColumnName],
                                  ),

                                  const SizedBox(height: 8),

                                  // Weather
                                  // returnEventElements(
                                  //   icon: Icons.wb_sunny,
                                  //   text: state.events[index]
                                  //       [EventsTable.eventWeatherColumnName],
                                  // ),

                                  const SizedBox(height: 8),

                                  // Description
                                  returnEventDescription(
                                    description: state.events[index][
                                        EventsTable.eventDescriptionColumnName],
                                  ),

                                  const SizedBox(height: 12),

                                  // Remove from Schedule Button
                                  returnEventButton(
                                    buttonText: 'Remove from Schedule',
                                    onPressed: () {
                                      cubit.deleteEventFromUserEvents(
                                        eventID: state.events[index]
                                            [EventsTable.eventIDColumnName],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is MyEventsNoEventsAddedYet) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Events in Your Schedule Yet!",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              userHomeScreenPageRoute,
                            );
                          },
                          child: Text(
                            'Add events from here to your schedule!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
