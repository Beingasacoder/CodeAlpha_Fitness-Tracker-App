import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../providers/fitness_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/activity_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Map<String, List<Activity>> _groupByDay(List<Activity> activities) {
    final Map<String, List<Activity>> grouped = {};
    for (final a in activities) {
      final key = DateFormat('yyyy-MM-dd').format(a.dateTime);
      grouped.putIfAbsent(key, () => []).add(a);
    }
    return grouped;
  }

  String _friendlyDayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('EEEE, MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FitnessProvider>();
    final grouped = _groupByDay(provider.activities);
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: provider.activities.isEmpty
          ? const Center(
              child: Text(
                'No activities logged yet.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                final key = sortedKeys[index];
                final dayActivities = grouped[key]!;
                final dayTotalCalories = dayActivities.fold(0, (s, a) => s + a.caloriesBurned);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _friendlyDayLabel(dayActivities.first.dateTime),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          Text(
                            '$dayTotalCalories kcal total',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...dayActivities.map(
                        (a) => ActivityTile(
                          activity: a,
                          onDelete: () => provider.deleteActivity(a.id),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
