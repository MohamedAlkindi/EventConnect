import 'package:event_connect/core/models/event_model.dart';
import 'package:event_connect/core/utils/message_dialogs.dart';
import 'package:event_connect/core/widgets/manager_widgets/manager_events_page_widgets.dart';
import 'package:event_connect/core/widgets/shared/app_background.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/add_event_cubit.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/manager_events_cubit.dart';
import 'package:event_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowManagerEventsScreen extends StatelessWidget {
  const ShowManagerEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AllEventsScreenView();
  }
}

class AllEventsScreenView extends StatelessWidget {
  const AllEventsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ManagerEventsCubit>();
    final addEventCubit = AddEventCubit(context.read<ManagerEventsCubit>());

    return Scaffold(
      body: BlocListener<ManagerEventsCubit, ManagerEventsState>(
        listener: (context, state) {
          if (state is EventDeletedSuccessfully) {
            // Might need to make it reusable..
            showMessageDialog(
              context: context,
              icon: Icons.check_circle_outline_rounded,
              titleText: "Success 🥳",
              contentText: "The event has been deleted Successfully!",
              iconColor: Colors.green,
              buttonText: "Okay!",
              onPressed: () {
                Navigator.pop(context);
              },
            );
          }
        },
        child: Stack(
          children: [
            // Full-page gradient background
            appBackgroundColors(),
            // Main frosted glass content
            managerRefreshIndicatorWithClip(
              onRefresh: cubit.refreshManagerEvents,
              childWidget: managerGlossyContainerBackground(
                childWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Modern glossy transparent app bar
                    managerMainAppBar(
                      barText: AppLocalizations.of(context)!.manageEvents,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          addEventScreenPageRoute,
                        );
                      },
                      buttonText: AppLocalizations.of(context)!.add,
                    ),

                    // Events List with modern cards
                    StreamBuilder<List<EventModel>>(
                      stream: context.read<ManagerEventsCubit>().eventsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return managerWaitingCircularIndicator();
                        } else if (snapshot.hasError) {
                          return managerSnapshotErrorWidget(
                            error: 'Error::  ${snapshot.error}',
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return managerNoEventsWidget();
                        }
                        return Column(
                          children: [
                            for (final event in snapshot.data!)
                              managerContentWidget(
                                context: context,
                                event: event,
                                addEventCubit: addEventCubit,
                                managerEventsCubit: cubit,
                              )
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
    );
  }
}
