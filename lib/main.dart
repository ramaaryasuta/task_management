import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'utils/printlog.dart';

void main() {
  runZonedGuarded(
    () {
      usePathUrlStrategy();
      WidgetsFlutterBinding.ensureInitialized();

      runApp(const MyApp());
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final designSize = _resolveDesignSize(constraints.maxWidth);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              routerConfig: appRoute,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              // darkTheme: AppTheme.dark,
              title: 'Vyne',
            );
          },
        );
      },
    );
  }

  Size _resolveDesignSize(double width) {
    if (width < 600) {
      return const Size(375, 812); // mobile
    } else if (width < 900) {
      return const Size(768, 1024); // tablet
    } else {
      return const Size(1440, 900); // desktop
    }
  }
}
