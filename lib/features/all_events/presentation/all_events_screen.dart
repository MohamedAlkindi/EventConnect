import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/event_elements_widget.dart';
import 'package:event_connect/features/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllEventsScreen extends StatelessWidget {
  const AllEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllEventsCubit()..getAllEvents(),
      child: const AllEventsScreenView(),
    );
  }
}

class AllEventsScreenView extends StatelessWidget {
  const AllEventsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Events'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<AllEventsCubit, AllEventsState>(
        listener: (context, state) {
          if (state is AllEventsError) {
            showMessageDialog(
              context: context,
              titleText: 'Error',
              contentText: state.message,
              icon: Icons.error_outline,
              iconColor: Colors.red,
              buttonText: 'Okay',
              onPressed: () {
                Navigator.pop(context);
              },
            );
          } else if (state is EventAddedToUserEvents) {
            showMessageDialog(
              context: context,
              titleText: 'Yay! 😁🤟🏻',
              contentText: 'Event added to your schedule!',
              icon: Icons.check_circle_outline_rounded,
              iconColor: Colors.green,
              buttonText: 'Okay!',
              onPressed: () {
                Navigator.pop(context);
              },
            );
          }
        },
        child: Column(
          children: [
            // Categories
            BlocBuilder<AllEventsCubit, AllEventsState>(
              builder: (context, state) {
                final cubit = context.read<AllEventsCubit>();
                return SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cubit.categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: Text(cubit.categories[index]),
                          selected:
                              cubit.selectedCategory == cubit.categories[index],
                          onSelected: (selected) {
                            cubit.selectCategory(index);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            // Events List
            Expanded(
              child: StreamBuilder<List<EventModel>>(
                stream: context.read<AllEventsCubit>().eventsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Events Yet! 😱',
                            style: TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final event = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event Image
                            returnEventPicture(
                              eventPictureLink: event.picture,
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Event Name and Location
                                  returnEventMainElements(
                                    eventName: event.name,
                                    eventLocation: event.location,
                                  ),

                                  const SizedBox(height: 8),

                                  // Category
                                  returnEventElements(
                                    icon: Icons.category_rounded,
                                    text: event.category,
                                  ),

                                  const SizedBox(height: 8),

                                  // Date and Time
                                  returnEventElements(
                                    icon: Icons.calendar_today,
                                    icon2: Icons.access_time,
                                    text: event.dateAndTime,
                                  ),

                                  const SizedBox(height: 8),

                                  // Gender Restriction
                                  returnEventElements(
                                    icon: Icons.male_rounded,
                                    icon2: Icons.female_rounded,
                                    text: event.genderRestriction,
                                  ),

                                  const SizedBox(height: 8),

                                  // Weather
                                  returnEventElements(
                                    icon: Icons.wb_sunny,
                                    text: event.weather == null
                                        ? "${event.weather} C°"
                                        : "No weather info",
                                  ),

                                  const SizedBox(height: 8),

                                  // Description
                                  returnEventDescription(
                                    description: event.description,
                                  ),

                                  const SizedBox(height: 12),

                                  // Add to Schedule Button
                                  returnEventButton(
                                    buttonText: 'Add to Schedule',
                                    onPressed: () {
                                      context
                                          .read<AllEventsCubit>()
                                          .addEventToUserEvents(
                                            documentID: event.eventID,
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
