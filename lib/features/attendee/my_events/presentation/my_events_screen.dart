import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/core/widgets/attendee_widgets/user_events_pages_widgets.dart';
import 'package:event_connect/features/attendee/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/cubit/my_events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_connect/l10n/app_localizations.dart';

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
              titleText: AppLocalizations.of(context)!.success,
              contentText: AppLocalizations.of(context)!.eventDeleted,
              iconColor: Colors.green,
              buttonText: AppLocalizations.of(context)!.okay,
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
              appBackgroundColors(),
              // Main frosted glass content
              refreshIndicatorWithClip(
                onRefresh: myEventsCubit.forceRefreshEvents,
                childWidget: glossyContainerBackground(
                  childWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      mainAppBar(
                          context: context,
                          text: AppLocalizations.of(context)!.myEvents),

                      // TODO: Add the categories here

                      // Events List with modern cards
                      StreamBuilder<List<EventModel>>(
                        stream: myEventsCubit.eventsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return waitingCircularIndicator();
                          } else if (snapshot.hasError) {
                            return snapshotErrorWidget(error: snapshot.error);
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return noEventsWidget(
                              context: context,
                              onPressed: () {
                                myEventsCubit.forceRefreshEvents();
                              },
                            );
                          }
                          return Column(
                            children: [
                              for (final event in snapshot.data!)
                                contentWidget(
                                  context: context,
                                  eventModel: event,
                                  location: MyEventsCubit.getCityDisplay(
                                      event.location,
                                      AppLocalizations.of(context)!),
                                  category: MyEventsCubit.getCategoryDisplay(
                                      event.category,
                                      AppLocalizations.of(context)!),
                                  genderRestrection:
                                      MyEventsCubit.getGenderRestrictionDisplay(
                                          event.genderRestriction,
                                          AppLocalizations.of(context)!),
                                  onTap: () {
                                    allEventsCubit.getAndAddUserEvent(event);
                                    myEventsCubit.deleteEventFromUserEvents(
                                        documentID: event.eventID!);
                                    myEventsCubit.forceRefreshEvents();
                                  },
                                  isAllEventsPage: false,
                                ),
                            ],
                          );
                        },
                      ),
                    ],
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
