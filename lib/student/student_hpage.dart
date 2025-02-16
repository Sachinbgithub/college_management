import 'package:college_management/student/AttendanceScreen.dart';
import 'package:college_management/student/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:animate_do/animate_do.dart';

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
  int _currentIndex = 0;

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
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', (route) => false);
    }
  }

  final List<Widget> _screens = [
    HomeScreen(username: "User"),
    AttendanceScreen(studentId: '',),
    StudentProfile(),
    NotificationsScreen(),
    TimetableScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
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
      body: IndexedStack(
        index: _currentIndex,
        children: _screens.map((screen) {
          if (screen is HomeScreen) {
            return HomeScreen(username: username);
          }
          return screen;
        }).toList(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.grey.shade300,
        buttonBackgroundColor: Colors.white,
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        items: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.check, 1),
          _buildNavItem(Icons.person, 2),
          _buildNavItem(Icons.notifications, 3),
          _buildNavItem(Icons.calendar_today, 4),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return _currentIndex == index
        ? Bounce(
      duration: Duration(milliseconds: 300),
      child: Icon(icon, size: 35, color: Colors.black),
    )
        : Icon(icon, size: 30, color: Colors.grey);
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
        ],
      ),
    );
  }
}


class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Notifications Screen'));
  }
}

class TimetableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Timetable Screen'));
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
