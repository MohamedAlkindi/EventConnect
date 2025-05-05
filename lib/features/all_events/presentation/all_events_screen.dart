import 'package:event_connect/core/tables/events_table.dart';
import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/event_elements_widget.dart';
import 'package:event_connect/features/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({super.key});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
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

  @override
  void initState() {
    super.initState();
    context.read<AllEventsCubit>().getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AllEventsCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Events'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Categories
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: selectedCategory == categories[index],
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = categories[index];
                        if (selectedCategory == "All") {
                          cubit.getAllEvents();
                        } else {
                          cubit.getEventsByCategory(category: selectedCategory);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // Events List
          Expanded(
            child: BlocConsumer<AllEventsCubit, AllEventsState>(
              listener: (context, state) {
                if (state is AllEventsLoading) {
                  showLoadingDialog(context);
                } else if (state is AllEventsError) {
                  hideLoadingDialog(context);
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
                  hideLoadingDialog(context);
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
              builder: (context, state) {
                return StreamBuilder<List<Map<String, dynamic>>>(
                  stream: cubit.eventsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
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
                                eventPictureLink:
                                    event[EventsTable.eventPictureColumnName],
                              ),

                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Event Name and Location
                                    returnEventMainElements(
                                      eventName: event[
                                          EventsTable.eventNameColumnName],
                                      eventLocation: event[
                                          EventsTable.eventLocationColumnName],
                                    ),

                                    const SizedBox(height: 8),

                                    // Category
                                    returnEventElements(
                                      icon: Icons.category_rounded,
                                      text: event[
                                          EventsTable.eventCategoryColumnName],
                                    ),

                                    const SizedBox(height: 8),

                                    // Date and Time
                                    returnEventElements(
                                      icon: Icons.calendar_today,
                                      icon2: Icons.access_time,
                                      text: event[
                                          EventsTable.eventDateTimeColumnName],
                                    ),

                                    const SizedBox(height: 8),

                                    // Gender Restriction
                                    returnEventElements(
                                      icon: Icons.male_rounded,
                                      icon2: Icons.female_rounded,
                                      text: event[EventsTable
                                          .eventGenderResrictionColumnName],
                                    ),

                                    const SizedBox(height: 8),

                                    // Weather
                                    returnEventElements(
                                      icon: Icons.wb_sunny,
                                      text: "${event["Weather"]} C°",
                                    ),

                                    const SizedBox(height: 8),

                                    // Description
                                    returnEventDescription(
                                      description: event[EventsTable
                                          .eventDescriptionColumnName],
                                    ),

                                    const SizedBox(height: 12),

                                    // Add to Schedule Button
                                    returnEventButton(
                                      buttonText: 'Add to Schedule',
                                      onPressed: () {
                                        cubit.addEventToUserEvents(
                                          eventID: event[
                                              EventsTable.eventIDColumnName],
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
