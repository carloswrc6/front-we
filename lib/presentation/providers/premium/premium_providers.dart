import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/infrastructure/services/purchase_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return PurchaseService.instance;
});

final isPremiumProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(purchaseServiceProvider);
  return service.premiumStream;
});

final offeringsProvider = FutureProvider<Offerings?>((ref) {
  final service = ref.watch(purchaseServiceProvider);
  return service.getOfferings();
});
