import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Effective Date: [Date]',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Information We Collect',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We collect information that you provide directly to us, including:',
            ),
            const SizedBox(height: 8),
            const Text(
              '- Personal identification information (Name, email address, phone number, etc.)',
            ),
            const Text(
              '- Device information',
            ),
            const Text(
              '- Usage data',
            ),
            const SizedBox(height: 16),
            const Text(
              '2. How We Use Your Information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We use the information we collect to:',
            ),
            const SizedBox(height: 8),
            const Text(
              '- Provide, maintain, and improve our services',
            ),
            const Text(
              '- Personalize your experience',
            ),
            const Text(
              '- Communicate with you',
            ),
            const SizedBox(height: 16),
            const Text(
              '3. Data Security',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We implement appropriate security measures to protect your information.',
            ),
            const SizedBox(height: 16),
            const Text(
              '4. Your Rights',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You have the right to:',
            ),
            const SizedBox(height: 8),
            const Text(
              '- Access your personal data',
            ),
            const Text(
              '- Request correction or deletion',
            ),
            const Text(
              '- Object to processing',
            ),
            const SizedBox(height: 16),
            const Text(
              '5. Changes to This Policy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We may update this policy from time to time. We will notify you of any changes.',
            ),
            const SizedBox(height: 16),
            const Text(
              '6. Contact Us',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you have any questions about this policy, please contact us at:',
            ),
            const SizedBox(height: 8),
            const Text(
              'support@example.com',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
