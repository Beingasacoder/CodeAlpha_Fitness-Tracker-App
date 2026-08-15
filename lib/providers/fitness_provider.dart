import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/activity.dart';
import '../models/daily_goal.dart';
import '../services/storage_service.dart';

/// Central app state: owns the activity log and daily goals, and exposes
/// derived stats (today's totals, weekly totals) to the UI.
class FitnessProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final _uuid = const Uuid();

  List<Activity> _activities = [];
  DailyGoal _goal = const DailyGoal();
  bool _isLoading = true;

  List<Activity> get activities => _activities;
  DailyGoal get goal => _goal;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _activities = await _storage.loadActivities();
    _goal = await _storage.loadGoal();
    _isLoading = false;
    notifyListeners();
  }

  // ---- Mutations ----------------------------------------------------

  Future<void> addActivity({
    required ActivityType type,
    required int durationMinutes,
    required int caloriesBurned,
    int steps = 0,
    DateTime? dateTime,
    String? note,
  }) async {
    final activity = Activity(
      id: _uuid.v4(),
      type: type,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      steps: steps,
      dateTime: dateTime ?? DateTime.now(),
      note: note,
    );
    _activities.insert(0, activity);
    _activities.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    await _storage.saveActivities(_activities);
    notifyListeners();
  }

  Future<void> deleteActivity(String id) async {
    _activities.removeWhere((a) => a.id == id);
    await _storage.saveActivities(_activities);
    notifyListeners();
  }

  Future<void> updateGoal(DailyGoal newGoal) async {
    _goal = newGoal;
    await _storage.saveGoal(_goal);
    notifyListeners();
  }

  // ---- Derived stats --------------------------------------------------

  List<Activity> activitiesForDay(DateTime day) =>
      _activities.where((a) => a.isSameDay(day)).toList();

  int totalStepsForDay(DateTime day) =>
      activitiesForDay(day).fold(0, (sum, a) => sum + a.steps);

  int totalCaloriesForDay(DateTime day) =>
      activitiesForDay(day).fold(0, (sum, a) => sum + a.caloriesBurned);

  int totalMinutesForDay(DateTime day) =>
      activitiesForDay(day).fold(0, (sum, a) => sum + a.durationMinutes);

  int get todaySteps => totalStepsForDay(DateTime.now());
  int get todayCalories => totalCaloriesForDay(DateTime.now());
  int get todayMinutes => totalMinutesForDay(DateTime.now());

  /// Returns the last 7 days (oldest first) with each day's total calories,
  /// steps, and active minutes — used to feed the weekly bar chart.
  List<DayStats> weeklyStats() {
    final today = DateTime.now();
    final days = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));
    return days
        .map((d) => DayStats(
              date: d,
              steps: totalStepsForDay(d),
              calories: totalCaloriesForDay(d),
              minutes: totalMinutesForDay(d),
            ))
        .toList();
  }

  double get weeklyGoalCompletionRate {
    final stats = weeklyStats();
    if (stats.isEmpty) return 0;
    final metDays = stats.where((d) => d.calories >= _goal.caloriesGoal).length;
    return metDays / stats.length;
  }
}

class DayStats {
  final DateTime date;
  final int steps;
  final int calories;
  final int minutes;

  DayStats({
    required this.date,
    required this.steps,
    required this.calories,
    required this.minutes,
  });
}
