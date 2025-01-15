import 'package:supabase/supabase.dart';
import 'package:rhino_bond/credentials/supabase.credentials.dart';
import 'package:rhino_bond/utils/logger.dart';

class ApiService {
  final SupabaseClient supabase = SupabaseClient(
    SupabaseCredentials.url,
    SupabaseCredentials.anonKey,
  );

  // Track last validation time for rate limiting
  DateTime? _lastValidationTime;

  Future<Map<String, dynamic>> validateQRCode(String qrCodeId) async {
    Logger.debug('Validating QR code: $qrCodeId');
    try {
      // Validate input
      if (qrCodeId.isEmpty || !_isValidUUID(qrCodeId)) {
        Logger.error('Invalid QR code format: $qrCodeId');
        throw Exception('Invalid QR code format');
      }

      // Rate limiting - max 1 request per second
      if (_lastValidationTime != null &&
          DateTime.now().difference(_lastValidationTime!) <
              Duration(seconds: 1)) {
        Logger.warning('Rate limit exceeded for QR code validation');
        throw Exception('Too many requests. Please wait and try again.');
      }
      _lastValidationTime = DateTime.now();
      Logger.debug('Rate limit check passed');

      // Check if QR code exists and is valid
      Logger.debug('Querying database for QR code: $qrCodeId');
      final qrCode = await supabase
          .from('qr_codes')
          .select()
          .eq('id', qrCodeId.toString())
          .single();
      Logger.debug('QR code found: ${qrCode['id']}');

      if (qrCode['is_scanned'] == true) {
        Logger.error('QR code already scanned: ${qrCode['id']}');
        throw Exception('QR code already scanned');
      }

      if (qrCode['is_active'] == false) {
        Logger.error('QR code is inactive: ${qrCode['id']}');
        throw Exception('QR code is inactive');
      }

      // Get current user
      final user = supabase.auth.currentUser;
      if (user == null) {
        Logger.error('User not authenticated for QR code validation');
        throw Exception('User not authenticated');
      }
      Logger.debug('Authenticated user: ${user.id}');

      // Call the scan_qr_code function
      Logger.debug('Calling scan_qr_code function for QR code: $qrCodeId');
      final result =
          await supabase.rpc('scan_qr_code', params: {'qr_id': qrCodeId});

      if (result['success'] == false) {
        Logger.error('QR code scan failed: ${result['message']}');
        throw Exception(result['message']);
      }

      Logger.success('QR code validated successfully: $qrCodeId');
      return {
        'success': true,
        'points': qrCode['points_value'],
        'product_id': qrCode['product_id'],
      };
    } on PostgrestException catch (e) {
      Logger.error('Database error validating QR code: ${e.message}');
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      Logger.error('Failed to validate QR code: ${e.toString()}');
      throw Exception('Failed to validate QR code: ${e.toString()}');
    }
  }

  bool _isValidUUID(String uuid) {
    final regex = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        caseSensitive: false);
    return regex.hasMatch(uuid);
  }
}
