import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _students = [];
  bool _loadingStudents = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _checkFacultyAndLoadStudents();
  }

  Future<void> _checkFacultyAndLoadStudents() async {
    setState(() => _loadingStudents = true);
    try {
      String userId = _auth.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists && userDoc['userType'] == 'faculty') {
        QuerySnapshot query = await _firestore.collection('users')
            .where('userType', isEqualTo: 'student')
            .get();

        List<Map<String, dynamic>> students = [];
        for (var doc in query.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          students.add({
            'id': doc.id,
            'name': data['name'] ?? 'No Name',
          });
        }

        setState(() {
          _students = students;
          _loadingStudents = false;
        });
      } else {
        // Redirect to a different page if not faculty
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error loading students: $e');
      setState(() => _loadingStudents = false);
    }
  }


  Future<void> _markAttendance(String studentId, String status) async {
    try {
      await _firestore.collection('attendance').add({
        'date': DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day), // Store date without time
        'studentId': studentId,
        'status': status,
        'markedBy': _auth.currentUser?.uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Attendance marked successfully for $studentId"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error marking attendance: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }


  // Future<void> _markAttendance(String studentId, String status) async {
  //   try {
  //     await _firestore.collection('attendance').add({
  //       'date': _selectedDate,
  //       'studentId': studentId,
  //       'status': status,
  //       'markedBy': _auth.currentUser?.uid,
  //     });
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Attendance marked successfully for $studentId"),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Error marking attendance: $e"),
  //         backgroundColor: Colors.redAccent,
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mark Attendance"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _loadingStudents
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date: ${_selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text("Select Date"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                var student = _students[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(student['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () => _markAttendance(student['id'], 'present'),
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => _markAttendance(student['id'], 'absent'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }
}
