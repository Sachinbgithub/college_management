// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { admin, faculty, student }

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  UserType? _userType;

  User? get user => _user;
  UserType? get userType => _userType;

  Future<String?> registerUser({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? enrollmentNumber,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Create user profile in Firestore
        await _firestore.collection('users').doc(result.user!.uid).set({
          'email': email,
          'name': name,
          'userType': userType.toString().split('.').last,
          'profileStatus': userType == UserType.faculty ? 'pending' : 'active',
          'enrollmentNumber': enrollmentNumber,
          'createdAt': FieldValue.serverTimestamp(),
        });

        _user = result.user;
        _userType = userType;
        notifyListeners();
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return 'Registration failed';
  }

  Future<String?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Get user data from Firestore
        DocumentSnapshot userData = await _firestore
            .collection('users')
            .doc(result.user!.uid)
            .get();

        if (!userData.exists) {
          return 'User data not found';
        }

        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;

        // Check if faculty is verified
        if (data['userType'] == 'faculty' && data['profileStatus'] == 'pending') {
          return 'Your account is pending approval';
        }

        _user = result.user;
        _userType = UserType.values.firstWhere(
                (e) => e.toString().split('.').last == data['userType']
        );

        notifyListeners();
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return 'Login failed';
  }
  // Add this method to your AuthService class
  Future<List<Map<String, dynamic>>> getPendingFacultyAccounts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('userType', isEqualTo: 'faculty')
          .where('profileStatus', isEqualTo: 'pending')
          .get();

      List<Map<String, dynamic>> facultyList = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        facultyList.add({
          'id': doc.id,
          'name': data['name'],
          'email': data['email'],
          'createdAt': data['createdAt'],
        });
      }
      return facultyList;
    } catch (e) {
      print('Error getting pending faculty accounts: $e');
      return [];
    }
  }

// Add this method to approve a faculty account
  Future<bool> approveFacultyAccount(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'profileStatus': 'active',
      });
      return true;
    } catch (e) {
      print('Error approving faculty account: $e');
      return false;
    }
  }

// Add this method to reject a faculty account (optional)
  Future<bool> rejectFacultyAccount(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'profileStatus': 'rejected',
      });
      return true;
    } catch (e) {
      print('Error rejecting faculty account: $e');
      return false;
    }
  }

  // Get the dashboard route based on user type
  String getDashboardRoute() {
    switch (_userType) {
      case UserType.admin:
        return '/admin_dashboard';
      case UserType.faculty:
        return '/faculty_dashboard';
      case UserType.student:
        return '/home';
      default:
        return '/home'; // Fallback route
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _userType = null;
    notifyListeners();
  }

  Future<void> checkAuthState() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot userData = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .get();

      if (userData.exists) {
        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
        _userType = UserType.values.firstWhere(
                (e) => e.toString().split('.').last == data['userType']
        );
      }
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await logout();
  }
}