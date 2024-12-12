class CustomNoInternetException implements Exception {
  final String message;
  CustomNoInternetException({required this.message});
}

class AuthApiException implements Exception {
  final String message;
  final int statusCode; // Added statusCode property
  AuthApiException({required this.message, required this.statusCode});
}
