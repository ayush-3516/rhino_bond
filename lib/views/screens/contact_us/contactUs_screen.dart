import 'package:flutter/material.dart';
import 'package:rhino_bond/views/widgets/appbar.dart';
import 'package:rhino_bond/views/widgets/app_drawer.dart';
import 'package:rhino_bond/views/screens/contact_us/contactUs_controller.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Contact Us',
      ),
      drawer: const AppDrawer(),
      body: const ContactUsController(),
    );
  }
}
