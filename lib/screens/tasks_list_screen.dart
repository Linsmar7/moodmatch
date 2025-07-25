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
              itemBuilder: (ctx, i) {
                final appProvider = Provider.of<AppProvider>(context, listen: false);
                final task = tasks[i];

                return Dismissible(
                  key: Key(task.name + task.dueDate.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    appProvider.deleteTask(task);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tarefa "${task.name}" removida')),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(task.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        '${task.category} - Vence em: ${DateFormat('dd/MM/yy').format(task.dueDate)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(task.priority, style: TextStyle(color: _getPriorityColor(task.priority))),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              appProvider.deleteTask(task);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Tarefa "${task.name}" removida')),
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(task.name),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Descrição: ${task.description}'),
                                  const SizedBox(height: 8),
                                  Text('Humor Ideal: ${task.idealMood}'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Fechar'),
                                onPressed: () => Navigator.of(ctx).pop(),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
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
