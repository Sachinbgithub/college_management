import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _notifications = [];
  bool _loadingNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
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

  void _markNotificationAsRead(String id) async {
    try {
      String userId = _auth.currentUser?.uid ?? '';
      await _firestore.collection('notifications').doc(id).update({
        'readBy': FieldValue.arrayUnion([userId]),
      });

      // Update local state
      setState(() {
        _notifications = _notifications.map((notification) {
          if (notification['id'] == id) {
            notification['read'] = true;
          }
          return notification;
        }).toList();
      });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _loadingNotifications
          ? Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? Center(child: Text('No notifications available'))
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
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
