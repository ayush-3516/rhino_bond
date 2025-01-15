import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rhino_bond/utils/logger.dart';

class ScannerService {
  final supabase = Supabase.instance.client;
  String? _currentQrCodeId;

  Future<void> checkCameraPermissions() async {
    try {
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          throw Exception('Camera permission denied');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> processCode(String code) async {
    try {
      if (code.isEmpty) {
        throw Exception('Empty QR code');
      }

      // Try parsing as JSON first
      Map<String, dynamic> qrData;
      try {
        qrData = jsonDecode(code);
        if (qrData is! Map<String, dynamic> || !qrData.containsKey('id')) {
          throw FormatException(
              'Invalid QR code format - missing required fields');
        }
      } catch (e) {
        // If JSON parsing fails, try direct UUID format
        if (!RegExp(
                r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
            .hasMatch(code)) {
          throw FormatException(
              'Invalid QR code format - must be JSON or UUID');
        }
        // Create a simple map with just the ID if it's a UUID
        qrData = {'id': code};
      }

      _currentQrCodeId = qrData['id'] as String;
      if (!RegExp(
              r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
          .hasMatch(_currentQrCodeId!)) {
        throw FormatException('Invalid QR code ID format - must be UUID');
      }

      Logger.debug('Processing QR code: $_currentQrCodeId');

      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Fetch QR code details from database
      if (_currentQrCodeId == null) {
        throw Exception('QR code ID is null');
      }

      final qrDetails = await supabase
          .from('qr_codes')
          .select('points_value')
          .eq('id', _currentQrCodeId!)
          .single()
          .timeout(const Duration(seconds: 5));

      if (qrDetails == null || qrDetails['points_value'] == null) {
        throw Exception('Invalid QR code - no points value found');
      }

      Logger.debug('Initiating QR code scan transaction for user: ${user.id}');

      final result = await supabase.rpc('scan_qr_transaction', params: {
        'qr_code_id': _currentQrCodeId,
        'user_id': user.id,
        'points_value': qrDetails['points_value']
      }).timeout(const Duration(seconds: 5));

      if (result == null) {
        throw Exception('Failed to process QR code - no response from server');
      }

      if (result['is_scanned'] == true) {
        final timestamp = result['scanned_at'] ?? 'previously';
        Logger.warning(
            'Attempt to reuse QR code: $_currentQrCodeId (originally scanned $timestamp)');
        throw Exception('This QR code was already scanned on $timestamp.');
      }

      if (!result.containsKey('user')) {
        throw Exception('Failed to process QR code - invalid response format');
      }

      final userData = result['user'];
      if (userData['id'] != user.id) {
        throw Exception('Failed to process QR code - user mismatch');
      }

      Logger.success(
          'QR code $_currentQrCodeId processed successfully. Points awarded: ${qrDetails['points_value']}');

      return qrData;
    } on FormatException {
      rethrow;
    } catch (e) {
      Logger.error(
          'Transaction failed for QR code: $_currentQrCodeId. Error: ${e.toString()}');
      rethrow;
    } finally {
      _currentQrCodeId = null;
    }
  }
}
