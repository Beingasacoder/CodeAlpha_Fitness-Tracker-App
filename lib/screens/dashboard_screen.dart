import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/stat_progress_card.dart';
import '../widgets/weekly_chart.dart';
import '../widgets/activity_tile.dart';
import 'add_activity_screen.dart';
import 'goal_settings_screen.dart';
import 'history_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FitnessProvider>();
    final goal = provider.goal;
    final today = DateTime.now();
    final todayActivities = provider.activitiesForDay(today);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'Daily goals',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GoalSettingsScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Log activity'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddActivityScreen()),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.init,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                children: [
                  Text(
                    DateFormat('EEEE, MMM d').format(today),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  // Today's stat cards
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.35,
                    children: [
                      StatProgressCard(
                        label: 'Steps',
                        icon: Icons.directions_walk,
                        color: AppColors.steps,
                        current: provider.todaySteps,
                        goal: goal.stepsGoal,
                        unit: 'steps',
                      ),
                      StatProgressCard(
                        label: 'Calories',
                        icon: Icons.local_fire_department,
                        color: AppColors.calories,
                        current: provider.todayCalories,
                        goal: goal.caloriesGoal,
                        unit: 'kcal',
                      ),
                      StatProgressCard(
                        label: 'Active time',
                        icon: Icons.timer_outlined,
                        color: AppColors.minutes,
                        current: provider.todayMinutes,
                        goal: goal.activeMinutesGoal,
                        unit: 'min',
                      ),
                      StatProgressCard(
                        label: 'Workouts',
                        icon: Icons.check_circle_outline,
                        color: AppColors.primary,
                        current: todayActivities.length,
                        goal: 3,
                        unit: 'logged',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Weekly progress card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Weekly calories',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                              Text(
                                '${(provider.weeklyGoalCompletionRate * 100).round()}% goal days',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          WeeklyChart(
                            stats: provider.weeklyStats(),
                            caloriesGoal: goal.caloriesGoal,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Today's activities",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HistoryScreen()),
                        ),
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (todayActivities.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Column(
                          children: const [
                            Icon(Icons.self_improvement, size: 40, color: AppColors.textSecondary),
                            SizedBox(height: 8),
                            Text(
                              'No activity logged yet today.\nTap "Log activity" to add one.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...todayActivities.map(
                      (a) => ActivityTile(
                        activity: a,
                        onDelete: () => provider.deleteActivity(a.id),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
