import 'package:flutter/material.dart';
import 'drawer_menu.dart';
import 'navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  final String role;
  HomeScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout logic here
            },
          ),
        ],
      ),
      drawer: DrawerMenu(),
      body: NavigationBarWidget(),
    );
  }
}
