import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewAttendancePage extends StatefulWidget {
  @override
  _ViewAttendancePageState createState() => _ViewAttendancePageState();
}

class _ViewAttendancePageState extends State<ViewAttendancePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _attendanceRecords = [];
  bool _loadingAttendance = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _checkFacultyAndLoadAttendance();
  }

  Future<void> _checkFacultyAndLoadAttendance() async {
    setState(() => _loadingAttendance = true);
    try {
      String userId = _auth.currentUser?.uid ?? '';
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists && userDoc['userType'] == 'faculty') {
        QuerySnapshot query = await _firestore.collection('attendance')
            .where('date', isEqualTo: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day))
            .get();

        List<Map<String, dynamic>> attendanceRecords = [];
        for (var doc in query.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          DocumentSnapshot studentDoc = await _firestore.collection('users').doc(data['studentId']).get();
          if (studentDoc.exists) {
            attendanceRecords.add({
              'studentName': studentDoc['name'] ?? 'No Name',
              'status': data['status'] ?? 'No Status',
              'date': data['date'].toDate(),
            });
          }
        }

        setState(() {
          _attendanceRecords = attendanceRecords;
          _loadingAttendance = false;
        });
        print("Attendance records loaded: ${attendanceRecords.length} records found."); // Debug print
      } else {
        // Redirect to a different page if not faculty
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error loading attendance: $e');
      setState(() => _loadingAttendance = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _checkFacultyAndLoadAttendance();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Attendance"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _loadingAttendance
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
            child: _attendanceRecords.isEmpty
                ? Center(child: Text('No attendance records available'))
                : ListView.builder(
              itemCount: _attendanceRecords.length,
              itemBuilder: (context, index) {
                var record = _attendanceRecords[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(record['studentName'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Status: ${record['status']}"),
                    trailing: Text("Date: ${record['date'].toLocal()}".split(' ')[0]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
