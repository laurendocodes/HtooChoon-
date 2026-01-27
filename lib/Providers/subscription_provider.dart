import 'package:flutter/material.dart';

class SubscriptionProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Placeholder for subscription logic
  
  Future<void> fetchPlans() async {
    // TODO: Fetch from RevenueCat or Firestore
  }

  Future<void> purchaseUserPlan(String planId) async {
    // TODO: Implement purchase logic
  }
}
