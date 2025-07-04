import 'dart:ui';

import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/event_elements_widget.dart';
import 'package:event_connect/features/attendee/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/cubit/my_events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyEventsScreenView();
  }
}

class MyEventsScreenView extends StatelessWidget {
  const MyEventsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final myEventsCubit = context.read<MyEventsCubit>();
    final allEventsCubit = context.read<AllEventsCubit>();

    return Scaffold(
      body: BlocListener<MyEventsCubit, MyEventsState>(
        listener: (context, state) {
          if (state is MyEventsDeletedEvent) {
            showMessageDialog(
              context: context,
              icon: Icons.check_circle_outline_rounded,
              titleText: "Success 🥳",
              contentText: "The event has been deleted from your events!",
              iconColor: Colors.green,
              buttonText: "Okay!",
              onPressed: () {
                Navigator.pop(context);
              },
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: myEventsCubit.forceRefreshEvents,
          child: Stack(
            children: [
              // Modern background with gradient and subtle overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFe0e7ff),
                      Color(0xFFfceabb),
                      Color(0xFFf8b6b8)
                    ],
                  ),
                ),
              ),
              // Main frosted glass content
              SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha((0.18 * 255).round()),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                                color: Colors.black
                                    .withAlpha((0.12 * 255).round()),
                                width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white
                                    .withAlpha((0.18 * 255).round()),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 64,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "My Events",
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF6C63FF),
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withAlpha(
                                                  (0.08 * 255).round()),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Events List with modern cards
                              StreamBuilder<List<EventModel>>(
                                stream: myEventsCubit.eventsStream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 60),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF6C63FF),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 60),
                                      child: Center(
                                        child: Text(
                                          'Error:  ${snapshot.error}',
                                          style: const TextStyle(
                                              color: Color(0xFF6C63FF)),
                                        ),
                                      ),
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 60),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.event_busy_rounded,
                                              size: 80,
                                              color: const Color(0xFF6C63FF)
                                                  .withAlpha(
                                                      (0.5 * 255).round()),
                                            ),
                                            const SizedBox(height: 16),
                                            Column(
                                              children: [
                                                Text(
                                                  'No Events Yet! 😱',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 24,
                                                    color:
                                                        const Color(0xFF6C63FF),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Add some events to your schedule',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                myEventsCubit
                                                    .forceRefreshEvents();
                                              },
                                              child: Text(
                                                'Or click here to refresh',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: const Color.fromARGB(
                                                      255, 230, 138, 32),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return Column(
                                    children: [
                                      for (final event in snapshot.data!)
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 24, left: 20, right: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(
                                                (0.95 * 255).round()),
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withAlpha(
                                                    (0.05 * 255).round()),
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Event Image with gradient overlay
                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    24)),
                                                    child: returnEventPicture(
                                                      eventPictureLink:
                                                          event.picture,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Colors.transparent,
                                                            Colors.black
                                                                .withAlpha((0.7 *
                                                                        255)
                                                                    .round()),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(24.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Event Name and Location
                                                    returnEventMainElements(
                                                      eventName: event.name,
                                                      eventLocation:
                                                          event.location,
                                                    ),
                                                    const SizedBox(height: 18),
                                                    // Category
                                                    returnEventElements(
                                                      icon: Icons
                                                          .category_rounded,
                                                      text: event.category,
                                                    ),
                                                    const SizedBox(height: 14),
                                                    // Date and Time
                                                    returnEventElements(
                                                      icon:
                                                          Icons.calendar_today,
                                                      icon2: Icons.access_time,
                                                      text: event.dateAndTime,
                                                    ),
                                                    const SizedBox(height: 14),
                                                    // Gender Restriction
                                                    returnEventElements(
                                                      icon: Icons.male_rounded,
                                                      icon2:
                                                          Icons.female_rounded,
                                                      text: event
                                                          .genderRestriction,
                                                    ),
                                                    const SizedBox(height: 14),
                                                    // Weather
                                                    returnEventElements(
                                                      icon: Icons.wb_sunny,
                                                      text: event.weather ==
                                                              null
                                                          ? "No weather info"
                                                          : "${event.weather} C°",
                                                    ),
                                                    const SizedBox(height: 18),
                                                    // Description
                                                    returnEventDescription(
                                                      description:
                                                          event.description,
                                                    ),
                                                    const SizedBox(height: 24),
                                                    // Modern Remove from Schedule Button
                                                    Container(
                                                      width: double.infinity,
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        border: Border.all(
                                                          color: const Color(
                                                              0xFF6C63FF),
                                                          width: 2,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: const Color(
                                                                    0xFF6C63FF)
                                                                .withAlpha(
                                                                    (0.08 * 255)
                                                                        .round()),
                                                            blurRadius: 10,
                                                            offset:
                                                                const Offset(
                                                                    0, 5),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            allEventsCubit
                                                                .getAndAddUserEvent(
                                                                    event);
                                                            myEventsCubit
                                                                .deleteEventFromUserEvents(
                                                                    documentID:
                                                                        event
                                                                            .eventID!);
                                                          },
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          child: Center(
                                                            child: Text(
                                                              'Remove from Schedule',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: const Color(
                                                                    0xFF6C63FF),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
