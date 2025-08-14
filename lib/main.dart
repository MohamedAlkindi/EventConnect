import 'dart:async';

import 'package:event_connect/core/cubit_provider/providers.dart';
import 'package:event_connect/core/firebase/config/firebase_options.dart';
import 'package:event_connect/core/localization/local_resoulution_callback.dart';
import 'package:event_connect/core/localization/localizations_delegates.dart';
import 'package:event_connect/core/localization/supported_locals.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/core/routes/routes.dart';
import 'package:event_connect/core/service/initialize_notifications.dart';
import 'package:event_connect/core/theme/app_theme.dart';
import 'package:event_connect/core/widgets/startup_widget.dart';
import 'package:event_connect/supabase_init.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This will determine which widget will be shown when the user opens the app.
late Widget startUpWidget;

// This variable will be used to store user model details of the signed in user.
UserModel? globalUserModel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initSupabase();
  // Initialize timezone and notifications
  await initializeNotification();
  startUpWidget = await whichWidget();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: getCubitProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: startUpWidget,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        localeResolutionCallback: localeResolutionCallbac,
        routes: routes,
      ),
    );
  }
}
