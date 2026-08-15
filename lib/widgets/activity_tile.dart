import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../utils/app_theme.dart';

IconData iconForActivity(ActivityType type) {
  switch (type) {
    case ActivityType.walking:
      return Icons.directions_walk;
    case ActivityType.running:
      return Icons.directions_run;
    case ActivityType.cycling:
      return Icons.directions_bike;
    case ActivityType.gym:
      return Icons.fitness_center;
    case ActivityType.yoga:
      return Icons.self_improvement;
    case ActivityType.swimming:
      return Icons.pool;
    case ActivityType.sports:
      return Icons.sports_basketball;
    case ActivityType.other:
      return Icons.bolt;
  }
}

class ActivityTile extends StatelessWidget {
  final Activity activity;
  final VoidCallback? onDelete;

  const ActivityTile({super.key, required this.activity, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconForActivity(activity.type), color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.type.label,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${activity.durationMinutes} min · ${activity.caloriesBurned} kcal'
                    '${activity.steps > 0 ? ' · ${activity.steps} steps' : ''}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  if (activity.note != null && activity.note!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      activity.note!,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('h:mm a').format(activity.dateTime),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.danger),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
