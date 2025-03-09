import 'package:college_management/staff/staff_notify.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../student/student_notify.dart';

class AdminMessageScreen extends StatefulWidget {
  const AdminMessageScreen({super.key});

  @override
  _AdminMessageScreenState createState() => _AdminMessageScreenState();
}

class _AdminMessageScreenState extends State<AdminMessageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool sendToStudents = false;
  bool sendToTeachers = false;

  List<String> studentMessages = [];
  List<String> teacherMessages = [];

  void sendMessage() async {
    if (_titleController.text.isEmpty || _messageController.text.isEmpty || (!sendToStudents && !sendToTeachers)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Enter a title, a message & select at least one recipient"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    String title = _titleController.text;
    String message = _messageController.text;
    String userId = _auth.currentUser?.uid ?? '';

    // Create notification data
    Map<String, dynamic> notificationData = {
      'title': title,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'readBy': [],
      'target': sendToStudents && sendToTeachers ? 'all'
          : sendToStudents ? 'students'
          : sendToTeachers ? 'teachers'
          : null,
      'senderId': userId,
    };

    try {
      // Add notification to Firestore for students
      if (sendToStudents) {
        await _firestore.collection('notifications').add(notificationData);
      }

      // Add notification to Firestore for teachers
      if (sendToTeachers) {
        await _firestore.collection('notifications').add(notificationData);
      }

      setState(() {
        if (sendToStudents) studentMessages.add(message);
        if (sendToTeachers) teacherMessages.add(message);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Message Sent Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      _titleController.clear();
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error sending message: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void navigateToStudentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationScreen(),
      ),
    );
  }

  void navigateToTeacherScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherMessageScreen(messages: teacherMessages),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin - Send Messages"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              Text(
                "Enter Title:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Type the title here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
              SizedBox(height: 20),
              // Message Input
              Text(
                "Enter Message:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Type your message here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: EdgeInsets.all(15),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              // Toggle Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        "Send To:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("Students", style: TextStyle(fontSize: 16)),
                              Switch(
                                value: sendToStudents,
                                onChanged: (val) => setState(() => sendToStudents = val),
                                activeColor: Colors.blueAccent,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Teachers", style: TextStyle(fontSize: 16)),
                              Switch(
                                value: sendToTeachers,
                                onChanged: (val) => setState(() => sendToTeachers = val),
                                activeColor: Colors.blueAccent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Send Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: sendMessage,
                  icon: Icon(Icons.send),
                  label: Text("Send Message"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 8,
                  ),
                ),
              ),
              SizedBox(height: 40),
              // View Messages Section
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _viewMessageButton("View Student Messages", Icons.person, navigateToStudentScreen),
                    SizedBox(height: 20),
                    _viewMessageButton("View Teacher Messages", Icons.school, navigateToTeacherScreen),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Button for Viewing Messages
  Widget _viewMessageButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
      ),
    );
  }
}
