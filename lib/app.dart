import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/router.dart';

class CopiaOSApp extends StatelessWidget {
  const CopiaOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CopiaOS',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
    );
  }
}
