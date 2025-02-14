import 'package:flutter/material.dart';
import 'home_screen.dart';

class RoleBasedHome extends StatelessWidget {
  final String role;
  RoleBasedHome({required this.role});

  @override
  Widget build(BuildContext context) {
    return HomeScreen(role: role);
  }
}
