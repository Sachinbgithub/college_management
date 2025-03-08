import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageUsersScreen extends StatefulWidget {
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _enrollmentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedRole = 'Student';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addUser() async {
    if (_formKey.currentState!.validate()) {
      await _firestore.collection('users').add({
        'name': _nameController.text,
        'branch': _branchController.text,
        'enrollment': _enrollmentController.text,
        'role': _selectedRole,
        'email': _emailController.text,
        'phone': _phoneController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User Added Successfully"), backgroundColor: Colors.green),
      );

      _nameController.clear();
      _branchController.clear();
      _enrollmentController.clear();
      _emailController.clear();
      _phoneController.clear();
    }
  }

  void _deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User Deleted"), backgroundColor: Colors.red),
    );
  }

  void _editUser(String userId, Map<String, dynamic> userData) {
    _nameController.text = userData['name'];
    _branchController.text = userData['branch'];
    _enrollmentController.text = userData['enrollment'];
    _selectedRole = userData['role'];
    _emailController.text = userData['email'];
    _phoneController.text = userData['phone'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit User"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: _nameController, decoration: InputDecoration(labelText: "Full Name"), validator: (value) => value!.isEmpty ? "Enter Name" : null),
              TextFormField(controller: _branchController, decoration: InputDecoration(labelText: "Branch"), validator: (value) => value!.isEmpty ? "Enter Branch" : null),
              TextFormField(controller: _enrollmentController, decoration: InputDecoration(labelText: "Enrollment No."), validator: (value) => value!.isEmpty ? "Enter Enrollment No." : null),
              DropdownButtonFormField(
                value: _selectedRole,
                items: ["Teacher", "Student"].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                onChanged: (value) => setState(() => _selectedRole = value.toString()),
                decoration: InputDecoration(labelText: "Role"),
              ),
              TextFormField(controller: _emailController, decoration: InputDecoration(labelText: "Email"), validator: (value) => value!.isEmpty ? "Enter Email" : null),
              TextFormField(controller: _phoneController, decoration: InputDecoration(labelText: "Phone"), validator: (value) => value!.isEmpty ? "Enter Phone" : null),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _firestore.collection('users').doc(userId).update({
                  'name': _nameController.text,
                  'branch': _branchController.text,
                  'enrollment': _enrollmentController.text,
                  'role': _selectedRole,
                  'email': _emailController.text,
                  'phone': _phoneController.text,
                });

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Updated"), backgroundColor: Colors.blue));
                Navigator.pop(context);
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Users")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(controller: _nameController, decoration: InputDecoration(labelText: "Full Name"), validator: (value) => value!.isEmpty ? "Enter Name" : null),
                  TextFormField(controller: _branchController, decoration: InputDecoration(labelText: "Branch"), validator: (value) => value!.isEmpty ? "Enter Branch" : null),
                  TextFormField(controller: _enrollmentController, decoration: InputDecoration(labelText: "Enrollment No."), validator: (value) => value!.isEmpty ? "Enter Enrollment No." : null),
                  DropdownButtonFormField(
                    value: _selectedRole,
                    items: ["Teacher", "Student"].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                    onChanged: (value) => setState(() => _selectedRole = value.toString()),
                    decoration: InputDecoration(labelText: "Role"),
                  ),
                  TextFormField(controller: _emailController, decoration: InputDecoration(labelText: "Email"), validator: (value) => value!.isEmpty ? "Enter Email" : null),
                  TextFormField(controller: _phoneController, decoration: InputDecoration(labelText: "Phone"), validator: (value) => value!.isEmpty ? "Enter Phone" : null),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addUser,
                    child: Text("Add User"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: _firestore.collection('users').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                  return ListView(
                    children: snapshot.data!.docs.map((user) {
                      Map<String, dynamic> data = user.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['name']),
                        subtitle: Text("Role: ${data['role']} | Branch: ${data['branch']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: Icon(Icons.edit, color: Colors.green), onPressed: () => _editUser(user.id, data)),
                            IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteUser(user.id)),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
