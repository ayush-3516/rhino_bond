import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rhino_bond/widgets/appbar.dart';
import 'package:rhino_bond/widgets/custom_app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rhino_bond/l10n/localization.dart';
import 'package:rhino_bond/services/contact_service.dart';
import 'package:rhino_bond/services/session_manager.dart';
import 'package:rhino_bond/services/authentication.services.dart';

class ContactFAQScreen extends StatefulWidget {
  const ContactFAQScreen({super.key});

  @override
  State<ContactFAQScreen> createState() => _ContactFAQScreenState();
}

class _ContactFAQScreenState extends State<ContactFAQScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String? _userName;
  String? _userEmail;
  late String _selectedTopic;
  late List<String> _topics;

  @override
  void initState() {
    super.initState();
    _selectedTopic = '';
    _topics = [];
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // First try getting session from secure storage
      var sessionToken = await SessionManager.getSession();

      // If no session in storage, check current auth state
      if (sessionToken == null) {
        try {
          // Try to get current session directly from Supabase
          final session =
              AuthenticationService.supabaseClient.auth.currentSession;
          if (session != null) {
            sessionToken = session.accessToken;
            await SessionManager.saveSession(sessionToken);
          }
        } catch (e) {
          print('Error checking current session: $e');
        }
      }

      if (sessionToken == null) {
        print('No active session found');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please sign in to autofill your details')),
        );
        return;
      }

      final userId = _extractUserIdFromToken(sessionToken);
      if (userId == null) {
        print('Could not extract user ID from token');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid session - please sign in again')),
        );
        await SessionManager.clearSession();
        return;
      }

      final authService = AuthenticationService();
      final profile = await authService.getUserProfile(userId);

      if (profile == null) {
        print('No profile found for user $userId');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Profile not found - please complete your profile')),
        );
        return;
      }

      if (profile['name'] == null || profile['email'] == null) {
        print('Profile missing name or email: $profile');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please complete your profile details')),
        );
        return;
      }

      setState(() {
        _userName = profile['name'].toString().trim();
        _userEmail = profile['email'].toString().trim();
        print('Loaded user: $_userName <$_userEmail>');
      });
    } catch (e) {
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading user profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedTopic = AppLocalizations.of(context).generalInquiry;
    _topics = [
      AppLocalizations.of(context).generalInquiry,
      AppLocalizations.of(context).technicalSupport,
      AppLocalizations.of(context).accountIssues,
      AppLocalizations.of(context).rewardsProgram,
      AppLocalizations.of(context).otherTopic
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final sessionToken = await SessionManager.getSession();
        final userId =
            sessionToken != null ? _extractUserIdFromToken(sessionToken) : null;
        final contactService = ContactService();

        // Map localized topic to database value
        final topicMap = {
          AppLocalizations.of(context).generalInquiry: 'General Inquiry',
          AppLocalizations.of(context).technicalSupport: 'Technical Support',
          AppLocalizations.of(context).accountIssues: 'Account Issues',
          AppLocalizations.of(context).rewardsProgram: 'Rewards Program',
          AppLocalizations.of(context).otherTopic: 'Other Topic',
        };

        if (_userName == null ||
            _userName!.isEmpty ||
            _userEmail == null ||
            _userEmail!.isEmpty) {
          throw Exception('Name and email are required');
        }

        print('Submitting contact message:');
        print('Name: $_userName');
        print('Email: $_userEmail');
        print('Topic: ${topicMap[_selectedTopic]}');
        print('Message: ${_messageController.text}');
        print('User ID: $userId');

        await contactService.submitContactMessage(
          name: _userName!,
          email: _userEmail!,
          topic: topicMap[_selectedTopic]!,
          message: _messageController.text,
          userId: userId,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message sent successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Show confirmation dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Thank You!'),
            content: Text(
                'We have received your message and will get back to you soon.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );

        // Clear form
        _messageController.clear();
        setState(() {
          _selectedTopic = 'General Inquiry';
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).contactFAQTitle,
        scaffoldKey: _scaffoldKey,
      ),
      drawer: CustomAppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Information Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).getInTouch,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildContactItem(
                      Icons.email,
                      AppLocalizations.of(context).emailLabel,
                      'jangidenterprises007@gmail.com',
                      () => _launchURL('mailto:jangidenterprises007@gmail.com'),
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      Icons.phone,
                      AppLocalizations.of(context).phoneLabel,
                      '+91 91062 34402',
                      () => _launchURL('tel:+919106234402'),
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      Icons.location_on,
                      AppLocalizations.of(context).addressLabel,
                      'Shop No. 8, Plot No. 1/34, Ward 10/A, Gandhidham(Kutch) 370201',
                      () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Contact Form Section
              Text(
                AppLocalizations.of(context).sendMessageTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_userName != null && _userEmail != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: $_userName',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Email: $_userEmail',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    DropdownButtonFormField<String>(
                      value: _selectedTopic,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).topicLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: _topics.map((String topic) {
                        return DropdownMenuItem(
                          value: topic,
                          child: Text(topic),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedTopic = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).messageLabel,
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).messageValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        AppLocalizations.of(context).sendButton,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64.normalize(payload);
      final decoded = utf8.decode(base64.decode(normalized));
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;

      return payloadMap['sub'] as String?;
    } catch (e) {
      return null;
    }
  }

  Widget _buildContactItem(
      IconData icon, String title, String content, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
