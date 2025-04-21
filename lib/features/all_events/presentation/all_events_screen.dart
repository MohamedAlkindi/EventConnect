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
  @override
  void initState() {
    super.initState();
    context.read<AllEventsCubit>().getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AllEventsCubit, AllEventsState>(
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
          }
        },
        builder: (context, state) {
          if (state is AllEventsGotEvents) {
            return ListView.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.events[index]['Name']),
                  subtitle: Text(state.events[index]['Description']),
                );
              },
            );
          } else if (state is AllEventsNoEventsYet) {
            return Center(
              child: Text("No Events Yet!"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
