import 'package:flutter/material.dart';
import 'package:rhino_bond/widgets/appbar.dart';
import 'package:rhino_bond/widgets/custom_app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rhino_bond/l10n/localization.dart';

class ContactFAQScreen extends StatefulWidget {
  const ContactFAQScreen({super.key});

  @override
  State<ContactFAQScreen> createState() => _ContactFAQScreenState();
}

class _ContactFAQScreenState extends State<ContactFAQScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  late String _selectedTopic;
  late List<String> _topics;

  @override
  void initState() {
    super.initState();
    _selectedTopic = '';
    _topics = [];
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
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement form submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).messageSent),
          backgroundColor: Colors.green,
        ),
      );
      // Clear form
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
      setState(() {
        _selectedTopic = AppLocalizations.of(context).generalInquiry;
      });
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
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).nameLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).nameValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).emailLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).emailValidation;
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return AppLocalizations.of(context)
                              .emailFormatValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
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
