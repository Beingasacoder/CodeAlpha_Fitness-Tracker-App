enum ActivityType { walking, running, cycling, gym, yoga, swimming, sports, other }

extension ActivityTypeX on ActivityType {
  String get label {
    switch (this) {
      case ActivityType.walking:
        return 'Walking';
      case ActivityType.running:
        return 'Running';
      case ActivityType.cycling:
        return 'Cycling';
      case ActivityType.gym:
        return 'Gym / Strength';
      case ActivityType.yoga:
        return 'Yoga';
      case ActivityType.swimming:
        return 'Swimming';
      case ActivityType.sports:
        return 'Sports';
      case ActivityType.other:
        return 'Other';
    }
  }

  static ActivityType fromString(String value) {
    return ActivityType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ActivityType.other,
    );
  }
}

/// A single logged fitness activity (a workout, a walk, etc.)
class Activity {
  final String id;
  final ActivityType type;
  final int durationMinutes;
  final int caloriesBurned;
  final int steps;
  final DateTime dateTime;
  final String? note;

  Activity({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.steps = 0,
    required this.dateTime,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'durationMinutes': durationMinutes,
        'caloriesBurned': caloriesBurned,
        'steps': steps,
        'dateTime': dateTime.toIso8601String(),
        'note': note,
      };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'] as String,
        type: ActivityTypeX.fromString(json['type'] as String),
        durationMinutes: json['durationMinutes'] as int,
        caloriesBurned: json['caloriesBurned'] as int,
        steps: (json['steps'] as int?) ?? 0,
        dateTime: DateTime.parse(json['dateTime'] as String),
        note: json['note'] as String?,
      );

  bool isSameDay(DateTime day) =>
      dateTime.year == day.year && dateTime.month == day.month && dateTime.day == day.day;
}
