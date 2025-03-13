// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class FacultyDashboard extends StatefulWidget {
//   @override
//   _FacultyDashboardState createState() => _FacultyDashboardState();
// }
//
// class _FacultyDashboardState extends State<FacultyDashboard> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Faculty Dashboard'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       drawer: _buildDrawer(context),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildAnnouncementsSection(),
//               SizedBox(height: 20),
//               _buildQuickActionsSection(context),
//               SizedBox(height: 20),
//               _buildRecentNotificationsSection(),
//               SizedBox(height: 20),
//               _buildStudentListSection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Build Navigation Drawer
//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blueAccent,
//             ),
//             child: Text(
//               'Faculty Dashboard',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//               ),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.person),
//             title: Text('View Profile'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ViewProfilePage()),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.people),
//             title: Text('View Students'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ViewStudentsPage()),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.view_list),
//             title: Text('View Attendance'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ViewAttendancePage()),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.check_circle),
//             title: Text('Mark Attendance'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => MarkAttendancePage()),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.notifications),
//             title: Text('Notifications'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => NotificationPage()),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.settings),
//             title: Text('Settings'),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text('Logout'),
//             onTap: () {
//               AuthService().signOut();
//               Navigator.popUntil(context, (route) => route.isFirst);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Build Announcements Section
//   Widget _buildAnnouncementsSection() {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Announcements',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//             ),
//             SizedBox(height: 10),
//             Text('Welcome to the Faculty Dashboard! Here you can manage students, mark attendance, and view notifications.'),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Build Quick Actions Section
//   Widget _buildQuickActionsSection(BuildContext context) {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Quick Actions',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _quickActionButton(context, Icons.check_circle, 'Mark Attendance', MarkAttendancePage()),
//                 _quickActionButton(context, Icons.view_list, 'View Attendance', ViewAttendancePage()),
//                 _quickActionButton(context, Icons.message, 'Send Message', NotificationPage()),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Quick Action Button
//   Widget _quickActionButton(BuildContext context, IconData icon, String label, Widget page) {
//     return ElevatedButton.icon(
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => page),
//         );
//       },
//       icon: Icon(icon, color: Colors.white),
//       label: Text(label),
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         backgroundColor: Colors.blueAccent,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 5,
//       ),
//     );
//   }
//
//   // Build Recent Notifications Section
//   Widget _buildRecentNotificationsSection() {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Recent Notifications',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//             ),
//             SizedBox(height: 10),
//             // Display recent notifications
//             StreamBuilder<QuerySnapshot>(
//               stream: _firestore.collection('notifications').orderBy('timestamp', descending: true).limit(5).snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 var notifications = snapshot.data!.docs;
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: notifications.length,
//                   itemBuilder: (context, index) {
//                     var notification = notifications[index];
//                     return ListTile(
//                       title: Text(notification['title']),
//                       subtitle: Text(notification['message']),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Build Student List Section
//   Widget _buildStudentListSection() {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Student List',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
//             ),
//             SizedBox(height: 10),
//             // Display student list
//             StreamBuilder<QuerySnapshot>(
//               stream: _firestore.collection('users').where('userType', isEqualTo: 'student').snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 var students = snapshot.data!.docs;
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: students.length,
//                   itemBuilder: (context, index) {
//                     var student = students[index];
//                     return ListTile(
//                       title: Text(student['name']),
//                       subtitle: Text('Enrollment Number: ${student['enrollmentNumber']}'),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
