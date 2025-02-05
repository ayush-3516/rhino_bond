import 'package:flutter/material.dart';
import 'package:rhino_bond/widgets/appbar.dart';
import 'package:rhino_bond/l10n/localization.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).termsOfService,
        showBackButton: true,
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).termsOfServiceContent,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
