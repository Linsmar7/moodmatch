import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../providers/app_provider.dart';
import '../models/mood_entry.dart';

class MoodCalendarScreen extends StatefulWidget {
  const MoodCalendarScreen({super.key});

  @override
  _MoodCalendarScreenState createState() => _MoodCalendarScreenState();
}

class _MoodCalendarScreenState extends State<MoodCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<String, String> _moodsMap = {
    '😄 Feliz': '😄',
    '😢 Triste': '😢',
    '⚡ Produtivo': '⚡',
    '🧘 Relaxado': '🧘',
    '🤔 Pensativo': '🤔',
  };

  void _showAddMoodDialog(DateTime day, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Como você se sentiu em ${DateFormat('dd/MM/yyyy').format(day)}?'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: _moodsMap.keys.map((String key) {
              return ListTile(
                title: Text(key),
                onTap: () {
                  final newMood = MoodEntry(date: day, mood: _moodsMap[key]!);
                  appProvider.addOrUpdateMood(newMood);
                  Navigator.of(ctx).pop();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final moods = appProvider.moods;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário de Humor'),
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
              _showAddMoodDialog(selectedDay, appProvider);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final dateKey = DateTime(date.year, date.month, date.day);
                if (moods.containsKey(dateKey)) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Text(
                      moods[dateKey]!.mood,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
