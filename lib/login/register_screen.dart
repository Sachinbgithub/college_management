import 'package:flutter/material.dart';
// import '../models/user_type.dart';
import 'auth_service.dart'; // Import UserType

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2({super.key});

  @override
  State<RegisterScreen2> createState() => _RegisterScreen2State();
}

class _RegisterScreen2State extends State<RegisterScreen2> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _enrollmentController = TextEditingController();
  UserType _selectedUserType = UserType.student;
  bool _isLoading = false;
  bool _obscurePassword = true; // For password visibility toggle

  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _enrollmentController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      TextEditingController adminCodeController = TextEditingController();

// Add this to your RegisterScreen when handling admin registration
// This could be in the _handleRegister method before calling registerUser

// Optional: Add admin registration security
      if (_selectedUserType == UserType.admin) {
        // You could require an admin code or limit admin registration
        // For example:
        String adminCode = "431002"; // Set this to something secure

        // Show dialog to enter admin code
        String? enteredCode = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Admin Verification'),
            content: TextField(
              controller: adminCodeController,
              decoration: const InputDecoration(
                labelText: 'Enter Admin Code',
              ),
              obscureText: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  String code = adminCodeController.text;
                  Navigator.pop(context, code);
                },
                child: const Text('Verify'),
              ),
            ],
          ),
        );

        if (enteredCode != adminCode) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid admin code')),
          );
          return; // Stop the registration process
        }

        // Proceed with admin registration
        // Your admin registration logic goes here
      }

      try {
        // Use AuthService for registration instead of direct Firebase call
        String? error = await _authService.registerUser(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          userType: _selectedUserType,
          enrollmentNumber: _selectedUserType == UserType.student ? _enrollmentController.text : null,
        );

        setState(() => _isLoading = false);

        if (error != null) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        } else {
          // Registration successful, redirect based on user type
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful!")),
          );

          if (_selectedUserType == UserType.faculty) {
            // For faculty, show pending approval message and redirect to login
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Your account is pending approval. Please contact administrator.")),
            );
            Navigator.pushReplacementNamed(context, '/login');
          } else {
            // For others, redirect to appropriate dashboard
            String dashboardRoute = _authService.getDashboardRoute();
            Navigator.pushReplacementNamed(context, dashboardRoute);
          }
        }
      } catch (e) {
        // Handle other exceptions
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter email';
                  }
                  // You can add more email validation here if needed
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter password';
                  }
                  if ((value?.length ?? 0) < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<UserType>(
                value: _selectedUserType,
                items: UserType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedUserType = value!);
                },
                decoration: const InputDecoration(
                  labelText: 'User Type',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_selectedUserType == UserType.student) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _enrollmentController,
                  decoration: const InputDecoration(
                    labelText: 'Enrollment Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_selectedUserType == UserType.student &&
                        (value?.isEmpty ?? true)) {
                      return 'Please enter enrollment number';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}