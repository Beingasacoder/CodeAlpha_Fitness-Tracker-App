# Fitness Tracker App (Flutter)

A simple, clean fitness tracker: log workouts manually, see a daily/weekly
dashboard with progress bars and a calories chart. Built MVVM-style with
Provider for state and SharedPreferences for local storage — same pattern
as your flashcard app, so it should feel familiar.

## Features
- Manually log activities: type, duration, calories, steps, time, note
- Dashboard: today's steps / calories / active minutes / workout count,
  each as a progress bar against a configurable daily goal
- Weekly bar chart of calories burned (fl_chart), green bars = goal met
- Full history screen, grouped by day, with delete
- Editable daily goals (steps / calories / minutes)
- 100% offline — all data stored locally with `shared_preferences`

## Project structure
```
lib/
  models/          Activity, DailyGoal — plain Dart classes with toJson/fromJson
  services/        StorageService — all SharedPreferences read/write lives here
  providers/       FitnessProvider — app state + derived stats (ChangeNotifier)
  screens/         DashboardScreen, AddActivityScreen, HistoryScreen, GoalSettingsScreen
  widgets/         StatProgressCard, ActivityTile, WeeklyChart — reusable UI
  utils/           app_theme.dart — colors & ThemeData in one place
```

## Setup
```bash
flutter pub get
flutter run
```

Requires Flutter 3.x. Dependencies: `provider`, `shared_preferences`,
`fl_chart`, `intl`, `uuid`.

## Swapping in Firebase later
Everything touching storage goes through `StorageService`
(`lib/services/storage_service.dart`). To move to Firestore:
1. Add `cloud_firestore` / `firebase_core` and run `flutterfire configure`.
2. Create a `FirestoreStorageService` implementing the same four methods
   (`loadActivities`, `saveActivities`, `loadGoal`, `saveGoal`).
3. Swap the `StorageService()` instantiation in `FitnessProvider` for the
   Firestore version. No screen or widget code needs to change.

## Notes
- Steps are entered manually per activity (no pedometer/health-API
  integration). If you want automatic step tracking later, that would need
  the `pedometer` or `health` package plus platform permissions — happy to
  add that as a follow-up.
- Chart currently shows calories; steps/minutes could be added as toggleable
  chart views if useful.
