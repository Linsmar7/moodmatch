import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'models/task.dart';
import 'models/project.dart';
import 'models/mood_entry.dart';

Future<void> main() async {
  // Garante que os bindings do Flutter foram inicializados antes de qualquer outra coisa
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive
  await Hive.initFlutter();

  // Registra os adaptadores que geramos
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(MoodEntryAdapter());

  // Abre as "caixas" (boxes) do Hive onde os dados serão armazenados
  await Hive.openBox<Project>('projects');
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<MoodEntry>('moods');

  // Inicializa a localização para o calendário
  initializeDateFormatting('pt_BR', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: 'Gestor de Tarefas e Humor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          cardColor: const Color(0xFF1E1E1E),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
