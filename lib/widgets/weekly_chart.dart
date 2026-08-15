import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/fitness_provider.dart';
import '../utils/app_theme.dart';

/// Bar chart of calories burned per day for the last 7 days.
class WeeklyChart extends StatelessWidget {
  final List<DayStats> stats;
  final int caloriesGoal;

  const WeeklyChart({super.key, required this.stats, required this.caloriesGoal});

  @override
  Widget build(BuildContext context) {
    final maxY = [
      caloriesGoal.toDouble(),
      ...stats.map((s) => s.calories.toDouble()),
    ].reduce((a, b) => a > b ? a : b) *
        1.2;

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: maxY <= 0 ? 100 : maxY,
          alignment: BarChartAlignment.spaceAround,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppColors.textPrimary,
              getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
                '${rod.toY.round()} kcal',
                const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= stats.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('E').format(stats[index].date).substring(0, 1),
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(stats.length, (i) {
            final day = stats[i];
            final metGoal = day.calories >= caloriesGoal;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: day.calories.toDouble(),
                  color: metGoal ? AppColors.primary : AppColors.calories,
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
