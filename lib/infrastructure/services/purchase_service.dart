import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:frontwe/config/constants/enviroment.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseService {
  PurchaseService._();
  static final PurchaseService instance = PurchaseService._();

  final StreamController<bool> _premiumController = StreamController<bool>.broadcast();
  Stream<bool> get premiumStream => _premiumController.stream;

  bool _configured = false;
  bool _isPremium = false;

  bool get isPremium => _isPremium;
  bool get isConfigured => _configured;

  Future<void> init({String? appUserId}) async {
    if (!kIsWeb && Environment.REVENUECAT_API_KEY.isEmpty) {
      debugPrint('[PurchaseService] REVENUECAT_API_KEY vacia, premium desactivado');
      return;
    }

    await Purchases.setLogLevel(LogLevel.debug);
    await Purchases.configure(PurchasesConfiguration(Environment.REVENUECAT_API_KEY));

    Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);

    if (appUserId != null && appUserId.isNotEmpty) {
      await Purchases.logIn(appUserId);
    }

    _configured = true;
    await refresh();
  }

  Future<void> identify(String appUserId) async {
    if (!_configured || appUserId.isEmpty) return;
    await Purchases.logIn(appUserId);
    await refresh();
  }

  Future<void> reset() async {
    if (!_configured) return;
    await Purchases.logOut();
    _isPremium = false;
    _premiumController.add(false);
  }

  Future<void> refresh() async {
    if (!_configured) return;
    try {
      final info = await Purchases.getCustomerInfo();
      _updatePremium(info);
    } catch (e) {
      debugPrint('[PurchaseService] refresh error: $e');
    }
  }

  void _onCustomerInfoUpdated(CustomerInfo info) {
    _updatePremium(info);
  }

  void _updatePremium(CustomerInfo info) {
    final active = info.entitlements.active[Environment.REVENUECAT_ENTITLEMENT_ID];
    final newValue = active?.isActive ?? false;
    if (newValue != _isPremium) {
      _isPremium = newValue;
      _premiumController.add(newValue);
      debugPrint('[PurchaseService] premium = $_isPremium');
    }
  }

  Future<Offerings?> getOfferings() async {
    if (!_configured) return null;
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('[PurchaseService] getOfferings error: $e');
      return null;
    }
  }

  Future<CustomerInfo?> purchase(Package package) async {
    if (!_configured) return null;
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      _updatePremium(result.customerInfo);
      return result.customerInfo;
    } on PlatformException catch (e) {
      debugPrint('[PurchaseService] purchase error: ${PurchasesErrorHelper.getErrorCode(e)}: ${e.message}');
      rethrow;
    }
  }

  Future<CustomerInfo?> restore() async {
    if (!_configured) return null;
    try {
      final info = await Purchases.restorePurchases();
      _updatePremium(info);
      return info;
    } catch (e) {
      debugPrint('[PurchaseService] restore error: $e');
      rethrow;
    }
  }

  void dispose() {
    _premiumController.close();
  }
}
