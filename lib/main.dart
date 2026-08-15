import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/fitness_provider.dart';
import 'screens/dashboard_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FitnessProvider()..init(),
      child: MaterialApp(
        title: 'Fitness Tracker',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const DashboardScreen(),
      ),
    );
  }
}
