import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerService {
  static final _logger = Logger('QRCodeScanner');
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
          throw FormatException('Invalid QR code format - missing required fields');
        }
      } catch (e) {
        // If JSON parsing fails, try direct UUID format
        if (!RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
            .hasMatch(code)) {
          throw FormatException('Invalid QR code format - must be JSON or UUID');
        }
        // Create a simple map with just the ID if it's a UUID
        qrData = {'id': code};
      }

      _currentQrCodeId = qrData['id'] as String;
      if (!RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
          .hasMatch(_currentQrCodeId!)) {
        throw FormatException('Invalid QR code ID format - must be UUID');
      }

      _logger.info('Processing QR code', {
        'qrCodeId': _currentQrCodeId,
        'timestamp': DateTime.now().toIso8601String()
      });

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

      _logger.info('Initiating QR code scan transaction', {
        'qrCodeId': _currentQrCodeId,
        'userId': user.id,
        'pointsValue': qrDetails['points_value']
      });

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
        _logger.warning('Attempt to reuse QR code', {
          'qrCodeId': _currentQrCodeId,
          'originalScan': timestamp,
          'attemptedBy': user.id
        });
        throw Exception('This QR code was already scanned on $timestamp.');
      }
      
      if (result['is_active'] == false) {
        _logger.warning('Attempt to use deactivated QR code', {
          'qrCodeId': _currentQrCodeId,
          'attemptedBy': user.id
        });
        throw Exception('This QR code has been deactivated.');
      }

      _logger.info('Successfully processed QR code', {
        'qrCodeId': _currentQrCodeId,
        'userId': user.id,
        'pointsAwarded': qrDetails['points_value'],
        'timestamp': DateTime.now().toIso8601String()
      });

      return qrData;
    } on FormatException {
      rethrow;
    } catch (e) {
      _logger.severe('Transaction failed', {
        'qrCodeId': _currentQrCodeId,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String()
      });
      rethrow;
    } finally {
      _currentQrCodeId = null;
    }
  }
}
