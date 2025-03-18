import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StaffProfile extends StatefulWidget {
  const StaffProfile({super.key});

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  final List<String> profilePictures = [
    'assets/profile/img.png',
    'assets/profile/img_1.png',
    'assets/profile/img_2.png',
    'assets/profile/img_3.png',
    'assets/profile/img_4.png',
    'assets/profile/img_5.png',
  ];

  int _selectedProfileIndex = 0;

  Future<Map<String, dynamic>> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return {
            'name': doc['name'] ?? 'Guest',
            'email': doc['email'] ?? 'No Email',
            'profilePictureIndex': doc['profilePictureIndex'] ?? 0,
          };
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
    // Return default data if user is not found
    return {'name': 'Guest', 'email': 'No Email', 'profilePictureIndex': 0};
  }

  void _updateProfilePicture(int index) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'profilePictureIndex': index,
        });
        setState(() {
          _selectedProfileIndex = index;
        });
      } catch (e) {
        print("Error updating profile picture: $e");
      }
    }
  }

  Widget _buildProfileHeader(Map<String, dynamic> userData) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(profilePictures[userData['profilePictureIndex'] ?? 0]),
        ),
        const SizedBox(height: 16),
        Text(
          userData['name'] ?? 'Guest',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          userData['email'] ?? 'No Email',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> userData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Staff Profile",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Staff",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text("Name: ${userData['name'] ?? 'Guest'}", style: const TextStyle(fontSize: 16)),
            Text("Email: ${userData['email'] ?? 'No Email'}", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSelection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(profilePictures.length, (index) {
          return GestureDetector(
            onTap: () => _updateProfilePicture(index),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(profilePictures[index]),
                child: _selectedProfileIndex == index
                    ? const Icon(Icons.check_circle, color: Colors.green, size: 30)
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.blue[50]),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading profile"));
          }
          final userData = snapshot.data ?? {'name': 'Guest', 'email': 'No Email', 'profilePictureIndex': 0};
          _selectedProfileIndex = userData['profilePictureIndex']; // Ensure index is updated

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileHeader(userData),
                  const SizedBox(height: 24),
                  _buildStaffCard(userData),
                  const SizedBox(height: 24),
                  const Text("Select Avatar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildAvatarSelection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class StaffProfile extends StatefulWidget {
//   const StaffProfile({super.key, required String studentId});
//
//   @override
//   State<StaffProfile> createState() => _staffProfilePageState();
// }
//
// class _staffProfilePageState extends State<StaffProfile> {
//   final TextEditingController _nameController = TextEditingController();
//   final bool _isEditing = false;
//   final bool _isLoading = false;
//   final int _selectedProfileIndex = 0;
//
//   final List<String> profilePictures = [
//     'assets/profile/img.png',
//     'assets/profile/img_1.png',
//     'assets/profile/img_2.png',
//     'assets/profile/img_3.png',
//     'assets/profile/img_4.png',
//     'assets/profile/img_5.png',
//   ];
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }
//
//   Future<Map<String, dynamic>?> _getUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       return doc.data();
//     }
//     return {'name': 'Guest', 'email': 'No Email', 'profilePictureIndex': 0, 'rewardPoints': 0, 'dailyStreak': 0, 'dailyQuizScores': []};
//   }
//
//   Widget _buildProfileHeader(Map<String, dynamic> userData) {
//     _nameController.text = userData['name'] ?? 'Guest';
//
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 50,
//           backgroundImage: AssetImage(profilePictures[userData['profilePictureIndex'] ?? 0]),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           userData['name'] ?? 'Guest',
//           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           userData['email'] ?? 'No Email',
//           style: const TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStats(Map<String, dynamic> userData) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _StatCard(title: 'Reward Points', value: userData['rewardPoints']?.toString() ?? '0', icon: Icons.star),
//             _StatCard(title: 'Daily Streak', value: userData['dailyStreak']?.toString() ?? '0', icon: Icons.local_fire_department),
//           ],
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[50],
//       appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.blue[50]),
//       body: FutureBuilder<Map<String, dynamic>?> (
//         future: _getUserData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final userData = snapshot.data ?? {};
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildProfileHeader(userData),
//                   const SizedBox(height: 24),
//                   _buildStats(userData),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _StatCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//
//   const _StatCard({required this.title, required this.value, required this.icon});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         child: Column(
//           children: [
//             Icon(icon, size: 32, color: Theme.of(context).primaryColor),
//             const SizedBox(height: 8),
//             Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
//             const SizedBox(height: 4),
//             Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
