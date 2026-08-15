import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';
import '../models/daily_goal.dart';

/// Handles all local persistence for the app using SharedPreferences.
///
/// Activities are stored as a JSON-encoded list under [_activitiesKey].
/// This keeps the app fully offline-capable. Swap this class out for a
/// Firestore-backed implementation later without touching the UI layer —
/// just keep the same method signatures.
class StorageService {
  static const _activitiesKey = 'fitness_activities';
  static const _goalKey = 'fitness_daily_goal';

  Future<List<Activity>> loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_activitiesKey);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => Activity.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<void> saveActivities(List<Activity> activities) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(activities.map((a) => a.toJson()).toList());
    await prefs.setString(_activitiesKey, encoded);
  }

  Future<DailyGoal> loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_goalKey);
    if (raw == null || raw.isEmpty) return const DailyGoal();
    return DailyGoal.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveGoal(DailyGoal goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalKey, jsonEncode(goal.toJson()));
  }
}
