import 'package:hive/hive.dart';

part 'mood_entry.g.dart';

@HiveType(typeId: 2)
class MoodEntry extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String mood;

  MoodEntry({required this.date, required this.mood});
}
