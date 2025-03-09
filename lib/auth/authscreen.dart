//
//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   bool isLogin = true;
//   String selectedRole = 'user';
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//
//   Future<void> _signup(String email, String password, String role) async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
//         'email': email,
//         'role': role,
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Signup Successful!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Signup Failed: $e')),
//       );
//     }
//   }
//
//   Future<void> _login(String email, String password) async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
//
//       if (userDoc.exists) {
//         String role = userDoc['role'];
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Login Successful as $role')),
//         );
//
//         // Navigate based on role
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => RoleScreen(role: role)),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('No user found with this role.')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Login Failed: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Login and Signup Toggle
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       isLogin = true;
//                     });
//                   },
//                   child: Text(
//                     "Login",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: isLogin ? Colors.green : Colors.grey,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 30),
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       isLogin = false;
//                     });
//                   },
//                   child: Text(
//                     "Signup",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: !isLogin ? Colors.green : Colors.grey,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             // Form Section
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.email, color: Colors.green),
//                     ),
//                   ),
//                   SizedBox(height: 15),
//                   TextField(
//                     controller: passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.lock, color: Colors.green),
//                     ),
//                   ),
//                   if (!isLogin) ...[
//                     SizedBox(height: 15),
//                     TextField(
//                       controller: confirmPasswordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         labelText: 'Confirm Password',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.lock, color: Colors.green),
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     DropdownButtonFormField<String>(
//                       value: selectedRole,
//                       items: ['user', 'admin', 'rider', 'hotel'].map((String role) {
//                         return DropdownMenuItem<String>(
//                           value: role,
//                           child: Text(role),
//                         );
//                       }).toList(),
//                       onChanged: (String? newRole) {
//                         setState(() {
//                           selectedRole = newRole!;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         labelText: 'Select Role',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ],
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (isLogin) {
//                         _login(emailController.text, passwordController.text);
//                       } else {
//                         if (passwordController.text == confirmPasswordController.text) {
//                           _signup(emailController.text, passwordController.text, selectedRole);
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Passwords do not match!')),
//                           );
//                         }
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 30,
//                         vertical: 15,
//                       ),
//                     ),
//                     child: Text(
//                       isLogin ? 'Login' : 'Signup',
//                       style: TextStyle(fontSize: 18, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class RoleScreen extends StatelessWidget {
//   final String role;
//
//   RoleScreen({required this.role});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Welcome $role')),
//       body: Center(
//         child: Text(
//           'Logged in as $role',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
//
