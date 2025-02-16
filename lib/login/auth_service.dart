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

  signOut() {}
}