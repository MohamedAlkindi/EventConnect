import 'package:event_connect/core/tables/events_table.dart';
import 'package:event_connect/core/utils/loading_dialog.dart';
import 'package:event_connect/core/utils/message_dialog.dart';
import 'package:event_connect/features/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({super.key});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  final TextEditingController _searchController = TextEditingController();
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  showDialog(
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
                } else if (state is EventAddedToUserEvents) {
                  hideLoadingDialog(context);
                  context.read<AllEventsCubit>().getAllEvents();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return dialog(
                        icon: Icons.check_circle_outline_rounded,
                        iconColor: Colors.green,
                        titleText: 'Yay! 😁🤟🏻',
                        contentText: 'Event added to your schedule!',
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
                if (state is AllEventsGotEvents) {
                  return ListView.builder(
                    itemCount: state.events.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event Image
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(state.events[index][
                                          EventsTable.eventPictureColumnName] ??
                                      ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Event Name and Location
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          state.events[index]
                                              [EventsTable.eventNameColumnName],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // Location
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 16),
                                          const SizedBox(width: 4),
                                          Text(state.events[index][EventsTable
                                                  .eventLocationColumnName] ??
                                              ''),
                                        ],
                                      ),
                                      // IconButton(
                                      //   icon: const Icon(Icons.favorite_border),
                                      //   onPressed: () {},
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Category
                                  Row(
                                    children: [
                                      const Icon(Icons.category_rounded,
                                          size: 16),
                                      const SizedBox(width: 4),
                                      Text(state.events[index][EventsTable
                                              .eventCategoryColumnName] ??
                                          ''),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Date and Time
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 16),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.access_time, size: 16),
                                      const SizedBox(width: 4),
                                      Text(state.events[index][EventsTable
                                              .eventDateTimeColumnName] ??
                                          ''),
                                      const SizedBox(width: 16),
                                      // Text(state.events[index][EventsTable
                                      //         .eventTimeColumnName] ??
                                      //     ''),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  // Gender Restriction
                                  Row(
                                    children: [
                                      const Icon(Icons.male_rounded, size: 16),
                                      const SizedBox(width: 2),
                                      const Icon(Icons.female_rounded,
                                          size: 16),
                                      const SizedBox(width: 4),
                                      Text(state.events[index][EventsTable
                                              .eventGenderResrictionColumnName] ??
                                          ''),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  // Weather
                                  Row(
                                    children: [
                                      const Icon(Icons.wb_sunny, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                          state.events[index]['Weather'] ?? ''),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  // Description
                                  Text(
                                    state.events[index][EventsTable
                                            .eventDescriptionColumnName] ??
                                        '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 12),

                                  // Add to Schedule Button
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        cubit.addEventToUserEvents(
                                          eventID: state.events[index]
                                              [EventsTable.eventIDColumnName],
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        'Add to Schedule',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is AllEventsNoEventsYet) {
                  return const Center(
                    child: Text("No Events Yet!"),
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
