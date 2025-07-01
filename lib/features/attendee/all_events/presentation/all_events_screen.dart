import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/event_elements_widget.dart';
import 'package:event_connect/features/attendee/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AllEventsScreen extends StatelessWidget {
  const AllEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AllEventsScreenView();
  }
}

class AllEventsScreenView extends StatelessWidget {
  const AllEventsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AllEventsCubit>();
    final confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    return Scaffold(
      body: BlocListener<AllEventsCubit, AllEventsState>(
        listener: (context, state) {
          if (state is EventAddedToUserEvents) {
            showMessageDialog(
              context: context,
              icon: Icons.check_circle_outline_rounded,
              titleText: "Success 🥳",
              contentText: "The event has been added to your events!",
              iconColor: Colors.green,
              buttonText: "Okay!",
              onPressed: () {
                Navigator.pop(context);
              },
            );
          } else if (state is AllEventsError) {
            showErrorDialog(context: context, message: state.message);
          }
        },
        child: Stack(
          children: [
            // Full-page gradient background
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
            RefreshIndicator(
              onRefresh: cubit.forceRefreshAllEvents,
              child: SingleChildScrollView(
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
                              // Modern glossy transparent app bar
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
                                        "Discover Events",
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF6C63FF),
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Categories with modern design
                              Container(
                                height: 60,
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                child:
                                    BlocBuilder<AllEventsCubit, AllEventsState>(
                                  builder: (context, state) {
                                    final cubit =
                                        context.read<AllEventsCubit>();
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      itemCount: cubit.categories.length,
                                      itemBuilder: (context, index) {
                                        final isSelected =
                                            cubit.selectedCategory ==
                                                cubit.categories[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 12),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? const Color(0xFF6C63FF)
                                                  : Colors.white.withAlpha(
                                                      (0.7 * 255).round()),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: isSelected
                                                      ? const Color(0xFF6C63FF)
                                                          .withAlpha(
                                                              (0.18 * 255)
                                                                  .round())
                                                      : Colors.black.withAlpha(
                                                          (0.03 * 255).round()),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            child: InkWell(
                                              onTap: () =>
                                                  cubit.selectCategory(index),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              child: Center(
                                                child: Text(
                                                  cubit.categories[index],
                                                  style: GoogleFonts.poppins(
                                                    color: isSelected
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF6C63FF),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              // Events List with modern cards
                              StreamBuilder<List<EventModel>>(
                                stream:
                                    context.read<AllEventsCubit>().eventsStream,
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
                                            Text(
                                              'No Events Yet! 😱',
                                              style: GoogleFonts.poppins(
                                                fontSize: 24,
                                                color: const Color(0xFF6C63FF),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                cubit.selectedCategory == "All"
                                                    ? cubit
                                                        .forceRefreshAllEvents()
                                                    : cubit.forceRefreshCategoryEvents(
                                                        category: cubit
                                                            .selectedCategory);
                                              },
                                              child: Text(
                                                'Click here to refresh',
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
                                                    // Modern Add to Schedule Button
                                                    Container(
                                                      width: double.infinity,
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            const LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                            Color(0xFF6C63FF),
                                                            Color(0xFFFF6584)
                                                          ],
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: const Color(
                                                                    0xFF6C63FF)
                                                                .withAlpha(
                                                                    (0.18 * 255)
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
                                                            confettiController
                                                                .play();
                                                            context
                                                                .read<
                                                                    AllEventsCubit>()
                                                                .addEventToUserEvents(
                                                                    documentID:
                                                                        event
                                                                            .eventID!);
                                                          },
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          child: Center(
                                                            child: Text(
                                                              'Add to Schedule',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white,
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
            ),

            // Confetti effect
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Color(0xFF6C63FF),
                  Color(0xFFFF6584),
                  Color(0xFFFFB74D),
                  Colors.white,
                ],
                emissionFrequency: 0.05,
                numberOfParticles: 15,
                maxBlastForce: 15,
                minBlastForce: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
