import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/widgets/event_elements_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

Widget glossyContainerBackground({required Widget childWidget}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withAlpha((0.18 * 255).round()),
      borderRadius: BorderRadius.circular(32),
      border: Border.all(
          color: Colors.black.withAlpha((0.12 * 255).round()), width: 1.2),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withAlpha((0.18 * 255).round()),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: childWidget,
  );
}

Widget mainAppBar({required BuildContext context, required String text}) {
  return SizedBox(
    height: 64,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              color: const Color(0xFF6C63FF),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget waitingCircularIndicator() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 60),
    child: Center(
      child: CircularProgressIndicator(
        color: Color(0xFF6C63FF),
      ),
    ),
  );
}

Widget snapshotErrorWidget({required Object? error}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 60),
    child: Center(
      child: Text(
        'Error: $error',
        style: const TextStyle(color: Color(0xFF6C63FF)),
      ),
    ),
  );
}

Widget noEventsWidget({
  required BuildContext context,
  required void Function()? onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 60),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 80,
            color: const Color(0xFF6C63FF).withAlpha((0.5 * 255).round()),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noEventsYet,
            style: GoogleFonts.poppins(
              fontSize: 24,
              color: const Color(0xFF6C63FF),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              AppLocalizations.of(context)!.clickToRefresh,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color.fromARGB(255, 230, 138, 32),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget contentWidget({
  required BuildContext context,
  required EventModel eventModel,
  required String location,
  required String category,
  required String genderRestrection,
  // To determine to use which styling of the button
  // "different buttons styles add and remove".
  required bool isAllEventsPage,
  required void Function()? onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
    decoration: BoxDecoration(
      color: Colors.white.withAlpha((0.95 * 255).round()),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha((0.05 * 255).round()),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event Image with gradient overlay
        Stack(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              child: returnEventPicture(
                eventPictureLink: eventModel.picture,
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
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withAlpha((0.7 * 255).round()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name and Location
              returnEventMainElements(
                eventName: eventModel.name,
                eventLocation: location,
              ),
              const SizedBox(height: 18),
              // Category
              returnEventElements(
                icon: Icons.category_rounded,
                text: category,
              ),
              const SizedBox(height: 14),
              // Date and Time
              returnEventElements(
                icon: Icons.calendar_today,
                icon2: Icons.access_time,
                text: eventModel.dateAndTime,
              ),
              const SizedBox(height: 14),
              // Gender Restriction
              returnEventElements(
                icon: Icons.male_rounded,
                icon2: Icons.female_rounded,
                text: genderRestrection,
              ),
              const SizedBox(height: 14),
              // Weather
              returnEventElements(
                icon: Icons.wb_sunny,
                text: eventModel.weather == null
                    ? AppLocalizations.of(context)!.noWeatherInfo
                    : "${eventModel.weather} C°",
              ),
              const SizedBox(height: 18),
              // Description
              returnEventDescription(
                description: eventModel.description,
              ),
              const SizedBox(height: 24),
              // Modern Add to Schedule Button
              isAllEventsPage
                  ? Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF)
                                .withAlpha((0.18 * 255).round()),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onTap,
                          borderRadius: BorderRadius.circular(16),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.addToSchedule,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF6C63FF),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF)
                                .withAlpha((0.08 * 255).round()),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onTap,
                          borderRadius: BorderRadius.circular(16),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.removeFromSchedule,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF6C63FF),
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
  );
}
