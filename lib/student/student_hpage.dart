import 'package:college_management/student/AttendanceScreen.dart';
import 'package:college_management/student/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class StudentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  void _logout() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
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
                    context, MaterialPageRoute(builder: (context) => StudentProfile()));
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
              onTap: _logout,
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
  HomeScreen({required this.username});

  final List<String> imageList = [
    'assets/images/img1.png',
    'assets/images/img2.png',
    'assets/images/img1.png',
  ];

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
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                _buildCard(context, Icons.assignment, "Attendance", () {}                ),
                SizedBox(height: 20),
                _buildCard(context, Icons.schedule, "Timetable", () {}),
                SizedBox(height: 20),
                _buildCard(context, Icons.notifications, "Notifications", () {}),
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








// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// class StudentHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: DashboardScreen(),
//     );
//   }
// }
//
// class DashboardScreen extends StatefulWidget {
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String username = "User";
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUsername();
//   }
//
//   void _fetchUsername() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       DocumentSnapshot userDoc =
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       setState(() {
//         username = userDoc['name'] ?? 'User';
//       });
//     }
//   }
//
//   void _logout() async {
//     await _auth.signOut();
//     // TODO: Redirect user to login screen
//   }
//
//   final List<Widget> _screens = [
//     HomeScreen(username: "User"),
//     AttendanceScreen(),
//     ProfileScreen(),
//     NotificationsScreen(),
//     TimetableScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Dashboard"),
//         leading: IconButton(
//           icon: Icon(Icons.menu),
//           onPressed: () {},
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: _logout,
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: IndexedStack(
//               index: _currentIndex,
//               children: _screens.map((screen) {
//                 if (screen is HomeScreen) {
//                   return HomeScreen(username: username);
//                 }
//                 return screen;
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.check), label: "Attendance"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//           BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
//           BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Timetable"),
//         ],
//       ),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   final String username;
//   HomeScreen({required this.username});
//
//   final List<String> imageList = [
//     'assets/images/img1.png',
//     'assets/images/img2.png',
//     'assets/images/img1.png',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               "Hello, $username",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//           ),
//           CarouselSlider(
//             items: imageList.map((imagePath) {
//               return ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
//               );
//             }).toList(),
//             options: CarouselOptions(
//               autoPlay: true,
//               autoPlayInterval: Duration(seconds: 3),
//               enlargeCenterPage: true,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Container(
//                   height: 100,
//                   margin: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 Container(
//                   height: 100,
//                   margin: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 Container(
//                   height: 100,
//                   margin: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class AttendanceScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Attendance Screen'));
//   }
// }
//
// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Profile Screen'));
//   }
// }
//
// class NotificationsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Notifications Screen'));
//   }
// }
//
// class TimetableScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Timetable Screen'));
//   }
// }
//
