import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../base/utils/auth_constants.dart';
import '../../../base/utils/auth_validators.dart';
import '../../../shared/custom_phone_number_field.dart';
import '../../../shared/main_button.dart';
import '../../../shared/spacing.dart';
import '../../../shared/loading_indicator.dart';
import 'login_view_model.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, LoginViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomPhoneNumberField(
              controller: viewModel.phoneController,
              validator: AuthValidators.validatePhoneNumber,
              onChanged: (value) => viewModel.onPhoneNumberChanged(value),
            ),
            verticalSpacing(16),
            if (viewModel.isBusy)
              const LoadingIndicator()
            else
              MainButton(
                buttonText: 'Continue',
                onPressed: viewModel.isPhoneNumberValid
                    ? () => viewModel.signInWithPhone()
                    : null,
              ),
            verticalSpacing(16),
            TextButton(
              onPressed: viewModel.navigateToRegister,
              child: const Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
