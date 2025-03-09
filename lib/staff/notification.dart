import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class Notification {
  final String title;
  final String content;
  final DateTime timestamp;

  Notification({
    required this.title,
    required this.content,
    required this.timestamp,
  });
}

class NotificationsPage extends StatelessWidget {
  // Dummy notification data
  final List<Notification> notifications = [
    Notification(
      title: 'Upcoming Lecture: Data Structures',
      content: 'Reminder: Data Structures lecture will be held on Feb 20, 2025 at 10:00 AM in Room 201.',
      timestamp: DateTime(2025, 2, 17, 8, 0), // Example: 8:00 AM today
    ),
    Notification(
      title: 'University Holiday',
      content: 'Notice: University will be closed on Feb 24, 2025 for President\'s Day.',
      timestamp: DateTime(2025, 2, 15, 12, 0), // Example: Two days ago
    ),
    Notification(
      title: 'Special Event: Tech Expo',
      content: 'Announcement: The annual Tech Expo will be held on March 5, 2025. All students and faculty are invited.',
      timestamp: DateTime(2025, 2, 10, 16, 0), // Example: A week ago
    ),
    Notification(
      title: 'Faculty Meeting',
      content: 'Reminder: Faculty meeting scheduled for Feb 28, 2025 at 2:00 PM in the Conference Hall.',
      timestamp: DateTime(2025, 2, 16, 9, 0), // Example: Yesterday
    ),
    Notification(
      title: 'Guest Lecture: AI Trends',
      content: 'Dr. Emily Carter will be giving a guest lecture on AI Trends on March 10, 2025, at 11:00 AM in the Auditorium.',
      timestamp: DateTime(2025, 2, 12, 10, 0), // Example: Five days ago
    ),
  ];

  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sort notifications by timestamp in descending order (most recent first)
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    notification.content,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Time: ${DateFormat('MMM dd, yyyy - hh:mm a').format(notification.timestamp)}', // Format the timestamp
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      // You can add an "Archive" button or other actions here if needed
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
