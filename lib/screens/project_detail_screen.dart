import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/app_provider.dart';
import '../models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    // Usamos 'watch' aqui para reconstruir se a lista de tarefas mudar
    final tasksForProject = Provider.of<AppProvider>(context).getTasksForProject(project.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: tasksForProject.isEmpty
          ? const Center(child: Text('Nenhuma tarefa neste projeto.'))
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: tasksForProject.length,
        itemBuilder: (ctx, i) => Card(
          child: ListTile(
            title: Text(tasksForProject[i].name),
            subtitle: Text('Vence em: ${DateFormat('dd/MM/yy').format(tasksForProject[i].dueDate)}'),
          ),
        ),
      ),
    );
  }
}
