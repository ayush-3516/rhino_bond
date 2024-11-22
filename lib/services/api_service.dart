class ApiService {
  static Future<String> registerUser(String phoneNumber, String otp) async {
    // Simulate API call to register user
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 2));
    return 'dummy_token';
  }

  static Future<String> loginUser(String phoneNumber, String otp) async {
    // Simulate API call to login user
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 2));
    return 'dummy_token';
  }

  static Future<void> changePassword(String token, String newPassword) async {
    // Simulate API call to change password
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 2));
    print('Password changed successfully');
  }

  static Future<int> getPoints(String token) async {
    // Simulate API call to get points
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 2));
    return 100;
  }

  static Future<List<dynamic>> getRewardsCatalog(String token) async {
    // Simulate API call to get rewards catalog
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 2));
    return [
      {
        'id': 1,
        'name': 'Premium Coffee',
        'description': 'Free premium coffee at partner cafes',
        'points': 50,
        'imageUrl': 'assets/images/coffee.png',
      },
      {
        'id': 2,
        'name': 'Movie Tickets',
        'description': '2 movie tickets at partner cinemas',
        'points': 100,
        'imageUrl': 'assets/images/movie.png',
      },
    ];
  }

  static Future<void> submitKyc(String token, Map<String, dynamic> kycData) async {
    // Simulate API call to submit KYC
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 2));
    
    // Validate required fields
    final requiredFields = [
      'fullName',
      'idNumber',
      'dateOfBirth',
      'email',
      'phone',
      'address',
    ];

    for (final field in requiredFields) {
      if (!kycData.containsKey(field) || kycData[field] == null || kycData[field].toString().isEmpty) {
        throw Exception('Missing required field: $field');
      }
    }

    // In a real implementation, you would:
    // 1. Upload any documents
    // 2. Submit KYC data to backend
    // 3. Handle response and update user status
    print('KYC submitted successfully: ${kycData.toString()}');
  }

  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    // Simulate API call to get user profile
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 2));
    return {
      'name': 'John Doe',
      'id': 'RB-001-2024',
      'email': 'john.doe@example.com',
      'phoneNumber': '1234567890',
      'points': 150,
      'isKycVerified': false,
      'kycStatus': null,
      'avatarUrl': null,
    };
  }

  static Future<void> updateUserProfile(
      String token, Map<String, dynamic> profileData) async {
    // Simulate API call to update user profile
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 2));
    print('User profile updated successfully');
  }

  static Future<String> login(String phoneNumber, String otp) async {
    // Simulate API call to login user
    // Replace with actual API call
    await Future.delayed(Duration(seconds: 2));
    return 'dummy_token';
  }
}
