import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:event_connect/core/constants/event_categories.dart';
import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/utils/localization_extensions.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/app_background.dart';
import 'package:event_connect/core/widgets/confetti_effect.dart';
import 'package:event_connect/core/widgets/user_main_pages_widgets.dart';
import 'package:event_connect/features/attendee/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/cubit/my_events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final allEventsCubit = context.read<AllEventsCubit>();
    final myEventsCubit = context.read<MyEventsCubit>();

    final confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    return Scaffold(
      body: BlocListener<AllEventsCubit, AllEventsState>(
        listener: (context, state) {
          if (state is EventAddedToUserEvents) {
            showMessageDialog(
              context: context,
              icon: Icons.check_circle_outline_rounded,
              titleText: AppLocalizations.of(context)!.success,
              contentText: AppLocalizations.of(context)!.eventAdded,
              iconColor: Colors.green,
              buttonText: AppLocalizations.of(context)!.okay,
              onPressed: () {
                Navigator.pop(context);
              },
            );
          } else if (state is AllEventsError) {
            final l10n = AppLocalizations.of(context)!;
            final errorMsg = l10n.tryTranslate(state.message);
            showErrorDialog(context: context, message: errorMsg);
          }
        },
        child: Stack(
          children: [
            // Full-page gradient background
            appBackgroundColors(),
            // Main frosted glass content
            RefreshIndicator(
              onRefresh: allEventsCubit.forceRefreshAllEvents,
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

                        // Background colors
                        child: glossyContainerBackground(
                          childWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Modern glossy transparent app bar
                              mainAppBar(context: context),

                              // Categories with modern design
                              // Not used in other pages, leave it alone.
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
                                      itemCount: categories.length,
                                      itemBuilder: (context, index) {
                                        final isSelected =
                                            cubit.selectedCategory ==
                                                categories[index];
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
                                                  AllEventsCubit
                                                      .getCategoryDisplay(
                                                    categories[index],
                                                    AppLocalizations.of(
                                                        context)!,
                                                  ),
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
                                    return waitingCircularIndicator();
                                  } else if (snapshot.hasError) {
                                    return snapshotErrorWidget(
                                        error: snapshot.error);
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return noEventsWidget(
                                      context: context,
                                      onPressed: () {
                                        allEventsCubit.selectedCategory == "All"
                                            ? allEventsCubit
                                                .forceRefreshAllEvents()
                                            : allEventsCubit
                                                .forceRefreshCategoryEvents(
                                                    category: allEventsCubit
                                                        .selectedCategory);
                                      },
                                    );
                                  }
                                  return Column(
                                    children: [
                                      for (final event in snapshot.data!)
                                        contentWidget(
                                          context: context,
                                          eventModel: event,
                                          location:
                                              AllEventsCubit.getCityDisplay(
                                                  event.location,
                                                  AppLocalizations.of(
                                                      context)!),
                                          category:
                                              AllEventsCubit.getCategoryDisplay(
                                                  event.category,
                                                  AppLocalizations.of(
                                                      context)!),
                                          genderRestrection: AllEventsCubit
                                              .getGenderRestrictionDisplay(
                                                  event.genderRestriction,
                                                  AppLocalizations.of(
                                                      context)!),
                                          onTap: () {
                                            confettiController.play();
                                            myEventsCubit
                                                .getAndAddUserEvent(event);
                                            allEventsCubit.addEventToUserEvents(
                                                documentID: event.eventID!);
                                          },
                                        )
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
            confettiEffectWidget(confettiController),
          ],
        ),
      ),
    );
  }
}
