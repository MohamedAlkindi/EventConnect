import 'package:event_connect/core/database/database.dart';
import 'package:event_connect/core/firebase/config/firebase_options.dart';
import 'package:event_connect/features/register/presentation/cubit/register_cubit.dart';
import 'package:event_connect/features/register/presentation/personal_info_screen.dart';
import 'package:event_connect/features/register/presentation/register_screen.dart';
import 'package:event_connect/features/welcome_screen/presentation/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String registerPageRoute = '/RegisterPage';
String personalInfoScreen = '/PersonalInfoScreen';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppDatabase.initializeDB();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
        routes: {
          registerPageRoute: (context) => RegisterPage(),
          personalInfoScreen: (context) => PersonalInfoScreen(),
        },
      ),
    );
  }
}
