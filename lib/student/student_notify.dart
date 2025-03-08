import 'package:flutter/material.dart';

class StudentMessageScreen extends StatelessWidget {
  final List<String> messages;
  StudentMessageScreen({required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Messages")),
      body: messages.isEmpty
          ? Center(child: Text("No messages received yet"))
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(messages[index], style: TextStyle(fontSize: 16)),
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class StudentMessageScreen extends StatelessWidget {
//   final List<String> messages = [
//     "Welcome students!",
//     "Your assignment is due tomorrow.",
//     "Exam schedule updated!"
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Student Messages")),
//       body: ListView.builder(
//         padding: EdgeInsets.all(16.0),
//         itemCount: messages.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: EdgeInsets.symmetric(vertical: 8.0),
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(messages[index], style: TextStyle(fontSize: 16)),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
