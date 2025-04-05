import 'package:rhino_bond/models/contact_message.dart';
import 'package:rhino_bond/credentials/supabase.credentials.dart';
import 'package:supabase/supabase.dart';

class ContactService {
  static final _client = SupabaseClient(
    SupabaseCredentials.url,
    SupabaseCredentials.anonKey,
  );

  SupabaseClient get supabase => _client;

  Future<void> submitContactMessage({
    required String name,
    required String email,
    required String topic,
    required String message,
    String? userId,
  }) async {
    await supabase.from('contact_messages').insert({
      'name': name,
      'email': email,
      'topic': topic,
      'message': message,
      'user_id': userId,
    });
  }

  Future<List<ContactMessage>> getContactMessages({String? userId}) async {
    final query = userId != null
        ? supabase
            .from('contact_messages')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false)
        : supabase
            .from('contact_messages')
            .select()
            .order('created_at', ascending: false);

    final response = await query;

    return (response as List)
        .map((json) => ContactMessage.fromJson(json))
        .toList();
  }
}
