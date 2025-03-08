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
              onTap: () => _navigateToScreen(context, AdminMessageScreen()),
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
            _animatedButton(context, "Send Notification", Icons.notifications, Colors.orange, AdminMessageScreen()),
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


