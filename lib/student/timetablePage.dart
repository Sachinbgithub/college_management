import 'package:flutter/material.dart';

class TimetableEntry {
  final String subject;
  final String faculty;
  final String classroom; // Added classroom
  final DateTime startTime;
  final DateTime endTime;
  final bool isBreak; // Added break indicator
  final bool isLunch; // Added lunch indicator

  TimetableEntry({
    required this.subject,
    required this.faculty,
    required this.classroom,
    required this.startTime,
    required this.endTime,
    this.isBreak = false,
    this.isLunch = false,
  });

  String getFormattedTime() {
    String startTimeStr =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    String endTimeStr =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$startTimeStr - $endTimeStr';
  }
}

class TimetablePage extends StatelessWidget {
  // Dummy timetable data
  final List<TimetableEntry> timetable = [
    TimetableEntry(
      subject: 'Data Structures',
      faculty: 'Prof. A. Borle',
      classroom: 'Room 201',
      startTime: DateTime(2025, 2, 17, 9, 0),
      endTime: DateTime(2025, 2, 17, 10, 0),
    ),
    TimetableEntry(
      subject: 'Break', // Representing break time
      faculty: '',
      classroom: '',
      startTime: DateTime(2025, 2, 17, 10, 0),
      endTime: DateTime(2025, 2, 17, 10, 15),
      isBreak: true,
    ),
    TimetableEntry(
      subject: 'Computer Graphics',
      faculty: 'Prof. R. Phopale',
      classroom: 'Room 202',
      startTime: DateTime(2025, 2, 17, 10, 15),
      endTime: DateTime(2025, 2, 17, 11, 15),
    ),
    TimetableEntry(
      subject: 'Lunch', // Representing Lunch time
      faculty: '',
      classroom: 'Cafeteria',
      startTime: DateTime(2025, 2, 17, 12, 30),
      endTime: DateTime(2025, 2, 17, 13, 30),
      isLunch: true,
    ),
    TimetableEntry(
      subject: 'Computer Networks',
      faculty: 'Prof. Sonali Samrat ',
      classroom: 'Room 203',
      startTime: DateTime(2025, 2, 17, 13, 30),
      endTime: DateTime(2025, 2, 17, 14, 30),
    ),
  ];

  TimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable'),
      ),
      body: ListView.builder(
        itemCount: timetable.length,
        itemBuilder: (context, index) {
          final entry = timetable[index];

          return Card(
            margin: EdgeInsets.all(8.0),
            color: entry.isBreak
                ? Colors.yellow[100]
                : entry.isLunch
                ? Colors.green[100]
                : null, // Highlight breaks & lunch
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (entry.isBreak) ...[
                    Text(
                      'Break Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    Text(
                      entry.getFormattedTime(),
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ] else if (entry.isLunch) ...[
                    Text(
                      'Lunch Break',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    Text(
                      entry.getFormattedTime(),
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ] else ...[
                    Text(
                      entry.subject,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('Faculty: ${entry.faculty}'),
                    Text('Classroom: ${entry.classroom}'),
                    Text('Time: ${entry.getFormattedTime()}'),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
