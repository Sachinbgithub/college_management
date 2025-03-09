import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceScreen extends StatefulWidget {
  final String studentId;
  const AttendanceScreen({super.key, required this.studentId});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  int presentCount = 0;
  int absentCount = 0;
  List<Map<String, dynamic>> attendanceList = [];

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  void fetchAttendanceData() async {
    final doc = await FirebaseFirestore.instance
        .collection('attendance')
        .doc(widget.studentId)
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      int present = 0, absent = 0;
      List<Map<String, dynamic>> records = [];

      data.forEach((date, value) {
        records.add({'date': date, 'subject': value['subject'], 'status': value['status']});
        if (value['status'] == 'Present') {
          present++;
        } else {
          absent++;
        }
      });

      setState(() {
        presentCount = present;
        absentCount = absent;
        attendanceList = records;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attendance")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade300)],
              ),
              child: Center(child: buildPieChart()),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: attendanceList.length,
                itemBuilder: (context, index) {
                  var record = attendanceList[index];
                  return ListTile(
                    title: Text("${record['date']} - ${record['subject']}"),
                    trailing: Text(
                      record['status'],
                      style: TextStyle(
                        color: record['status'] == 'Present' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.green,
            value: presentCount.toDouble(),
            title: '$presentCount%',
            radius: 50,
          ),
          PieChartSectionData(
            color: Colors.red,
            value: absentCount.toDouble(),
            title: '$absentCount%',
            radius: 50,
          ),
        ],
      ),
    );
  }
}
