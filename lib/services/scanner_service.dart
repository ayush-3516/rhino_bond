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

  Future<Map<String, dynamic>> getProductInfo(String code) async {
    try {
      String? qrCodeId;
      bool isManual = false;

      if (code.isEmpty) {
        throw Exception('Empty code');
      }

      // Handle manual codes
      if (RegExp(r'^[a-zA-Z0-9]{6,20}$').hasMatch(code)) {
        qrCodeId = code;
        isManual = true;
      }
      // Handle QR codes
      else {
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
          qrData = {'id': code};
        }

        qrCodeId = qrData['id'] as String;
        if (!RegExp(
                r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
            .hasMatch(qrCodeId)) {
          throw FormatException('Invalid QR code ID format - must be UUID');
        }
      }

      Logger.debug('Fetching product info for code: $qrCodeId');

      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Fetch QR code details with product information
      final qrDetails = await supabase
          .from('qr_codes')
          .select('''
            *,
            products:product_id (name, description, points_value)
          ''')
          .eq(isManual ? 'manual_identifier' : 'id', qrCodeId)
          .single()
          .timeout(const Duration(seconds: 5));

      if (qrDetails == null || qrDetails['points_value'] == null) {
        throw Exception('Invalid QR code - no points value found');
      }

      // Return product information without processing transaction
      return {
        'id': qrCodeId,
        'productName': qrDetails['products']['name'] ?? 'Unknown Product',
        'manualIdentifier': qrDetails['manual_identifier'],
        'points': qrDetails['points_value'],
        'productDescription': qrDetails['products']['description'],
        'productPoints': qrDetails['products']['points_value']
      };
    } on FormatException {
      rethrow;
    } catch (e) {
      Logger.error('Failed to get product info: ${e.toString()}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> processCode(String code,
      {bool isManual = false}) async {
    try {
      if (code.isEmpty) {
        throw Exception('Empty code');
      }

      if (isManual) {
        // Manual codes should be alphanumeric strings
        if (!RegExp(r'^[a-zA-Z0-9]{6,20}$').hasMatch(code)) {
          throw FormatException(
              'Invalid manual identifier - must be 6-20 alphanumeric characters');
        }
        _currentQrCodeId = code;
      } else {
        // Handle scanned QR codes
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
      }

      Logger.debug('Processing QR code: $_currentQrCodeId');

      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Fetch QR code details with product information
      final qrDetails = await supabase
          .from('qr_codes')
          .select('''
            *,
            products:product_id (name, description, points_value)
          ''')
          .eq(isManual ? 'manual_identifier' : 'id', _currentQrCodeId!)
          .single()
          .timeout(const Duration(seconds: 5));

      if (qrDetails == null || qrDetails['points_value'] == null) {
        throw Exception('Invalid QR code - no points value found');
      }

      // Check if already scanned
      if (qrDetails['is_scanned'] == true) {
        final timestamp = qrDetails['scanned_at'] ?? 'previously';
        throw Exception('This QR code was already scanned on $timestamp.');
      }

      // Process the scan transaction
      final result = await supabase.rpc('scan_qr_transaction', params: {
        'qr_code_id': _currentQrCodeId,
        'user_id': user.id,
        'points_value': qrDetails['points_value']
      }).timeout(const Duration(seconds: 5));

      if (result == null) {
        throw Exception('Failed to process QR code - no response from server');
      }

      // Return enriched scan data
      return {
        'id': _currentQrCodeId,
        'productName': qrDetails['products']['name'] ?? 'Unknown Product',
        'manualIdentifier': qrDetails['manual_identifier'],
        'points': qrDetails['points_value'],
        'productDescription': qrDetails['products']['description'],
        'productPoints': qrDetails['products']['points_value']
      };
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
