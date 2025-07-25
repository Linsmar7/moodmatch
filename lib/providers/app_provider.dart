import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/project.dart';
import '../models/mood_entry.dart';

class AppProvider with ChangeNotifier {
  final List<Project> _projects = [
    Project(id: 'p1', name: 'App Flutter Pessoal'),
    Project(id: 'p2', name: 'Estudos de Fim de Ano'),
  ];

  final List<Task> _tasks = [
    Task(
      id: 't1',
      name: 'Configurar ambiente Flutter',
      category: 'Desenvolvimento',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      idealMood: 'Focado',
      priority: 'Alta',
      description: 'Instalar Flutter SDK, Android Studio e configurar emuladores.',
      projectId: 'p1',
    ),
    Task(
      id: 't2',
      name: 'Ler documentação do Provider',
      category: 'Estudo',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      idealMood: 'Curioso',
      priority: 'Média',
      description: 'Entender como o Provider funciona para gerenciamento de estado.',
      projectId: 'p2',
    ),
  ];

  final Map<DateTime, MoodEntry> _moods = {};

  List<Project> get projects => [..._projects];
  List<Task> get tasks => [..._tasks];
  Map<DateTime, MoodEntry> get moods => {..._moods};

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.removeWhere((t) => t.id == task.id);
    notifyListeners();
  }
  void deleteProject(Project project) {
  _projects.removeWhere((p) => p.id == project.id);

  _tasks.removeWhere((t) => t.projectId == project.id);

  notifyListeners();
}



  void addOrUpdateMood(MoodEntry moodEntry) {
    // Normaliza a data para ignorar a hora
    final dateKey = DateTime(moodEntry.date.year, moodEntry.date.month, moodEntry.date.day);
    _moods[dateKey] = moodEntry;
    notifyListeners();
  }

  List<Task> getTasksForProject(String projectId) {
    return _tasks.where((task) => task.projectId == projectId).toList();
  }
}
