import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/calendar/presentation/bloc/calendar_bloc.dart';
import 'firebase_options.dart';
import 'utils/printlog.dart';

void main() {
  runZonedGuarded(
    () async {
      usePathUrlStrategy();
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      runApp(
        MultiBlocProvider(
          providers: [BlocProvider(create: (_) => CalendarBloc())],
          child: const MyApp(),
        ),
      );
    },
    (e, s) {
      printLog('[runZonedGuarded] error: $e, stackTrace: $s');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRoute,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // darkTheme: AppTheme.dark,
      title: 'Vyne',
    );
  }
}
