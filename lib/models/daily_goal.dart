/// User-configurable daily targets used to compute progress bars.
class DailyGoal {
  final int stepsGoal;
  final int caloriesGoal;
  final int activeMinutesGoal;

  const DailyGoal({
    this.stepsGoal = 8000,
    this.caloriesGoal = 500,
    this.activeMinutesGoal = 45,
  });

  Map<String, dynamic> toJson() => {
        'stepsGoal': stepsGoal,
        'caloriesGoal': caloriesGoal,
        'activeMinutesGoal': activeMinutesGoal,
      };

  factory DailyGoal.fromJson(Map<String, dynamic> json) => DailyGoal(
        stepsGoal: (json['stepsGoal'] as int?) ?? 8000,
        caloriesGoal: (json['caloriesGoal'] as int?) ?? 500,
        activeMinutesGoal: (json['activeMinutesGoal'] as int?) ?? 45,
      );

  DailyGoal copyWith({int? stepsGoal, int? caloriesGoal, int? activeMinutesGoal}) => DailyGoal(
        stepsGoal: stepsGoal ?? this.stepsGoal,
        caloriesGoal: caloriesGoal ?? this.caloriesGoal,
        activeMinutesGoal: activeMinutesGoal ?? this.activeMinutesGoal,
      );
}
