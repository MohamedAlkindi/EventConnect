import 'package:event_connect/core/firebase/config/firebase_options.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/theme/app_theme.dart';
import 'package:event_connect/features/attendee/all_events/presentation/all_events_screen.dart';
import 'package:event_connect/features/attendee/all_events/presentation/cubit/all_events_cubit.dart';
import 'package:event_connect/features/attendee/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/cubit/my_events_cubit.dart';
import 'package:event_connect/features/attendee/my_events/presentation/my_events_screen.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/cubit/my_profile_cubit.dart';
import 'package:event_connect/features/attendee/my_profile/presentation/my_profile_screen.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/cubit/user_homescreen_cubit.dart';
import 'package:event_connect/features/attendee/user_homescreen/presentation/user_homescreen.dart';
import 'package:event_connect/features/complete_profile/presentation/complete_profile_screen.dart';
import 'package:event_connect/features/email_confirmation/presentation/cubit/email_confirmation_cubit.dart';
import 'package:event_connect/features/email_confirmation/presentation/email_confirmation_screen.dart';
import 'package:event_connect/features/forgot_password/presentaion/cubit/reset_password_cubit.dart';
import 'package:event_connect/features/forgot_password/presentaion/forgot_password_screen.dart';
import 'package:event_connect/features/forgot_password/presentaion/reset_pass_confirmation_screen.dart';
import 'package:event_connect/features/login/presentation/cubit/login_cubit.dart';
import 'package:event_connect/features/login/presentation/login_screen.dart';
import 'package:event_connect/features/manager/manager_edit_profile/presentation/cubit/manager_edit_profile_cubit.dart';
import 'package:event_connect/features/manager/manager_events/presentation/add_event_screen.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/add_event_cubit.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/edit_event_cubit.dart';
import 'package:event_connect/features/manager/manager_events/presentation/cubit/manager_events_cubit.dart';
import 'package:event_connect/features/manager/manager_homescreen/presentation/cubit/manager_homescreen_cubit.dart';
import 'package:event_connect/features/manager/manager_homescreen/presentation/manager_homescreen.dart';
import 'package:event_connect/features/manager/manager_profile/presentation/cubit/manager_profile_cubit.dart';
import 'package:event_connect/features/register/presentation/cubit/register_cubit.dart';
import 'package:event_connect/features/register/presentation/register_screen.dart';
import 'package:event_connect/features/welcome_screen/presentation/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:event_connect/core/service/notification_service.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String loginPageRoute = '/LoginPage';
const String registerPageRoute = '/RegisterPage';
const String forgotPasswordPageRoute = '/ForgotPasswordScreen';
const String resetPasswordConfirmationPageRoute =
    '/ResetPasswordConfirmationPage';
const String completeProfileInfoScreenRoute = '/CompleteProfileScreenView';
const String attendeeHomeScreenPageRoute = '/UserHomeScreen';
const String allEventsRoute = '/AllEventsScreen';
const String myEventsRoute = '/MyEventsScreen';
const String attendeeProfileRoute = '/MyProfileScreen';
const String emailConfirmationnRoute = '/EmailConfirmationScreen';
const String managerHomeScreenPageRoute = '/ManagerHomescreen';
const String addEventScreenPageRoute = '/AddEventScreen';

late Widget startUpWidget;

Future<Widget> whichWidget() async {
  final user = FirebaseUser();

  if (user.getUser == null) {
    return WelcomeScreen();
  }
  if (!await user.isVerified) {
    return EmailConfirmationScreen();
  }
  if (!await user.isUserDataCompleted()) {
    return CompleteProfileScreen();
  }
  final role = await user.getUserRole();
  if (role == "Attendee") {
    return UserHomeScreen();
  }
  if (role == "Manager") {
    return ManagerHomescreen();
  }
  return WelcomeScreen();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
      url: 'https://mretvbuvvmcbjdivlogc.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1yZXR2YnV2dm1jYmpkaXZsb2djIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0NTM0MzgsImV4cCI6MjA2NjAyOTQzOH0.xPz552lN_TfgO1RX7CjHYheRJ04nmio0WV_Z6Yw-7Fw');

  // Initialize timezone and notifications
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Request notification permissions (Android 13+ and iOS)
  if (Platform.isAndroid && (await _getAndroidSdkInt()) >= 33) {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  startUpWidget = await whichWidget();
  runApp(const MainApp());
}

Future<int> _getAndroidSdkInt() async {
  try {
    final methodChannel = const MethodChannel('com.example.Event_Connect/info');
    final int sdkInt = await methodChannel.invokeMethod('getAndroidSdkInt');
    return sdkInt;
  } catch (_) {
    return 0;
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ManagerEventsCubit()..getAllEvents(forceRefresh: false),
        ),
        BlocProvider(
          create: (context) =>
              AddEventCubit(context.read<ManagerEventsCubit>()),
        ),
        BlocProvider(
          create: (context) =>
              EditEventCubit(context.read<ManagerEventsCubit>()),
        ),
        BlocProvider(
          create: (context) =>
              AllEventsCubit()..getAllEvents(forceRefresh: false),
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
          create: (context) => MyProfileCubit()..getUserPic(),
        ),
        BlocProvider(
          create: (context) =>
              ManagerProfileCubit()..getManagerPicAndLocation(),
        ),
        BlocProvider(
          create: (context) => ManagerEditProfileCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: startUpWidget,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        routes: {
          loginPageRoute: (context) => LoginPage(),
          registerPageRoute: (context) => RegisterPage(),
          forgotPasswordPageRoute: (context) => ForgotPasswordScreen(),
          resetPasswordConfirmationPageRoute: (context) =>
              ResetPasswordConfirmationPage(),
          completeProfileInfoScreenRoute: (context) => CompleteProfileScreen(),
          attendeeHomeScreenPageRoute: (context) => UserHomeScreen(),
          allEventsRoute: (context) => AllEventsScreen(),
          myEventsRoute: (context) => MyEventsScreen(),
          attendeeProfileRoute: (context) => MyProfileScreen(),
          emailConfirmationnRoute: (context) => EmailConfirmationScreen(),
          managerHomeScreenPageRoute: (context) => ManagerHomescreen(),
          addEventScreenPageRoute: (context) => AddEventScreen(),
        },
      ),
    );
  }
}
