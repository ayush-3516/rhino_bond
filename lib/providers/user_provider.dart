import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserData {
  final String name;
  final String id;
  final String? avatarUrl;
  final int points;
  final bool isKycVerified;
  final String? kycStatus;

  UserData({
    required this.name,
    required this.id,
    this.avatarUrl,
    required this.points,
    this.isKycVerified = false,
    this.kycStatus,
  });

  UserData copyWith({
    String? name,
    String? id,
    String? avatarUrl,
    int? points,
    bool? isKycVerified,
    String? kycStatus,
  }) {
    return UserData(
      name: name ?? this.name,
      id: id ?? this.id,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      points: points ?? this.points,
      isKycVerified: isKycVerified ?? this.isKycVerified,
      kycStatus: kycStatus ?? this.kycStatus,
    );
  }
}

class UserProvider with ChangeNotifier {
  String _token = '';
  UserData? _userData;
  bool _isLoading = false;

  String get token => _token;
  UserData? get userData => _userData;
  int get points => _userData?.points ?? 0;
  bool get isLoading => _isLoading;
  bool get isKycVerified => _userData?.isKycVerified ?? false;
  String? get kycStatus => _userData?.kycStatus;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setUserData(UserData userData) {
    _userData = userData;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      _setLoading(true);
      // TODO: Replace with actual API call
      final profile = await ApiService.getUserProfile(_token);
      
      _userData = UserData(
        name: profile['name'] ?? 'Unknown',
        id: profile['id'] ?? 'Unknown',
        avatarUrl: profile['avatarUrl'],
        points: profile['points'] ?? 0,
        isKycVerified: profile['isKycVerified'] ?? false,
        kycStatus: profile['kycStatus'],
      );
    } catch (e) {
      print('Error fetching user data: $e');
      // Handle error appropriately
    } finally {
      _setLoading(false);
    }
  }

  Future<void> submitKyc(Map<String, dynamic> kycData) async {
    try {
      _setLoading(true);
      await ApiService.submitKyc(_token, kycData);
      
      // Update local user data to reflect pending KYC status
      if (_userData != null) {
        _userData = _userData!.copyWith(
          kycStatus: 'pending',
        );
      }
    } catch (e) {
      print('Error submitting KYC: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
