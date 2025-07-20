class Task {
  final String id;
  final String name;
  final String category;
  final DateTime dueDate;
  final String idealMood;
  final String priority;
  final String description;
  String? projectId; // Pode ser nulo se não pertencer a um projeto

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
