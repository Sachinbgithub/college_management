import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: StreamBuilder(
        stream: _firestore.collection("notifications").orderBy("timestamp", descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var notifications = snapshot.data!.docs;

          if (notifications.isEmpty) {
            return Center(
              child: Text("No notifications yet!", style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              bool isRead = notification["isRead"] ?? false;

              return Dismissible(
                key: Key(notification.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  _firestore.collection("notifications").doc(notification.id).delete();
                },
                child: ListTile(
                  tileColor: isRead ? Colors.white : Colors.blue.shade50,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade700,
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                  title: Text(notification["title"], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(notification["message"]),
                  trailing: Text(
                    _formatTimestamp(notification["timestamp"]),
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  onTap: () {
                    _markAsRead(notification.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('MMM d, h:mm a').format(date);
  }

  void _markAsRead(String docId) {
    _firestore.collection("notifications").doc(docId).update({"isRead": true});
  }
}

