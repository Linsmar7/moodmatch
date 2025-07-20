import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../models/project.dart';
import 'project_detail_screen.dart';

class ProjectsListScreen extends StatefulWidget {
  const ProjectsListScreen({super.key});

  @override
  _ProjectsListScreenState createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  void _showAddProjectDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Novo Projeto'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nome do Projeto'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Adicionar'),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newProject = Project(
                  id: DateTime.now().toString(),
                  name: nameController.text,
                );
                Provider.of<AppProvider>(context, listen: false).addProject(newProject);
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects = Provider.of<AppProvider>(context).projects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Projetos'),
      ),
      body: projects.isEmpty
          ? const Center(child: Text('Nenhum projeto criado.'))
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: projects.length,
        itemBuilder: (ctx, i) => Card(
          child: ListTile(
            leading: const Icon(Icons.folder),
            title: Text(projects[i].name),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProjectDetailScreen(project: projects[i]),
              ));
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProjectDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
