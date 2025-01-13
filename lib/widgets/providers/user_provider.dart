import 'package:flutter/material.dart';
import 'package:rhino_bond/main.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  Future<void> setUserData(Map<String, dynamic> data) async {
    if (data.isEmpty) {
      print('Warning: Attempting to set empty user data');
      return;
    }

    if (data['name'] == null) {
      print('Error: User data is missing required name field');
      return;
    }

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print('Error: No authenticated user found');
        return;
      }

      // Update user data in Supabase using user ID as the filter
      final updatedData = {
        'name': data['name'],
        'phone': data['phone'],
        if (data['email'] != null) 'email': data['email'],
      };

      final response = await supabase
          .from('users')
          .update(updatedData)
          .eq('id', user.id)
          .select();

      if (response.isNotEmpty) {
        _userData = {..._userData ?? {}, ...response.first};
        notifyListeners();
        print('User data updated successfully');
      } else {
        print('Warning: User data update returned no rows');
      }
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }

  void clearUserData() {
    print('Clearing user data');
    _userData = null;
    notifyListeners();
  }

  Future<void> refreshUserData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print('No authenticated user found');
        return;
      }

      final response = await supabase.from('users').select().eq('id', user.id);

      if (response.isNotEmpty) {
        _userData = response.first;
        notifyListeners();
        print('User data refreshed successfully');
      } else {
        print('No user data found for ID: ${user.id}');
        _userData = null;
        notifyListeners();
      }
    } catch (e) {
      print('Error refreshing user data: $e');
      rethrow;
    }
  }
}
