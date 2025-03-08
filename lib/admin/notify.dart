import 'package:college_management/staff/staff_notify.dart';
import 'package:flutter/material.dart';
import '../student/student_notify.dart';

class AdminMessageScreen extends StatefulWidget {
  @override
  _AdminMessageScreenState createState() => _AdminMessageScreenState();
}

class _AdminMessageScreenState extends State<AdminMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool sendToStudents = false;
  bool sendToTeachers = false;

  List<String> studentMessages = [];
  List<String> teacherMessages = [];

  void sendMessage() {
    if (_messageController.text.isEmpty || (!sendToStudents && !sendToTeachers)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Enter a message & select at least one recipient"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      if (sendToStudents) studentMessages.add(_messageController.text);
      if (sendToTeachers) teacherMessages.add(_messageController.text);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Message Sent Successfully"),
        backgroundColor: Colors.green,
      ),
    );

    _messageController.clear();
  }

  void navigateToStudentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentMessageScreen(messages: studentMessages),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message Input
            Text(
              "Enter Message:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type your message here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 3,
            ),

            SizedBox(height: 20),

            // Toggle Section
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      "Send To:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("Students", style: TextStyle(fontSize: 14)),
                            Switch(
                              value: sendToStudents,
                              onChanged: (val) => setState(() => sendToStudents = val),
                              activeColor: Colors.blueAccent,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Teachers", style: TextStyle(fontSize: 14)),
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

            SizedBox(height: 20),

            // Send Button
            Center(
              child: ElevatedButton.icon(
                onPressed: sendMessage,
                icon: Icon(Icons.send),
                label: Text("Send Message"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
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
    );
  }

  // Custom Button for Viewing Messages
  Widget _viewMessageButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        backgroundColor: Colors.grey[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    );
  }
}




// import 'package:college_management/staff/staff_notify.dart';
// import 'package:flutter/material.dart';
// import '../student/student_notify.dart';
//
// class AdminMessageScreen extends StatefulWidget {
//   @override
//   _AdminMessageScreenState createState() => _AdminMessageScreenState();
// }
//
// class _AdminMessageScreenState extends State<AdminMessageScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   bool sendToStudents = false;
//   bool sendToTeachers = false;
//
//   List<String> studentMessages = [];
//   List<String> teacherMessages = [];
//
//   void sendMessage() {
//     if (_messageController.text.isEmpty || (!sendToStudents && !sendToTeachers)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Enter a message & select at least one recipient"),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//       return;
//     }
//
//     setState(() {
//       if (sendToStudents) studentMessages.add(_messageController.text);
//       if (sendToTeachers) teacherMessages.add(_messageController.text);
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Message Sent Successfully"),
//         backgroundColor: Colors.green,
//       ),
//     );
//
//     _messageController.clear();
//   }
//
//   void navigateToStudentScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StudentMessageScreen(messages: studentMessages),
//       ),
//     );
//   }
//
//   void navigateToTeacherScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TeacherMessageScreen(messages: teacherMessages),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Admin - Send Messages"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Message Input
//             Text(
//               "Enter Message:",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: "Type your message here...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 contentPadding: EdgeInsets.all(12),
//               ),
//               maxLines: 3,
//             ),
//
//             SizedBox(height: 20),
//
//             // Toggle Section
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//                 child: Column(
//                   children: [
//                     Text(
//                       "Send To:",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Text("Students", style: TextStyle(fontSize: 14)),
//                             Switch(
//                               value: sendToStudents,
//                               onChanged: (val) => setState(() => sendToStudents = val),
//                               activeColor: Colors.blueAccent,
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text("Teachers", style: TextStyle(fontSize: 14)),
//                             Switch(
//                               value: sendToTeachers,
//                               onChanged: (val) => setState(() => sendToTeachers = val),
//                               activeColor: Colors.blueAccent,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 20),
//
//             // Send Button
//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: sendMessage,
//                 icon: Icon(Icons.send),
//                 label: Text("Send Message"),
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                   backgroundColor: Colors.blueAccent,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   elevation: 5,
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 40),
//
//             // View Messages Section
//             Center(
//               child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _viewMessageButton("View Student Messages", Icons.person, navigateToStudentScreen),
//                       SizedBox(height: 20),
//                       _viewMessageButton("View Tea;cher Messages", Icons.school, navigateToTeacherScreen),
//                     ],
//                   ),
//             ),
//               ],
//             ),
//
//         ),
//       );
//
//   }
//
//   // Custom Button for Viewing Messages
//   Widget _viewMessageButton(String text, IconData icon, VoidCallback onPressed) {
//     return ElevatedButton.icon(
//       onPressed: onPressed,
//       icon: Icon(icon),
//       label: Text(text, style: TextStyle(fontSize: 14),),
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//         backgroundColor: Colors.grey[700],
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 5,
//       ),
//     );
//   }
// }
