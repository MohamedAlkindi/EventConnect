import 'dart:async';

import 'package:event_connect/core/service/notification_service.dart';
import 'package:event_connect/features/attendee/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:event_connect/features/attendee/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/cubit/my_events_cubit.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/cubit/user_homescreen_cubit.dart';
import 'package:event_connect/features/authentication/email_confirmation/presentation/cubit/email_confirmation_cubit.dart';
import 'package:event_connect/features/authentication/forgot_password/presentaion/cubit/reset_password_cubit.dart';
import 'package:event_connect/features/authentication/login/presentation/cubit/login_cubit.dart';
import 'package:event_connect/features/authentication/register/presentation/cubit/register_cubit.dart';
import 'package:event_connect/features/manager/manager_edit_profile/presentation/cubit/manager_edit_profile_cubit.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/add_event_cubit.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/edit_event_cubit.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/manager_events_cubit.dart';
import 'package:event_connect/features/manager/manager_homescreen/presentation/cubit/manager_homescreen_cubit.dart';
import 'package:event_connect/features/manager/manager_profile/presentation/cubit/manager_profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> getCubitProviders() {
  return [
    BlocProvider<ManagerEventsCubit>(
      create: (context) =>
          ManagerEventsCubit()..getAllEvents(forceRefresh: false),
    ),
    BlocProvider(
      create: (context) => AddEventCubit(context.read<ManagerEventsCubit>()),
    ),
    BlocProvider(
      create: (context) => EditEventCubit(context.read<ManagerEventsCubit>()),
    ),
    BlocProvider(
      create: (context) => AllEventsCubit()..getAllEvents(forceRefresh: false),
    ),
    BlocProvider(
      create: (context) => UserHomescreenCubit(),
    ),
    BlocProvider(
      create: (context) {
        final cubit = MyEventsCubit()
          ..getAllEventsByUserID(forceRefresh: false);
        // Attach notification listener
        NotificationEventListener(cubit.eventsStream);
        // Periodically refresh events every 5 minutes
        Timer.periodic(const Duration(minutes: 5), (_) {
          cubit.forceRefreshEvents();
        });
        return cubit;
      },
    ),
    BlocProvider(
      create: (context) => ManagerHomescreenCubit(),
    ),
    BlocProvider(
      create: (context) => LoginCubit(),
    ),
    BlocProvider(
      create: (context) => RegisterCubit(),
    ),
    BlocProvider(
      create: (context) => ResetPasswordCubit(),
    ),
    BlocProvider(
      create: (context) => EditProfileCubit(),
    ),
    BlocProvider(
      create: (context) => EmailConfirmationCubit(),
    ),
    BlocProvider(
      create: (context) => MyProfileCubit()..getUserInfo(editedUserModel: null),
    ),
    BlocProvider(
      create: (context) =>
          ManagerProfileCubit()..getManagerInfo(updatedManagerModel: null),
    ),
    BlocProvider(
      create: (context) => ManagerEditProfileCubit(),
    ),
  ];
}
