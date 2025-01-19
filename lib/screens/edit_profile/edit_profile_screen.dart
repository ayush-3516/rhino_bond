import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhino_bond/widgets/providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool isProfileApproved = false;
  bool isKYCCompleted = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;
    _nameController.text =
        userData?['name']?.toString().trim() ?? 'Not provided';
    _emailController.text =
        userData?['email']?.toString().trim() ?? 'Not provided';
    _phoneController.text =
        userData?['phone']?.toString().trim() ?? 'Not available';
    isProfileApproved = userData?['isProfileApproved'] ?? false;
    isKYCCompleted = userData?['isKYCCompleted'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text(
                              isProfileApproved
                                  ? 'Profile Approved'
                                  : 'Profile Not Approved',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor:
                                isProfileApproved ? Colors.green : Colors.red,
                          ),
                          Chip(
                            label: Text(
                              isKYCCompleted
                                  ? 'KYC Completed'
                                  : 'KYC Not Completed',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor:
                                isKYCCompleted ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.person),
                          hintText: _nameController.text.isEmpty
                              ? 'Enter your full name'
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          hintText: _emailController.text.isEmpty
                              ? 'Enter your email'
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: const Icon(Icons.phone),
                          hintText: _phoneController.text.isEmpty
                              ? 'Enter your phone number'
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _updateProfile,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUserData({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'isProfileApproved': isProfileApproved,
          'isKYCCompleted': isKYCCompleted,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Wait for the snackbar to complete before popping
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
