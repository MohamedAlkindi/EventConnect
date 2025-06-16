import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/widgets/event_elements_widget.dart';
import 'package:event_connect/features/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    return Scaffold(
      body: Stack(
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
          Center(
            child: Container(
              margin: const EdgeInsets.only(
                  top: 40, left: 12, right: 12, bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                    color: Colors.white.withOpacity(0.3), width: 1.2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          // Modern gradient app bar
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF6C63FF),
                                  const Color(0xFF6C63FF).withOpacity(0.8),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF6C63FF).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Discover Events",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Find your next adventure",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Categories with modern design
                          Container(
                            height: 60,
                            margin: const EdgeInsets.only(top: 20),
                            child: BlocBuilder<AllEventsCubit, AllEventsState>(
                              builder: (context, state) {
                                final cubit = context.read<AllEventsCubit>();
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  itemCount: cubit.categories.length,
                                  itemBuilder: (context, index) {
                                    final isSelected = cubit.selectedCategory ==
                                        cubit.categories[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFF6C63FF)
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isSelected
                                                  ? const Color(0xFF6C63FF)
                                                      .withOpacity(0.3)
                                                  : Colors.black
                                                      .withOpacity(0.05),
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
                                                    : const Color(0xFF6C63FF),
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
                          Expanded(
                            child: StreamBuilder<List<EventModel>>(
                              stream:
                                  context.read<AllEventsCubit>().eventsStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF6C63FF),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Error: ${snapshot.error}',
                                      style: const TextStyle(
                                          color: Color(0xFF6C63FF)),
                                    ),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.event_busy_rounded,
                                          size: 80,
                                          color: const Color(0xFF6C63FF)
                                              .withOpacity(0.5),
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
                                      ],
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  padding: const EdgeInsets.all(20),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final event = snapshot.data![index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
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
                                                    const BorderRadius.vertical(
                                                  top: Radius.circular(24),
                                                ),
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
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black
                                                            .withOpacity(0.7),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Event Name and Location
                                                returnEventMainElements(
                                                  eventName: event.name,
                                                  eventLocation: event.location,
                                                ),
                                                const SizedBox(height: 16),
                                                // Category
                                                returnEventElements(
                                                  icon: Icons.category_rounded,
                                                  text: event.category,
                                                ),
                                                const SizedBox(height: 12),
                                                // Date and Time
                                                returnEventElements(
                                                  icon: Icons.calendar_today,
                                                  icon2: Icons.access_time,
                                                  text: event.dateAndTime,
                                                ),
                                                const SizedBox(height: 12),
                                                // Gender Restriction
                                                returnEventElements(
                                                  icon: Icons.male_rounded,
                                                  icon2: Icons.female_rounded,
                                                  text: event.genderRestriction,
                                                ),
                                                const SizedBox(height: 12),
                                                // Weather
                                                returnEventElements(
                                                  icon: Icons.wb_sunny,
                                                  text: event.weather == null
                                                      ? "${event.weather} C°"
                                                      : "No weather info",
                                                ),
                                                const SizedBox(height: 16),
                                                // Description
                                                returnEventDescription(
                                                  description:
                                                      event.description,
                                                ),
                                                const SizedBox(height: 20),
                                                // Modern Add to Schedule Button
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              AllEventsCubit>()
                                                          .addEventToUserEvents(
                                                            documentID:
                                                                event.eventID,
                                                          );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF6C63FF),
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    child: Text(
                                                      'Add to Schedule',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
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
    );
  }
}
