import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ComsatsCgpaPredictorApp());
}

/// Root widget for the COMSATS CGPA Predictor.
///
/// Deliberately thin: theming lives in [AppTheme], the only screen in
/// the MVP lives in [HomeScreen], and app-wide copy lives in
/// [AppStrings]. This keeps main.dart stable as the app grows (new
/// routes can be added to [MaterialApp.routes] without touching
/// anything else here).
class ComsatsCgpaPredictorApp extends StatelessWidget {
  const ComsatsCgpaPredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
