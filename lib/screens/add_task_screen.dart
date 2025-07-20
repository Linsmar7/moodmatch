import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/app_provider.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  DateTime? _selectedDate;
  String? _selectedMood;
  String? _selectedPriority;
  String? _selectedProject;

  final List<String> _categories = ['Trabalho', 'Estudo', 'Pessoal', 'Desenvolvimento'];
  final List<String> _moods = ['Focado', 'Relaxado', 'Energizado', 'Criativo', 'Curioso'];
  final List<String> _priorities = ['Baixa', 'Média', 'Alta'];

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _submitData() {
    if (_formKey.currentState!.validate() &&
        _selectedCategory != null &&
        _selectedDate != null &&
        _selectedMood != null &&
        _selectedPriority != null) {
      final newTask = Task(
        id: DateTime.now().toString(),
        name: _nameController.text,
        category: _selectedCategory!,
        dueDate: _selectedDate!,
        idealMood: _selectedMood!,
        priority: _selectedPriority!,
        description: _descriptionController.text,
        projectId: _selectedProject,
      );
      Provider.of<AppProvider>(context, listen: false).addTask(newTask);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, preencha todos os campos obrigatórios.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects = Provider.of<AppProvider>(context).projects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Nova Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome da Tarefa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildDropdown('Categoria', _selectedCategory, _categories, (val) {
                setState(() => _selectedCategory = val);
              }),
              _buildDropdown('Humor Ideal', _selectedMood, _moods, (val) {
                setState(() => _selectedMood = val);
              }),
              _buildDropdown('Prioridade', _selectedPriority, _priorities, (val) {
                setState(() => _selectedPriority = val);
              }),
              DropdownButtonFormField<String>(
                value: _selectedProject,
                hint: const Text('Selecione um Projeto (Opcional)'),
                items: projects.map((project) {
                  return DropdownMenuItem(
                    value: project.id,
                    child: Text(project.name),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => _selectedProject = val);
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Nenhuma data escolhida!'
                          : 'Data Final: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text(
                      'Escolher Data',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Adicionar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? selectedValue, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: Text('Selecione $label'),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Campo obrigatório' : null,
    );
  }
}
