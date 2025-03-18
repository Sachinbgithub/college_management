import 'package:college_management/staff/staff_profile.dart';
import 'package:college_management/staff/view_attendance.dart';
import 'package:college_management/staff/view_timetable.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login/auth_service.dart';
import '../student/NotificationsScreen.dart';

import '../student/timetablePage.dart';
import 'mark_attendance.dart';

class FacultyDashboard extends StatefulWidget {
  @override
  _FacultyDashboardState createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Faculty Dashboard',
          style: TextStyle(color: Colors.grey[800]),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildAnnouncementsCard(),
            SizedBox(height: 20),
            _buildQuickActionsCard(),
            SizedBox(height: 20),
            _buildNotificationsCard(),
            SizedBox(height: 20),
            _buildStudentListCard(),
            SizedBox(height: 20),
            _buildProfileCard(),
          ],
        ),
      ),
    );
  }

  // Build Navigation Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[600],
            ),
            child: Text(
              'Faculty Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('View Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StaffProfile()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('View Students'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewStudentsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('View TimeTable'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.view_list),
            title: Text('View Attendance'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewAttendancePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text('Mark Attendance'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AttendancePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              AuthService().signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }

  // Build Announcements Card
  Widget _buildAnnouncementsCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Announcements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[600]),
            ),
            SizedBox(height: 10),
            Text('Welcome to the Faculty Dashboard! Here you can manage students, mark attendance, and view notifications.'),
          ],
        ),
      ),
    );
  }

  // Redesigned Quick Actions Card with 3 Buttons
  Widget _buildQuickActionsCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white.withOpacity(0.9), // Soft transparency effect
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Header with Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
                Icon(Icons.flash_on, color: Colors.blue, size: 24),
              ],
            ),
            SizedBox(height: 12),

            // 🎯 Action Buttons with Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.check_circle_outline,
                  label: 'Mark Attendance',
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AttendancePage()));
                  },
                ),
                _buildActionButton(
                  icon: Icons.visibility,
                  label: 'View Attendance',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAttendancePage()));
                  },
                ),
                _buildActionButton(
                  icon: Icons.schedule,
                  label: 'View Timetable',
                  color: Colors.blue
                  ,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Custom Action Button Widget
  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: color),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
      ],
    );
  }


  // Build Notifications Card
  Widget _buildNotificationsCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[600]),
            ),
            SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('notifications').orderBy('timestamp', descending: true).limit(5).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var notifications = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    var notification = notifications[index];
                    Map<String, dynamic> notificationData = notification.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(notificationData['title']),
                      subtitle: Text(notificationData['message']),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Build Student List Card
  Widget _buildStudentListCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[600]),
            ),
            SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').where('userType', isEqualTo: 'student').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var students = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    var student = students[index];
                    Map<String, dynamic> studentData = student.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(studentData['name']),
                      subtitle: Text('Enrollment Number: ${studentData['enrollmentNumber']}'),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Build Profile Card
  Widget _buildProfileCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Faculty Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[600]),
            ),
            SizedBox(height: 10),
            StreamBuilder<DocumentSnapshot>(
              stream: _firestore.collection('faculty').doc(_auth.currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var facultyDoc = snapshot.data!.data();
                if (facultyDoc == null) {
                  return Center(child: Text('No data available'));
                }
                Map<String, dynamic> faculty = facultyDoc as Map<String, dynamic>;
                return Column(
                  children: [
                    ListTile(
                      title: Text('Name'),
                      subtitle: Text(faculty['name'] ?? 'Not specified'),
                    ),
                    ListTile(
                      title: Text('Email'),
                      subtitle: Text(faculty['email'] ?? 'Not specified'),
                    ),
                    ListTile(
                      title: Text('Department'),
                      subtitle: Text(faculty['department'] ?? 'Not specified'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Example Page for Viewing Profile
class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('faculty').doc(_auth.currentUser?.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var facultyDoc = snapshot.data!.data();
            if (facultyDoc == null) {
              return Center(child: Text('No data available'));
            }
            Map<String, dynamic> faculty = facultyDoc as Map<String, dynamic>;
            return Column(
              children: [
                ListTile(
                  title: Text('Name'),
                  subtitle: Text(faculty['name'] ?? 'Not specified'),
                ),
                ListTile(
                  title: Text('Email'),
                  subtitle: Text(faculty['email'] ?? 'Not specified'),
                ),
                ListTile(
                  title: Text('Department'),
                  subtitle: Text(faculty['department'] ?? 'Not specified'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to edit profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()),
                    );
                  },
                  child: Text('Edit Profile'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Example Page for Editing Profile
class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _name = 'sam';
  String _email = 'sam@g.com';
  String _department = 'cse';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('faculty').doc(_auth.currentUser?.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var facultyDoc = snapshot.data!.data();
            if (facultyDoc == null) {
              return Center(child: Text('No data available'));
            }
            Map<String, dynamic> faculty = facultyDoc as Map<String, dynamic>;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: faculty['name'],
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value!,
                  ),
                  TextFormField(
                    initialValue: faculty['email'],
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                  ),
                  TextFormField(
                    initialValue: faculty['department'],
                    decoration: InputDecoration(labelText: 'Department'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your department';
                      }
                      return null;
                    },
                    onSaved: (value) => _department = value!,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _firestore.collection('faculty').doc(_auth.currentUser?.uid).update({
                          'name': _name,
                          'email': _email,
                          'department': _department,
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


// Example Page for Viewing Students
class ViewStudentsPage extends StatefulWidget {
  @override
  _ViewStudentsPageState createState() => _ViewStudentsPageState();
}

class _ViewStudentsPageState extends State<ViewStudentsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Students'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').where('userType', isEqualTo: 'student').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var students = snapshot.data!.docs;
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                var student = students[index];
                Map<String, dynamic> studentData = student.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(studentData['name']),
                  subtitle: Text('Enrollment Number: ${studentData['enrollmentNumber']}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// Example AuthService class for handling sign
