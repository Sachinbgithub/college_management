import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacultyViewScreen extends StatefulWidget {
  @override
  _FacultyViewScreenState createState() => _FacultyViewScreenState();
}

class _FacultyViewScreenState extends State<FacultyViewScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty View'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot studentDoc = snapshot.data!.docs[index];

              return ListTile(
                title: Text(studentDoc['name']),
                trailing: ElevatedButton(
                  onPressed: () async {
                    // Mark attendance logic here
                    await _markAttendance(studentDoc.id);
                  },
                  child: Text('Mark Attendance'),
                ),
              );
            },
          );
        },
      ),
    );
  }


  Future<void> _markAttendance(String studentId) async {
    final DateTime now = DateTime.now();
    final String date = '${now.year}-${now.month}-${now.day}';

    await _firestore.collection('attendance').doc().set({
      'studentId': studentId,
      'date': date,
      'status': 'Present',
    });
  }
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('attendance').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot attendanceDoc = snapshot.data!.docs[index];

              return ListTile(
                title: Text('Student ID: ${attendanceDoc['studentId']}'),
                subtitle: Text('Date: ${attendanceDoc['date']}, Status: ${attendanceDoc['status']}'),
              );
            },
          );
        },
      ),
    );
  }
}

