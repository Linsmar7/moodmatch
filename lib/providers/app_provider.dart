import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/project.dart';
import '../models/mood_entry.dart';

class AppProvider with ChangeNotifier {
  // Agora, em vez de listas, temos referências para as "caixas" do Hive
  late Box<Project> _projectsBox;
  late Box<Task> _tasksBox;
  late Box<MoodEntry> _moodsBox;

  // No construtor, inicializamos as caixas e carregamos os dados
  AppProvider() {
    _projectsBox = Hive.box<Project>('projects');
    _tasksBox = Hive.box<Task>('tasks');
    _moodsBox = Hive.box<MoodEntry>('moods');
  }

  // Os getters agora leem diretamente das caixas do Hive
  List<Project> get projects => _projectsBox.values.toList();
  List<Task> get tasks => _tasksBox.values.toList();
  // Para os humores, convertemos para um Map como antes
  Map<DateTime, MoodEntry> get moods {
    final moodMap = <DateTime, MoodEntry>{};
    for (var mood in _moodsBox.values) {
      final dateKey = DateTime(mood.date.year, mood.date.month, mood.date.day);
      moodMap[dateKey] = mood;
    }
    return moodMap;
  }

  // Os métodos de adição agora salvam no Hive. O Hive usa uma chave (key) para cada item.
  // Usaremos o ID do objeto como chave.
  void addProject(Project project) {
    _projectsBox.put(project.id, project);
    notifyListeners();
  }

  void addTask(Task task) {
    _tasksBox.put(task.id, task);
    notifyListeners();
  }

  void addOrUpdateMood(MoodEntry moodEntry) {
    // A chave para o humor será a data formatada, para garantir que só haja um por dia
    final key = moodEntry.date.toIso8601String().substring(0, 10);
    _moodsBox.put(key, moodEntry);
    notifyListeners();
  }

  // Os métodos de exclusão removem do Hive pela chave
  void deleteProject(Project project) {
    // Remove todas as tarefas associadas ao projeto
    final tasksToDelete = _tasksBox.values.where((task) => task.projectId == project.id).toList();
    for (var task in tasksToDelete) {
      _tasksBox.delete(task.id);
    }

    // Remove o projeto
    _projectsBox.delete(project.id);

    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasksBox.delete(task.id);
    notifyListeners();
  }

  List<Task> getTasksForProject(String projectId) {
    return _tasksBox.values.where((task) => task.projectId == projectId).toList();
  }
}
