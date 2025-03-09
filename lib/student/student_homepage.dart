import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User data
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _notifications = [];
  Map<String, dynamic>? _timetable;
  List<Map<String, dynamic>> _attendance = [];

  // Loading states
  bool _loadingProfile = true;
  bool _loadingNotifications = true;
  bool _loadingTimetable = true;
  bool _loadingAttendance = true;

  // Selected index for bottom navigation
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadNotifications();
    _loadTimetable();
    _loadAttendance();
  }

  // Load user profile data
  Future<void> _loadUserData() async {
    setState(() => _loadingProfile = true);
    try {
      String userId = _auth.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
        setState(() {
          _userData = doc.data() as Map<String, dynamic>?;
          _loadingProfile = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() => _loadingProfile = false);
    }
  }

  Future<void> _loadNotifications() async {
    setState(() => _loadingNotifications = true);
    try {
      String userId = _auth.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        // Get all notifications
        QuerySnapshot query = await _firestore.collection('notifications')
            .orderBy('timestamp', descending: true)
            .get();

        List<Map<String, dynamic>> notifications = [];
        for (var doc in query.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          notifications.add({
            'id': doc.id,
            'title': data['title'] ?? 'No Title',
            'message': data['message'] ?? 'No Message',
            'timestamp': data['timestamp'] ?? Timestamp.now(),
            'read': data['readBy']?.contains(userId) ?? false,
          });
        }

        setState(() {
          _notifications = notifications;
          _loadingNotifications = false;
        });
      }
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() => _loadingNotifications = false);
    }
  }

  Future<void> _loadTimetable() async {
    setState(() => _loadingTimetable = true);
    try {
      String userId = _auth.currentUser?.uid ?? '';
      String? enrollmentNumber = _userData?['enrollmentNumber'];

      if (userId.isNotEmpty && enrollmentNumber != null) {
        // Try to find timetable for this student's specific class/batch
        QuerySnapshot query = await _firestore.collection('timetables')
            .where('class', isEqualTo: _userData?['class'] ?? '')
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          setState(() {
            _timetable = query.docs.first.data() as Map<String, dynamic>;
            _loadingTimetable = false;
          });
        } else {
          // If no specific timetable found, check for the default timetable
          DocumentSnapshot doc = await _firestore.collection('timetables')
              .doc('default')
              .get();

          if (doc.exists) {
            setState(() {
              _timetable = doc.data() as Map<String, dynamic>;
              _loadingTimetable = false;
            });
          } else {
            setState(() => _loadingTimetable = false);
          }
        }
      }
    } catch (e) {
      print('Error loading timetable: $e');
      setState(() => _loadingTimetable = false);
    }
  }

  // Load student's attendance records
  Future<void> _loadAttendance() async {
    setState(() => _loadingAttendance = true);
    try {
      String userId = _auth.currentUser?.uid ?? '';
      String? enrollmentNumber = _userData?['enrollmentNumber'];

      if (userId.isNotEmpty && enrollmentNumber != null) {
        QuerySnapshot query = await _firestore.collection('attendance')
            .where('studentId', isEqualTo: userId)
            .orderBy('date', descending: true)
            .get();

        List<Map<String, dynamic>> attendance = [];
        for (var doc in query.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          attendance.add({
            'id': doc.id,
            'date': data['date'] ?? Timestamp.now(),
            'status': data['status'] ?? 'absent',
            'subject': data['subject'] ?? 'Unknown',
            'markedBy': data['markedBy'] ?? 'System',
          });
        }

        setState(() {
          _attendance = attendance;
          _loadingAttendance = false;
        });
      }
    } catch (e) {
      print('Error loading attendance: $e');
      setState(() => _loadingAttendance = false);
    }
  }

  // Mark notification as read
  Future<void> _markNotificationAsRead(String notificationId) async {
    try {
      String userId = _auth.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        await _firestore.collection('notifications').doc(notificationId).update({
          'readBy': FieldValue.arrayUnion([userId]),
        });

        // Update local state
        setState(() {
          for (var notification in _notifications) {
            if (notification['id'] == notificationId) {
              notification['read'] = true;
            }
          }
        });
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Function to handle navigation bar item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Helper to format timestamp
  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    return DateFormat('MMM dd, yyyy').format(timestamp.toDate());
  }

  // Helper to format time
  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    return DateFormat('hh:mm a').format(timestamp.toDate());
  }

  // Calculate attendance percentage
  double _calculateAttendancePercentage() {
    if (_attendance.isEmpty) return 0.0;
    int present = _attendance.where((a) => a['status'] == 'present').length;
    return (present / _attendance.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    // Define the pages for the bottom navigation
    final List<Widget> pages = [
      _buildHomeTab(),
      _buildProfileTab(),
      _buildTimetableTab(),
      _buildAttendanceTab(),
      _buildNotificationsTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadUserData();
              _loadNotifications();
              _loadTimetable();
              _loadAttendance();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Refreshing data...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Required for more than 3 items
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Timetable',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }

  // Home tab - Overview of student data
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${_loadingProfile ? 'Loading...' : _userData?['name'] ?? 'Student'}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enrollment: ${_loadingProfile ? 'Loading...' : _userData?['enrollmentNumber'] ?? 'Not available'}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          IconButton(
            icon: const Icon(Icons.next_week),
            onPressed: () {
              Navigator.of(context).pushNamed('/admin_dashboard');
            },
          ),
          // Quick stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Attendance',
                  '${_loadingAttendance ? '--' : _calculateAttendancePercentage().toStringAsFixed(1)}%',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Notifications',
                  _loadingNotifications ? '--' : _notifications.where((n) => !n['read']).length.toString(),
                  Icons.notifications_active,
                  Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Recent notifications
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _loadingNotifications
                      ? const Center(child: CircularProgressIndicator())
                      : _notifications.isEmpty
                      ? const Center(child: Text('No notifications'))
                      : Column(
                    children: _notifications
                        .take(3)
                        .map((notification) => ListTile(
                      title: Text(notification['title']),
                      subtitle: Text(
                        notification['message'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(_formatDate(notification['timestamp'])),
                    ))
                        .toList(),
                  ),
                  if (!_loadingNotifications && _notifications.isNotEmpty)
                    TextButton(
                      onPressed: () => _onItemTapped(4), // Switch to notifications tab
                      child: const Text('View All'),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Today's classes
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Classes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _loadingTimetable
                      ? const Center(child: CircularProgressIndicator())
                      : _timetable == null
                      ? const Center(child: Text('No timetable available'))
                      : _buildTodayClasses(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for stat cards
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build today's classes from timetable
  Widget _buildTodayClasses() {
    if (_timetable == null) return const Text('No timetable data available');

    // Get today's day of week
    String today = DateFormat('EEEE').format(DateTime.now()).toLowerCase();

    // Check if there are classes for today
    if (!_timetable!.containsKey(today) || (_timetable![today] as List).isEmpty) {
      return const Center(child: Text('No classes scheduled for today'));
    }

    // Build the list of today's classes
    List<dynamic> todayClasses = _timetable![today] as List;
    return Column(
      children: todayClasses.map<Widget>((classData) {
        return ListTile(
          leading: Icon(Icons.class_),
          title: Text(classData['subject'] ?? 'Unknown Subject'),
          subtitle: Text('${classData['startTime']} - ${classData['endTime']}'),
          trailing: Text(classData['room'] ?? 'TBD'),
        );
      }).toList(),
    );
  }

  // Profile tab
  Widget _buildProfileTab() {
    return _loadingProfile
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Profile avatar
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 20),
          // Student name
          Text(
            _userData?['name'] ?? 'Student Name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _userData?['email'] ?? 'student@example.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          // Profile details card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileRow('Enrollment Number', _userData?['enrollmentNumber'] ?? 'Not available'),
                  _buildProfileRow('User Type', _userData?['userType'] ?? 'Student'),
                  _buildProfileRow('Status', _userData?['profileStatus'] ?? 'Active'),
                  _buildProfileRow('Joined On', _userData?['createdAt'] != null
                      ? _formatDate(_userData?['createdAt'])
                      : 'Not available'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Edit profile button
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement edit profile functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile feature coming soon')),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  // Helper for profile rows
  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Timetable tab
  Widget _buildTimetableTab() {
    return _loadingTimetable
        ? const Center(child: CircularProgressIndicator())
        : _timetable == null
        ? const Center(child: Text('No timetable available'))
        : DefaultTabController(
      length: 7,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Monday'),
              Tab(text: 'Tuesday'),
              Tab(text: 'Wednesday'),
              Tab(text: 'Thursday'),
              Tab(text: 'Friday'),
              Tab(text: 'Saturday'),
              Tab(text: 'Sunday'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildDayTimetable('monday'),
                _buildDayTimetable('tuesday'),
                _buildDayTimetable('wednesday'),
                _buildDayTimetable('thursday'),
                _buildDayTimetable('friday'),
                _buildDayTimetable('saturday'),
                _buildDayTimetable('sunday'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build timetable for a specific day
  Widget _buildDayTimetable(String day) {
    if (!_timetable!.containsKey(day) || (_timetable![day] as List).isEmpty) {
      return const Center(child: Text('No classes scheduled for this day'));
    }

    List<dynamic> classes = _timetable![day] as List;
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) {
        var classData = classes[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${classData['startTime']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(classData['subject'] ?? 'Unknown Subject'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Room: ${classData['room'] ?? 'TBD'}'),
                Text('${classData['startTime']} - ${classData['endTime']}'),
              ],
            ),
            trailing: Text(
              classData['teacher'] ?? 'TBA',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        );
      },
    );
  }

  // Attendance tab
  Widget _buildAttendanceTab() {
    return _loadingAttendance
        ? const Center(child: CircularProgressIndicator())
        : Column(
      children: [
        // Attendance summary card
        Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Attendance Summary',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAttendanceStat(
                      'Present',
                      _attendance.where((a) => a['status'] == 'present').length.toString(),
                      Colors.green,
                    ),
                    _buildAttendanceStat(
                      'Absent',
                      _attendance.where((a) => a['status'] == 'absent').length.toString(),
                      Colors.red,
                    ),
                    _buildAttendanceStat(
                      'Percentage',
                      '${_calculateAttendancePercentage().toStringAsFixed(1)}%',
                      Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Attendance records list
        Expanded(
          child: _attendance.isEmpty
              ? const Center(child: Text('No attendance records available'))
              : ListView.builder(
            itemCount: _attendance.length,
            itemBuilder: (context, index) {
              var record = _attendance[index];
              bool isPresent = record['status'] == 'present';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: ListTile(
                  leading: Icon(
                    isPresent ? Icons.check_circle : Icons.cancel,
                    color: isPresent ? Colors.green : Colors.red,
                    size: 32,
                  ),
                  title: Text(record['subject'] ?? 'Unknown Subject'),
                  subtitle: Text(_formatDate(record['date'])),
                  trailing: Text(
                    isPresent ? 'Present' : 'Absent',
                    style: TextStyle(
                      color: isPresent ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper for attendance stats
  Widget _buildAttendanceStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Notifications tab
  Widget _buildNotificationsTab() {
    return _loadingNotifications
        ? const Center(child: CircularProgressIndicator())
        : _notifications.isEmpty
        ? const Center(child: Text('No notifications available'))
        : ListView.builder(
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        var notification = _notifications[index];
        bool isRead = notification['read'];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: ListTile(
            leading: Icon(
              isRead ? Icons.mark_email_read : Icons.mark_email_unread,
              color: isRead ? Colors.grey : Colors.blue,
            ),
            title: Text(
              notification['title'],
              style: TextStyle(
                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification['message'], maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  _formatDate(notification['timestamp']),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            onTap: () {
              // Show full notification in dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(notification['title']),
                  content: Text(notification['message']),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );

              // Mark as read if not already read
              if (!isRead) {
                _markNotificationAsRead(notification['id']);
              }
            },
          ),
        );
      },
    );
  }
}