import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text("Menu")),
          ListTile(
            title: Text("Sign Out"),
            onTap: () {
              // Implement sign-out logic
            },
          ),
        ],
      ),
    );
  }
}
