import 'package:flutter/material.dart';
import 'tasks_list_screen.dart';
import 'projects_list_screen.dart';
import 'mood_calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TasksListScreen(),
    ProjectsListScreen(),
    MoodCalendarScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open_outlined),
            label: 'Projetos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Humor',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.tealAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
