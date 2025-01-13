import 'package:supabase/supabase.dart';
import 'package:rhino_bond/credentials/supabase.credentials.dart';

class ApiService {
  final SupabaseClient supabase = SupabaseClient(
    SupabaseCredentials.url,
    SupabaseCredentials.anonKey,
  );

  // Track last validation time for rate limiting
  DateTime? _lastValidationTime;

  Future<Map<String, dynamic>> validateQRCode(String qrCodeId) async {
    try {
      // Validate input
      if (qrCodeId.isEmpty || !_isValidUUID(qrCodeId)) {
        throw Exception('Invalid QR code format');
      }

      // Rate limiting - max 1 request per second
      if (_lastValidationTime != null &&
          DateTime.now().difference(_lastValidationTime!) <
              Duration(seconds: 1)) {
        throw Exception('Too many requests. Please wait and try again.');
      }
      _lastValidationTime = DateTime.now();

      // Check if QR code exists and is valid
      final qrCode = await supabase
          .from('qr_codes')
          .select()
          .eq('id', qrCodeId.toString())
          .single();

      if (qrCode['is_scanned'] == true) {
        throw Exception('QR code already scanned');
      }

      if (qrCode['is_active'] == false) {
        throw Exception('QR code is inactive');
      }

      // Get current user
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Call the scan_qr_code function
      final result =
          await supabase.rpc('scan_qr_code', params: {'qr_id': qrCodeId});

      if (result['success'] == false) {
        throw Exception(result['message']);
      }

      return {
        'success': true,
        'points': qrCode['points_value'],
        'product_id': qrCode['product_id'],
      };
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
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
