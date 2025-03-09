import 'package:college_management/staff/notification.dart';
import 'package:college_management/student/AttendanceScreen.dart';
import 'package:college_management/student/student_profile.dart';
import 'package:college_management/student/timetablePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String username = "User";

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  void _fetchUsername() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        username = userDoc['name'] ?? 'User';
      });
    }
  }

  // void _logout() async {
  //   await FirebaseAuth.instance.signOut();
  //   if (mounted) {
  //     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Welcome, $username',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => StudentProfile(studentId: '',)));
              },
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text("Attendance"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AttendanceScreen(studentId: '',)));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap:
                    () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                }
            ),
          ],
        ),
      ),
      body: HomeScreen(username: username),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String username;
  HomeScreen({super.key, required this.username});

  final List<String> imageList = [
    'assets/images/img1.png',
    'assets/images/img2.png',
    'assets/images/img1.png',
  ];

  get studentId => null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Hello, $username",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          CarouselSlider(
            items: imageList.map((imagePath) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
              );
            }).toList(),
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              enlargeCenterPage: true,
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                _buildCard(context, Icons.assignment, "Attendance", () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AttendanceScreen(studentId: '',)));
                }),
                SizedBox(height: 20),
                _buildCard(context, Icons.schedule, "Timetable", () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => TimetablePage()));
                }),
                SizedBox(height: 20),
                _buildCard(context, Icons.notifications, "Notifications", () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => NotificationsPage()));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Colors.blue.shade700),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
