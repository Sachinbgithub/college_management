import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminTimetableScreen extends StatefulWidget {
  @override
  _AdminTimetableScreenState createState() => _AdminTimetableScreenState();
}

class _AdminTimetableScreenState extends State<AdminTimetableScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lectureController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _staffController = TextEditingController();
  String _selectedDay = "Monday";

  Future<void> _addTimetableEntry() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection("timetable").add({
        "day": _selectedDay,
        "lecture": _lectureController.text,
        "time": _timeController.text,
        "staff_name": _staffController.text,
      });

      // Clear Fields After Submission
      _lectureController.clear();
      _timeController.clear();
      _staffController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Timetable Entry Added")));
    }
  }

  Future<void> _deleteEntry(String docId) async {
    await FirebaseFirestore.instance.collection("timetable").doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Entry Deleted")));
  }

  Future<void> _editEntry(String docId, String lecture, String time, String staffName) async {
    _lectureController.text = lecture;
    _timeController.text = time;
    _staffController.text = staffName;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Timetable Entry"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _lectureController,
                decoration: InputDecoration(labelText: "Lecture"),
                validator: (value) => value!.isEmpty ? "Enter Lecture Name" : null,
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: "Time"),
                validator: (value) => value!.isEmpty ? "Enter Time" : null,
              ),
              TextFormField(
                controller: _staffController,
                decoration: InputDecoration(labelText: "Staff Name"),
                validator: (value) => value!.isEmpty ? "Enter Staff Name" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await FirebaseFirestore.instance.collection("timetable").doc(docId).update({
                  "lecture": _lectureController.text,
                  "time": _timeController.text,
                  "staff_name": _staffController.text,
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Entry Updated")));
              }
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Timetable"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 Form to Add Timetable Entries
            Form(
              key: _formKey,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedDay,
                        items: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
                            .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedDay = value!),
                        decoration: InputDecoration(labelText: "Select Day"),
                      ),
                      TextFormField(
                        controller: _lectureController,
                        decoration: InputDecoration(labelText: "Lecture"),
                        validator: (value) => value!.isEmpty ? "Enter Lecture Name" : null,
                      ),
                      TextFormField(
                        controller: _timeController,
                        decoration: InputDecoration(labelText: "Time"),
                        validator: (value) => value!.isEmpty ? "Enter Time" : null,
                      ),
                      TextFormField(
                        controller: _staffController,
                        decoration: InputDecoration(labelText: "Staff Name"),
                        validator: (value) => value!.isEmpty ? "Enter Staff Name" : null,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _addTimetableEntry,
                        child: Text("Add Entry"),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // 📌 Display Timetable in Tabular Format
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("timetable").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.deepPurple),
                      columns: [
                        DataColumn(label: Text("Day", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
                        DataColumn(label: Text("Lecture", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
                        DataColumn(label: Text("Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
                        DataColumn(label: Text("Staff", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
                        DataColumn(label: Text("Actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
                      ],
                      rows: snapshot.data!.docs.map((doc) {
                        return DataRow(cells: [
                          DataCell(Text(doc["day"], style: TextStyle(fontSize: 15))),
                          DataCell(Text(doc["lecture"], style: TextStyle(fontSize: 15))),
                          DataCell(Text(doc["time"], style: TextStyle(fontSize: 15))),
                          DataCell(Text(doc["staff_name"], style: TextStyle(fontSize: 15))),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editEntry(doc.id, doc["lecture"], doc["time"], doc["staff_name"]),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteEntry(doc.id),
                              ),
                            ],
                          )),
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
//
// class AdminScreen extends StatefulWidget {
//   @override
//   _AdminScreenState createState() => _AdminScreenState();
// }
//
// class _AdminScreenState extends State<AdminScreen> {
//   final TextEditingController dayController = TextEditingController();
//   final TextEditingController lectureController = TextEditingController();
//   final TextEditingController timeController = TextEditingController();
//   final TextEditingController staffController = TextEditingController();
//
//   void _addOrUpdateTimetableEntry({String? docId}) async {
//     if (dayController.text.isEmpty || lectureController.text.isEmpty || timeController.text.isEmpty || staffController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required")));
//       return;
//     }
//
//     Map<String, String> timetableEntry = {
//       "day": dayController.text.trim(),
//       "lecture": lectureController.text.trim(),
//       "time": timeController.text.trim(),
//       "staff_name": staffController.text.trim(),
//     };
//
//     if (docId == null) {
//       // Add new entry
//       await FirebaseFirestore.instance.collection("timetable").add(timetableEntry);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Timetable Entry Added")));
//     } else {
//       // Update existing entry
//       await FirebaseFirestore.instance.collection("timetable").doc(docId).update(timetableEntry);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Timetable Entry Updated")));
//     }
//
//     dayController.clear();
//     lectureController.clear();
//     timeController.clear();
//     staffController.clear();
//   }
//
//   void _deleteTimetableEntry(String id) async {
//     await FirebaseFirestore.instance.collection("timetable").doc(id).delete();
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Entry Deleted")));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Admin - Manage Timetable")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 TextField(controller: dayController, decoration: InputDecoration(labelText: "Day (e.g., Monday)")),
//                 TextField(controller: lectureController, decoration: InputDecoration(labelText: "Lecture")),
//                 TextField(controller: timeController, decoration: InputDecoration(labelText: "Time")),
//                 TextField(controller: staffController, decoration: InputDecoration(labelText: "Staff Name")),
//                 SizedBox(height: 10),
//                 ElevatedButton(onPressed: () => _addOrUpdateTimetableEntry(), child: Text("Add / Update Entry")),
//               ],
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance.collection("timetable").orderBy("day").snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//
//                 return SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: DataTable(
//                     columns: [
//                       DataColumn(label: Text("Day")),
//                       DataColumn(label: Text("Lecture")),
//                       DataColumn(label: Text("Time")),
//                       DataColumn(label: Text("Staff")),
//                       DataColumn(label: Text("Actions")),
//                     ],
//                     rows: snapshot.data!.docs.map((doc) {
//                       return DataRow(cells: [
//                         DataCell(Text(doc["day"])),
//                         DataCell(Text(doc["lecture"])),
//                         DataCell(Text(doc["time"])),
//                         DataCell(Text(doc["staff_name"])),
//                         DataCell(Row(
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.edit, color: Colors.blue),
//                               onPressed: () {
//                                 dayController.text = doc["day"];
//                                 lectureController.text = doc["lecture"];
//                                 timeController.text = doc["time"];
//                                 staffController.text = doc["staff_name"];
//                                 _addOrUpdateTimetableEntry(docId: doc.id);
//                               },
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.delete, color: Colors.red),
//                               onPressed: () => _deleteTimetableEntry(doc.id),
//                             ),
//                           ],
//                         )),
//                       ]);
//                     }).toList(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
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
// //
// // class AdminScreen extends StatefulWidget {
// //   @override
// //   _AdminScreenState createState() => _AdminScreenState();
// // }
// //
// // class _AdminScreenState extends State<AdminScreen> {
// //   final TextEditingController dayController = TextEditingController();
// //   final TextEditingController lectureController = TextEditingController();
// //   final TextEditingController timeController = TextEditingController();
// //   final TextEditingController staffController = TextEditingController();
// //
// //   void _addTimetableEntry() async {
// //     if (dayController.text.isEmpty || lectureController.text.isEmpty || timeController.text.isEmpty || staffController.text.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required")));
// //       return;
// //     }
// //
// //     await FirebaseFirestore.instance.collection("timetable").add({
// //       "day": dayController.text.trim(),
// //       "lecture": lectureController.text.trim(),
// //       "time": timeController.text.trim(),
// //       "staff_name": staffController.text.trim(),
// //     });
// //
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Timetable Entry Added")));
// //     dayController.clear();
// //     lectureController.clear();
// //     timeController.clear();
// //     staffController.clear();
// //   }
// //
// //   void _updateTimetableEntry(String id) async {
// //     await FirebaseFirestore.instance.collection("timetable").doc(id).update({
// //       "day": dayController.text.trim(),
// //       "lecture": lectureController.text.trim(),
// //       "time": timeController.text.trim(),
// //       "staff_name": staffController.text.trim(),
// //     });
// //
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Timetable Entry Updated")));
// //   }
// //
// //   void _deleteTimetableEntry(String id) async {
// //     await FirebaseFirestore.instance.collection("timetable").doc(id).delete();
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Entry Deleted")));
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Admin - Manage Timetable")),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Column(
// //               children: [
// //                 TextField(controller: dayController, decoration: InputDecoration(labelText: "Day (e.g., Monday)")),
// //                 TextField(controller: lectureController, decoration: InputDecoration(labelText: "Lecture")),
// //                 TextField(controller: timeController, decoration: InputDecoration(labelText: "Time")),
// //                 TextField(controller: staffController, decoration: InputDecoration(labelText: "Staff Name")),
// //                 SizedBox(height: 10),
// //                 ElevatedButton(onPressed: _addTimetableEntry, child: Text("Add Entry")),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: StreamBuilder(
// //               stream: FirebaseFirestore.instance.collection("timetable").snapshots(),
// //               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
// //                 if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
// //
// //                 return ListView(
// //                   children: snapshot.data!.docs.map((doc) {
// //                     return ListTile(
// //                       title: Text("${doc["day"]} - ${doc["lecture"]}"),
// //                       subtitle: Text("${doc["time"]} - ${doc["staff_name"]}"),
// //                       trailing: IconButton(
// //                         icon: Icon(Icons.delete, color: Colors.red),
// //                         onPressed: () => _deleteTimetableEntry(doc.id),
// //                       ),
// //                       onTap: () {
// //                         dayController.text = doc["day"];
// //                         lectureController.text = doc["lecture"];
// //                         timeController.text = doc["time"];
// //                         staffController.text = doc["staff_name"];
// //                         _updateTimetableEntry(doc.id);
// //                       },
// //                     );
// //                   }).toList(),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// // // import 'dart:io';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_storage/firebase_storage.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:image_picker/image_picker.dart';
// // // import '../staff/view_timetable.dart';
// // //
// // // class UploadImageScreen extends StatefulWidget {
// // //   @override
// // //   _UploadImageScreenState createState() => _UploadImageScreenState();
// // // }
// // //
// // // class _UploadImageScreenState extends State<UploadImageScreen> {
// // //   File? _imageFile;
// // //   final ImagePicker _picker = ImagePicker();
// // //   String? imageUrl;
// // //
// // //   Future<void> _pickImage() async {
// // //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
// // //
// // //     if (pickedFile != null) {
// // //       setState(() {
// // //         _imageFile = File(pickedFile.path);
// // //       });
// // //       await _uploadImage();
// // //     }
// // //   }
// // //
// // //   Future<void> _uploadImage() async {
// // //     if (_imageFile == null) return;
// // //
// // //     try {
// // //       // First, get the previous image URL before uploading the new one.
// // //       String? previousUrl = await _getPreviousImageUrl();
// // //
// // //       // Upload new image to Firebase Storage
// // //       String fileName = "uploaded_image.jpg";  // Keeping filename static to overwrite the old one
// // //       Reference storageRef = FirebaseStorage.instance.ref().child("images/$fileName");
// // //       UploadTask uploadTask = storageRef.putFile(_imageFile!);
// // //       TaskSnapshot snapshot = await uploadTask;
// // //       String newImageUrl = await snapshot.ref.getDownloadURL();
// // //
// // //       // Store new image URL in Firestore
// // //       await FirebaseFirestore.instance.collection("images").doc("latest").set({"url": newImageUrl});
// // //
// // //       setState(() {
// // //         imageUrl = newImageUrl;
// // //       });
// // //
// // //       // Delete the previous image only after successfully uploading the new one
// // //       if (previousUrl != null && previousUrl.isNotEmpty) {
// // //         await _deletePreviousImage(previousUrl);
// // //       }
// // //
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Uploaded Successfully")));
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload Failed: $e")));
// // //     }
// // //   }
// // //
// // //   Future<String?> _getPreviousImageUrl() async {
// // //     try {
// // //       DocumentSnapshot doc = await FirebaseFirestore.instance.collection("images").doc("latest").get();
// // //       if (doc.exists && doc.data() != null) {
// // //         return (doc.data() as Map<String, dynamic>)["url"];
// // //       }
// // //     } catch (e) {
// // //       print("Error fetching previous image: $e");
// // //     }
// // //     return null;
// // //   }
// // //
// // //   Future<void> _deletePreviousImage(String previousUrl) async {
// // //     try {
// // //       Reference previousImageRef = FirebaseStorage.instance.refFromURL(previousUrl);
// // //       await previousImageRef.delete();
// // //       print("Previous image deleted successfully.");
// // //     } catch (e) {
// // //       print("Error deleting previous image: $e");
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text("Upload Image")),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Card(
// // //               elevation: 5,
// // //               child: Padding(
// // //                 padding: EdgeInsets.all(20),
// // //                 child: Column(
// // //                   children: [
// // //                     imageUrl != null
// // //                         ? Image.network(imageUrl!, height: 150, width: 150, fit: BoxFit.cover)
// // //                         : Icon(Icons.image, size: 100, color: Colors.grey),
// // //                     SizedBox(height: 10),
// // //                     ElevatedButton(
// // //                       onPressed: _pickImage,
// // //                       child: Text("Upload Image"),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //             SizedBox(height: 20),
// // //             ElevatedButton(
// // //               onPressed: () {
// // //                 Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImageScreen()));
// // //               },
// // //               child: Text("View Uploaded Image"),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // //
// // //
// // //
// // // // import 'dart:io';
// // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // import 'package:firebase_storage/firebase_storage.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:image_picker/image_picker.dart';
// // // // import '../staff/view_timetable.dart';
// // // //
// // // // class UploadImageScreen extends StatefulWidget {
// // // //   @override
// // // //   _UploadImageScreenState createState() => _UploadImageScreenState();
// // // // }
// // // //
// // // // class _UploadImageScreenState extends State<UploadImageScreen> {
// // // //   File? _imageFile;
// // // //   final ImagePicker _picker = ImagePicker();
// // // //   String? imageUrl;
// // // //
// // // //   Future<void> _pickImage() async {
// // // //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
// // // //
// // // //     if (pickedFile != null) {
// // // //       setState(() {
// // // //         _imageFile = File(pickedFile.path);
// // // //       });
// // // //       await _uploadImage();
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> _uploadImage() async {
// // // //     if (_imageFile == null) return;
// // // //
// // // //     try {
// // // //       // Delete existing image first
// // // //       await _deletePreviousImage();
// // // //
// // // //       // Generate unique file name
// // // //       String fileName = "uploaded_image_${DateTime.now().millisecondsSinceEpoch}.jpg";
// // // //       Reference storageRef = FirebaseStorage.instance.ref().child("images/$fileName");
// // // //       UploadTask uploadTask = storageRef.putFile(_imageFile!);
// // // //       TaskSnapshot snapshot = await uploadTask;
// // // //       String newImageUrl = await snapshot.ref.getDownloadURL();
// // // //
// // // //       // Store new image URL in Firestore
// // // //       await FirebaseFirestore.instance.collection("images").doc("latest").set({"url": newImageUrl});
// // // //
// // // //       setState(() {
// // // //         imageUrl = newImageUrl;
// // // //       });
// // // //
// // // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Uploaded Successfully")));
// // // //     } catch (e) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload Failed: $e")));
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> _deletePreviousImage() async {
// // // //     try {
// // // //       await Future.delayed(Duration(seconds: 2)); // Short delay before deletion
// // // //       DocumentSnapshot doc = await FirebaseFirestore.instance.collection("images").doc("latest").get();
// // // //       if (doc.exists && doc["url"] != null) {
// // // //         String previousUrl = doc["url"];
// // // //         if (previousUrl.isNotEmpty) {
// // // //           Reference previousImageRef = FirebaseStorage.instance.refFromURL(previousUrl);
// // // //           await previousImageRef.delete();
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       print("No previous image found: $e");
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: Text("Upload Image")),
// // // //       body: Center(
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             Card(
// // // //               elevation: 5,
// // // //               child: Padding(
// // // //                 padding: EdgeInsets.all(20),
// // // //                 child: Column(
// // // //                   children: [
// // // //                     imageUrl != null
// // // //                         ? Image.network(imageUrl!, height: 150, width: 150, fit: BoxFit.cover)
// // // //                         : Icon(Icons.image, size: 100, color: Colors.grey),
// // // //                     SizedBox(height: 10),
// // // //                     ElevatedButton(
// // // //                       onPressed: _pickImage,
// // // //                       child: Text("Upload Image"),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             SizedBox(height: 20),
// // // //             ElevatedButton(
// // // //               onPressed: () {
// // // //                 Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImageScreen()));
// // // //               },
// // // //               child: Text("View Uploaded Image"),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // //
// // // // import 'dart:io';
// // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // import 'package:firebase_storage/firebase_storage.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:image_picker/image_picker.dart';
// // // //
// // // // import '../staff/view_timetable.dart';
// // // //
// // // //
// // // // class UploadImageScreen extends StatefulWidget {
// // // //   @override
// // // //   _UploadImageScreenState createState() => _UploadImageScreenState();
// // // // }
// // // //
// // // // class _UploadImageScreenState extends State<UploadImageScreen> {
// // // //   File? _imageFile;
// // // //   final ImagePicker _picker = ImagePicker();
// // // //   String? imageUrl;
// // // //
// // // //   Future<void> _pickImage() async {
// // // //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
// // // //
// // // //     if (pickedFile != null) {
// // // //       setState(() {
// // // //         _imageFile = File(pickedFile.path);
// // // //       });
// // // //       _uploadImage();
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> _uploadImage() async {
// // // //     if (_imageFile == null) return;
// // // //
// // // //     try {
// // // //       // Delete existing image first
// // // //       await _deletePreviousImage();
// // // //
// // // //       // Upload new image to Firebase Storage
// // // //       String fileName = "uploaded_image.jpg";
// // // //       Reference storageRef = FirebaseStorage.instance.ref().child("images/$fileName");
// // // //       UploadTask uploadTask = storageRef.putFile(_imageFile!);
// // // //       TaskSnapshot snapshot = await uploadTask;
// // // //       String newImageUrl = await snapshot.ref.getDownloadURL();
// // // //
// // // //       // Store new image URL in Firestore
// // // //       await FirebaseFirestore.instance.collection("images").doc("latest").set({"url": newImageUrl});
// // // //
// // // //       setState(() {
// // // //         imageUrl = newImageUrl;
// // // //       });
// // // //
// // // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Uploaded Successfully")));
// // // //     } catch (e) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload Failed: $e")));
// // // //     }
// // // //   }
// // // //
// // // //   Future<void> _deletePreviousImage() async {
// // // //     try {
// // // //       DocumentSnapshot doc = await FirebaseFirestore.instance.collection("images").doc("latest").get();
// // // //       if (doc.exists) {
// // // //         String? previousUrl = doc["url"];
// // // //         if (previousUrl != null) {
// // // //           Reference previousImageRef = FirebaseStorage.instance.refFromURL(previousUrl);
// // // //           await previousImageRef.delete();
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       print("No previous image found: $e");
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: Text("Upload Image")),
// // // //       body: Center(
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             Card(
// // // //               elevation: 5,
// // // //               child: Padding(
// // // //                 padding: EdgeInsets.all(20),
// // // //                 child: Column(
// // // //                   children: [
// // // //                     imageUrl != null
// // // //                         ? Image.network(imageUrl!, height: 150, width: 150, fit: BoxFit.cover)
// // // //                         : Icon(Icons.image, size: 100, color: Colors.grey),
// // // //                     SizedBox(height: 10),
// // // //                     ElevatedButton(
// // // //                       onPressed: _pickImage,
// // // //                       child: Text("Upload Image"),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             SizedBox(height: 20),
// // // //             ElevatedButton(
// // // //               onPressed: () {
// // // //                 Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImageScreen()));
// // // //               },
// // // //               child: Text("View Uploaded Image"),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
