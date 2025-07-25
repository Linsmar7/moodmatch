import 'package:hive/hive.dart';

// Importa o arquivo que será gerado pelo build_runner
part 'task.g.dart';

@HiveType(typeId: 0) // typeId deve ser único por modelo
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final String idealMood;

  @HiveField(5)
  final String priority;

  @HiveField(6)
  final String description;

  @HiveField(7)
  String? projectId;

  Task({
    required this.id,
    required this.name,
    required this.category,
    required this.dueDate,
    required this.idealMood,
    required this.priority,
    required this.description,
    this.projectId,
  });
}
