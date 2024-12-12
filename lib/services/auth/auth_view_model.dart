import 'package:stacked/stacked.dart';
import '../../models/app_user.dart';
import 'auth_service.dart';

class AuthViewModel extends BaseViewModel {
  final _authService = AuthService();
  bool get isAuthenticated => _authService.isAuthenticated;

  Future<void> signInWithPhone(String phoneNumber) async {
    setBusy(true);
    try {
      await _authService.signInWithPhone(phoneNumber);
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  Future<void> verifyOTP(String phoneNumber, String otp) async {
    setBusy(true);
    try {
      await _authService.verifyOTP(phoneNumber, otp);
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  Future<void> signUpWithPhone(String phoneNumber, String name) async {
    setBusy(true);
    try {
      await _authService.signUpWithPhone(phoneNumber, name);
      
      if (_authService.currentUser != null) {
        final appUser = AppUser(
          id: _authService.currentUser!.id,
          name: name,
          phone: phoneNumber,
          createdAt: DateTime.now(),
        );
        await _authService.createUserProfile(appUser);
      }
      
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  Future<void> signOut() async {
    setBusy(true);
    try {
      await _authService.signOut();
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }
}
