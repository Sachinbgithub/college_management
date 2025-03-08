import 'package:college_management/admin/manage_user.dart';
import 'package:flutter/material.dart';
import 'notify.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Panel")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Admin Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Manage Users"),
              onTap: () => _navigateToScreen(context, ManageUsersScreen()),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text("Send Message"),
              onTap: () => _navigateToScreen(context, AdminMessageScreen()),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Send Notification"),
              onTap: () => _navigateToScreen(context, AdminNotificationScreen()),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Aligns buttons properly
          children: [
            _animatedButton(context, "Manage Users", Icons.people, Colors.blue, ManageUsersScreen()),
            SizedBox(height: 20),
            _animatedButton(context, "Send Message", Icons.message, Colors.green, AdminMessageScreen()),
            SizedBox(height: 20),
            _animatedButton(context, "Send Notification", Icons.notifications, Colors.orange, AdminNotificationScreen()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _animatedButton(BuildContext context, String text, IconData icon, Color color, Widget screen) {
    return ElevatedButton.icon(
      onPressed: () => _navigateToScreen(context, screen),
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
      ),
    );
  }
}

// Dummy screens (replace with actual screen widgets)
class AdminMessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Message")),
      body: Center(child: Text("Send Message Screen Coming Soon!", style: TextStyle(fontSize: 22))),
    );
  }
}

class AdminNotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Notification")),
      body: Center(child: Text("Send Notification Screen Coming Soon!", style: TextStyle(fontSize: 22))),
    );
  }
}





// import 'package:college_management/admin/manage_user.dart';
// import 'package:flutter/material.dart';
//
// import 'notify.dart';
//
// class AdminPanel extends StatefulWidget {
//   @override
//   _AdminPanelState createState() => _AdminPanelState();
// }
//
// class _AdminPanelState extends State<AdminPanel> {
//   int _selectedIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   void _navigateToScreen(BuildContext context, String screenName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => PlaceholderScreen(screenName: screenName)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Admin Panel"),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blue),
//               child: Text('Admin Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
//             ),
//             ListTile(
//               leading: Icon(Icons.people),
//               title: Text("Manage Users"),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ManageUsersScreen()),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.message),
//               title: Text("Send Message"),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => AdminMessageScreen()),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.notifications),
//               title: Text("Send Notification"),
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => AdminMessageScreen()),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _animatedButton(context, "Manage Users", Icons.people, Colors.blue),
//             SizedBox(height: 20),
//             _animatedButton(context, "Send Message", Icons.message, Colors.green),
//             SizedBox(height: 20),
//             _animatedButton(context, "Send Notification", Icons.notifications, Colors.orange),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
//
//   Widget _animatedButton(BuildContext context, String text, IconData icon, Color color) {
//     return ElevatedButton.icon(
//       onPressed: () => _navigateToScreen(context, text),
//       icon: Icon(icon, color: Colors.white),
//       label: Text(text, style: TextStyle(fontSize: 18)),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 8,
//       ),
//     );
//   }
// }
//
// class PlaceholderScreen extends StatelessWidget {
//   final String screenName;
//
//   PlaceholderScreen({required this.screenName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(screenName)),
//       body: Center(child: Text("$screenName Screen Coming Soon!", style: TextStyle(fontSize: 22))),
//     );
//   }
// }
//
//
//
//
// // import 'package:flutter/material.dart';
// //
// // class AdminPanelScreen extends StatefulWidget {
// //   @override
// //   _AdminPanelScreenState createState() => _AdminPanelScreenState();
// // }
// //
// // class _AdminPanelScreenState extends State<AdminPanelScreen> {
// //   List<String> users = ['Student 1', 'Teacher 1', 'Student 2'];
// //   Map<String, String> timetable = {
// //     'Monday': 'Math - 10:00 AM',
// //     'Tuesday': 'Science - 11:00 AM',
// //   };
// //
// //   final TextEditingController _userController = TextEditingController();
// //   final TextEditingController _dayController = TextEditingController();
// //   final TextEditingController _timeController = TextEditingController();
// //
// //   void addUser() {
// //     if (_userController.text.isNotEmpty) {
// //       setState(() {
// //         users.add(_userController.text);
// //         _userController.clear();
// //       });
// //     }
// //   }
// //
// //   void deleteUser(int index) {
// //     setState(() {
// //       users.removeAt(index);
// //     });
// //   }
// //
// //   void updateTimetable() {
// //     if (_dayController.text.isNotEmpty && _timeController.text.isNotEmpty) {
// //       setState(() {
// //         timetable[_dayController.text] = _timeController.text;
// //         _dayController.clear();
// //         _timeController.clear();
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //         content: Text("Timetable Updated!"),
// //       ));
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Admin Panel')),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text("Manage Users", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //               TextField(
// //                 controller: _userController,
// //                 decoration: InputDecoration(labelText: "Enter User Name"),
// //               ),
// //               ElevatedButton(onPressed: addUser, child: Text("Add User")),
// //               SizedBox(height: 10),
// //               ListView.builder(
// //                 shrinkWrap: true,
// //                 itemCount: users.length,
// //                 itemBuilder: (context, index) {
// //                   return ListTile(
// //                     title: Text(users[index]),
// //                     trailing: IconButton(
// //                       icon: Icon(Icons.delete, color: Colors.red),
// //                       onPressed: () => deleteUser(index),
// //                     ),
// //                   );
// //                 },
// //               ),
// //               Divider(),
// //               Text("Update Timetable", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //               TextField(
// //                 controller: _dayController,
// //                 decoration: InputDecoration(labelText: "Enter Day"),
// //               ),
// //               TextField(
// //                 controller: _timeController,
// //                 decoration: InputDecoration(labelText: "Enter Time & Subject"),
// //               ),
// //               ElevatedButton(onPressed: updateTimetable, child: Text("Update Timetable")),
// //               SizedBox(height: 10),
// //               Column(
// //                 children: timetable.keys.map((day) {
// //                   return ListTile(
// //                     title: Text("$day: ${timetable[day]}"),
// //                   );
// //                 }).toList(),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
