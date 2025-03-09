import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // Dummy student data
  List<Student> students = [
    Student(id: '1', name: 'Tejasvini'),
    Student(id: '2', name: 'Pooja'),
    Student(id: '3', name: 'Prajakta'),
    Student(id: '4', name: 'Shraddha'),
    Student(id: '5', name: 'Rahul'),
    Student(id: '6', name: 'Sandeep'),
    Student(id: '7', name: 'Rakesh'),
    Student(id: '8', name: 'Aditya'),
    Student(id: '9', name: 'Sufiyan'),
  ];

  // Attendance records (initially empty)
  Map<String, Map<DateTime, bool>> attendanceRecords = {};

  @override
  void initState() {
    super.initState();
    // Initialize attendance records for each student
    for (var student in students) {
      attendanceRecords[student.id] = {};
    }
  }

  // Function to mark attendance for a student
  void markAttendance(String studentId, bool isPresent) {
    setState(() {
      attendanceRecords[studentId]![DateTime.now()] = isPresent;
    });
  }

  // Function to view attendance data
  void viewAttendanceData() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceDataPage(attendanceRecords: attendanceRecords, students: students),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Mark today\'s attendance:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(student.name, style: TextStyle(fontSize: 16)),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => markAttendance(student.id, true),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: Text('Present'),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => markAttendance(student.id, false),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: Text('Absent'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: viewAttendanceData,
              child: Text('View Attendance Data'),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceDataPage extends StatelessWidget {
  final Map<String, Map<DateTime, bool>> attendanceRecords;
  final List<Student> students;

  AttendanceDataPage({required this.attendanceRecords, required this.students});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attendance Records:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              for (var student in students) ...[
                Text(
                  '${student.name}:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (attendanceRecords[student.id]!.isEmpty)
                  Text('No attendance data recorded yet.')
                else
                  for (var entry in attendanceRecords[student.id]!.entries)
                    Text(
                        '${entry.key.toString().split(' ')[0]}: ${entry.value ? 'Present' : 'Absent'}'),
                SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Simple Student model
class Student {
  final String id;
  final String name;

  Student({required this.id, required this.name});
}