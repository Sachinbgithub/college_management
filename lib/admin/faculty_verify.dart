import 'package:flutter/cupertino.dart';

import 'package:college_management/utility/temp.dart';
import 'package:flutter/material.dart';

import '../login/auth_service.dart';

class FacultyApprovalScreen extends StatefulWidget {
  const FacultyApprovalScreen({Key? key}) : super(key: key);

  @override
  State<FacultyApprovalScreen> createState() => _FacultyApprovalScreenState();
}

class _FacultyApprovalScreenState extends State<FacultyApprovalScreen> {
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _pendingFaculty = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingFaculty();
  }

  Future<void> _loadPendingFaculty() async {
    setState(() => _isLoading = true);
    List<Map<String, dynamic>> facultyList = await _authService.getPendingFacultyAccounts();
    setState(() {
      _pendingFaculty = facultyList;
      _isLoading = false;
    });
  }

  Future<void> _approveAccount(String userId) async {
    bool success = await _authService.approveFacultyAccount(userId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faculty account approved successfully')),
      );
      _loadPendingFaculty(); // Refresh the list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to approve faculty account')),
      );
    }
  }

  Future<void> _rejectAccount(String userId) async {
    bool success = await _authService.rejectFacultyAccount(userId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faculty account rejected')),
      );
      _loadPendingFaculty(); // Refresh the list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to reject faculty account')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Approval'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingFaculty.isEmpty
          ? const Center(child: Text('No pending faculty accounts'))
          : ListView.builder(
        itemCount: _pendingFaculty.length,
        itemBuilder: (context, index) {
          final faculty = _pendingFaculty[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(faculty['name']),
              subtitle: Text(faculty['email']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _approveAccount(faculty['id']),
                    tooltip: 'Approve',
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _rejectAccount(faculty['id']),
                    tooltip: 'Reject',
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadPendingFaculty,
        child: const Icon(Icons.refresh),
        tooltip: 'Refresh',
      ),
    );
  }
}