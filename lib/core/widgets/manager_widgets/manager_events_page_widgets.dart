import 'dart:ui';

import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/attendee_widgets/event_elements_widget.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/add_event_cubit.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/manager_events_cubit.dart';
import 'package:event_connect/features/manager/manager_events/presentation/edit_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget managerRefreshIndicatorWithClip({
  required Future<void> Function() onRefresh,
  required Widget childWidget,
}) {
  return RefreshIndicator(
    onRefresh: onRefresh,
    child: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: childWidget,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget managerGlossyContainerBackground({required Widget childWidget}) {
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

Widget managerMainAppBar({
  required String barText,
  required void Function()? onTap,
  required String buttonText,
}) {
  return SizedBox(
    height: 64,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate available width for each element
          double totalWidth = constraints.maxWidth;
          // Reserve at least 100 for the button, 12 for spacing
          double buttonWidth = totalWidth * 0.22;
          if (buttonWidth < 70) buttonWidth = 70;
          if (buttonWidth > 120) buttonWidth = 120;
          double textMaxWidth = totalWidth - buttonWidth - 12;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Flexible text to avoid overflow
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: textMaxWidth,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      barText,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF6C63FF),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: buttonWidth,
                  height: 35,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.18 * 255).round()),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

Widget managerWaitingCircularIndicator() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 60),
    child: Center(
      child: CircularProgressIndicator(
        color: Color(0xFF6C63FF),
      ),
    ),
  );
}

Widget managerSnapshotErrorWidget({required Object? error}) {
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

Widget managerNoEventsWidget() {
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
            'No Events Yet! 😱',
            style: GoogleFonts.poppins(
              fontSize: 24,
              color: const Color(0xFF6C63FF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget managerContentWidget({
  required BuildContext context,
  required EventModel event,
  required AddEventCubit addEventCubit,
  required ManagerEventsCubit managerEventsCubit,
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
    child: contentColumnWidget(
      context: context,
      event: event,
      addEventCubit: addEventCubit,
      managerEventsCubit: managerEventsCubit,
    ),
  );
}

Widget contentColumnWidget({
  required BuildContext context,
  required EventModel event,
  required AddEventCubit addEventCubit,
  required ManagerEventsCubit managerEventsCubit,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Event Image with gradient overlay
      Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: returnEventPicture(
              eventPictureLink: event.picture,
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
              eventName: event.name,
              eventLocation: addEventCubit.getCityDisplay(
                event.location,
                AppLocalizations.of(context)!,
              ),
            ),
            const SizedBox(height: 18),
            // Category
            returnEventElements(
              icon: Icons.category_rounded,
              text: addEventCubit.getCategoryDisplay(
                  event.category, AppLocalizations.of(context)!),
            ),
            const SizedBox(height: 14),
            // Date and Time
            returnEventElements(
              icon: Icons.calendar_today,
              icon2: Icons.access_time,
              text: event.dateAndTime,
            ),
            const SizedBox(height: 14),
            // Gender Restriction
            returnEventElements(
              icon: Icons.male_rounded,
              icon2: Icons.female_rounded,
              text: addEventCubit.getGenderRestrictionDisplay(
                  event.genderRestriction, AppLocalizations.of(context)!),
            ),
            const SizedBox(height: 14),
            // Attendees
            returnEventElements(
              icon: Icons.people_alt_rounded,
              text: event.attendees == 1
                  ? "${event.attendees} ${AppLocalizations.of(context)!.attendant}"
                  : "${event.attendees} ${AppLocalizations.of(context)!.attendees}",
            ),
            const SizedBox(height: 18),
            // Description
            returnEventDescription(
              description: event.description,
            ),
            const SizedBox(height: 24),
            // Modern Delete and edit to Schedule Button
            managerActionButtons(
              context: context,
              managerEventsCubit: managerEventsCubit,
              event: event,
            )
          ],
        ),
      ),
    ],
  );
}

// Delete and edit buttons
Widget managerActionButtons({
  required BuildContext context,
  required EventModel event,
  required ManagerEventsCubit managerEventsCubit,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        // Edit button.
        child: buttonContainer(
          colorList: [
            Color(0xFF6C63FF),
            Color(0xFFFF6584),
          ],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditEventScreen(eventModel: event),
              ),
            );
          },
          buttonText: AppLocalizations.of(context)!.editEvent,
        ),
      ),
      SizedBox(width: 25),
      Expanded(
        // Delete button.
        child: buttonContainer(
          colorList: [
            Color(0xFF6C63FF),
            Color.fromARGB(255, 255, 0, 51),
          ],
          onTap: () {
            showMessageDialog(
              context: context,
              icon: Icons.warning_rounded,
              iconColor: Colors.orangeAccent,
              titleText: AppLocalizations.of(context)!.deleteEvent,
              contentText:
                  AppLocalizations.of(context)!.deleteEventDialogContent,
              buttonText: AppLocalizations.of(context)!.yes,
              onPressed: () {
                managerEventsCubit.deleteEvent(documentID: event.eventID!);
                Navigator.pop(context);
              },
              secondButtonText: AppLocalizations.of(context)!.no,
              secondOnPressed: () {
                Navigator.pop(context);
              },
            );
          },
          buttonText: AppLocalizations.of(context)!.deleteEvent,
        ),
      ),
    ],
  );
}

Widget buttonContainer({
  // For the colors.
  required List<Color> colorList,
  required void Function()? onTap,
  required String buttonText,
}) {
  return Container(
    height: 48,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colorList,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6C63FF).withAlpha((0.18 * 255).round()),
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
            buttonText,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}
