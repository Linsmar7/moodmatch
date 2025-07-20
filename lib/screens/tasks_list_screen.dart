import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/app_provider.dart';
import 'add_task_screen.dart';

class TasksListScreen extends StatelessWidget {
  const TasksListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<AppProvider>(context).tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas as Tarefas'),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('Nenhuma tarefa ainda. Adicione uma!'))
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: tasks.length,
        itemBuilder: (ctx, i) => Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(tasks[i].name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                '${tasks[i].category} - Vence em: ${DateFormat('dd/MM/yy').format(tasks[i].dueDate)}'),
            trailing: Text(tasks[i].priority, style: TextStyle(color: _getPriorityColor(tasks[i].priority))),
            onTap: () {
              // Mostrar detalhes da tarefa
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(tasks[i].name),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Descrição: ${tasks[i].description}'),
                          const SizedBox(height: 8),
                          Text('Humor Ideal: ${tasks[i].idealMood}'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Fechar'),
                        onPressed: () => Navigator.of(ctx).pop(),
                      )
                    ],
                  ));
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddTaskScreen(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.redAccent;
      case 'Média':
        return Colors.orangeAccent;
      case 'Baixa':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }
}
