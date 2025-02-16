import 'package:flutter/material.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timetable")),
      body: Center(child: Text("Timetable Screen", style: TextStyle(fontSize: 20))),
    );
  }
}
