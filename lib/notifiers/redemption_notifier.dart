import 'package:flutter/material.dart';
import 'package:rhino_bond/services/redemption_service.dart';

class RedemptionNotifier extends ChangeNotifier {
  final RedemptionService _redemptionService = RedemptionService();
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> redeemProduct({
    required String productId,
    required int points,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _redemptionService.redeemProduct(
        productId: productId,
        points: points,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
