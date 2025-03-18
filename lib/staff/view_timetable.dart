import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentScreen extends StatelessWidget {
  final String currentDay = DateFormat('EEEE').format(DateTime.now()); // Get today's day

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Timetable"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 Displays the Current Date & Day
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "${DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now())}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 📌 Firestore Data Table with Live Updates
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("timetable").where("day", isEqualTo: currentDay).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hourglass_empty, size: 50, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("No classes scheduled for today.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueAccent),
                      columns: [
                        DataColumn(label: Text("Lecture", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
                        DataColumn(label: Text("Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
                        DataColumn(label: Text("Staff Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
                      ],
                      rows: snapshot.data!.docs.map((doc) {
                        return DataRow(cells: [
                          DataCell(Text(doc["lecture"], style: TextStyle(fontSize: 15))),
                          DataCell(Text(doc["time"], style: TextStyle(fontSize: 15))),
                          DataCell(Text(doc["staff_name"], style: TextStyle(fontSize: 15))),
                        ]);
                      }).toList(),
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
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class StudentScreen extends StatelessWidget {
//   final String currentDay = DateFormat('EEEE').format(DateTime.now()); // Get today's day
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Today's Timetable")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection("timetable").where("day", isEqualTo: currentDay).snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//
//           if (snapshot.data!.docs.isEmpty) return Center(child: Text("No classes scheduled for today."));
//
//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: [
//                 DataColumn(label: Text("Lecture")),
//                 DataColumn(label: Text("Time")),
//                 DataColumn(label: Text("Staff Name")),
//               ],
//               rows: snapshot.data!.docs.map((doc) {
//                 return DataRow(cells: [
//                   DataCell(Text(doc["lecture"])),
//                   DataCell(Text(doc["time"])),
//                   DataCell(Text(doc["staff_name"])),
//                 ]);
//               }).toList(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
//
//
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart'; // For getting the current day name
// //
// // class StudentScreen extends StatefulWidget {
// //   @override
// //   _StudentScreenState createState() => _StudentScreenState();
// // }
// //
// // class _StudentScreenState extends State<StudentScreen> {
// //   String currentDay = DateFormat('EEEE').format(DateTime.now()); // Get current day name
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Student - Today's Timetable")),
// //       body: StreamBuilder(
// //         stream: FirebaseFirestore.instance.collection("timetable").where("day", isEqualTo: currentDay).snapshots(),
// //         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
// //           if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
// //
// //           if (snapshot.data!.docs.isEmpty) return Center(child: Text("No classes scheduled for today."));
// //
// //           return ListView(
// //             children: snapshot.data!.docs.map((doc) {
// //               return Card(
// //                 elevation: 3,
// //                 margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //                 child: ListTile(
// //                   title: Text(doc["lecture"], style: TextStyle(fontWeight: FontWeight.bold)),
// //                   subtitle: Text("Time: ${doc["time"]}\nStaff: ${doc["staff_name"]}"),
// //                 ),
// //               );
// //             }).toList(),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// //
// //
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:flutter/material.dart';
// // //
// // // class ViewImageScreen extends StatefulWidget {
// // //   @override
// // //   _ViewImageScreenState createState() => _ViewImageScreenState();
// // // }
// // //
// // // class _ViewImageScreenState extends State<ViewImageScreen> {
// // //   String? imageUrl;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _fetchImage();
// // //   }
// // //
// // //   Future<void> _fetchImage() async {
// // //     try {
// // //       DocumentSnapshot doc = await FirebaseFirestore.instance.collection("images").doc("latest").get();
// // //       if (doc.exists && doc["url"] != null) {
// // //         setState(() {
// // //           imageUrl = doc["url"];
// // //         });
// // //       }
// // //     } catch (e) {
// // //       print("Error fetching image: $e");
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text("View Image")),
// // //       body: Center(
// // //         child: imageUrl == null
// // //             ? CircularProgressIndicator()
// // //             : GestureDetector(
// // //           onTap: () {
// // //             Navigator.push(
// // //               context,
// // //               MaterialPageRoute(
// // //                 builder: (context) => FullScreenImage(imageUrl: imageUrl!),
// // //               ),
// // //             );
// // //           },
// // //           child: Card(
// // //             elevation: 5,
// // //             child: Padding(
// // //               padding: EdgeInsets.all(10),
// // //               child: Image.network(imageUrl!, height: 250, width: 250, fit: BoxFit.cover),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class FullScreenImage extends StatelessWidget {
// // //   final String imageUrl;
// // //   FullScreenImage({required this.imageUrl});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.black,
// // //       appBar: AppBar(backgroundColor: Colors.black),
// // //       body: Center(
// // //         child: Image.network(imageUrl, fit: BoxFit.contain),
// // //       ),
// // //     );
// // //   }
// // // }
