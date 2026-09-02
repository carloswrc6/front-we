import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/config/constants/enviroment.dart';
import 'package:frontwe/infrastructure/services/purchase_service.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/providers/premium/premium_providers.dart';
import 'package:frontwe/presentation/shared/widgets/CustomToast.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _purchasing = false;
  bool _restoring = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final service = ref.watch(purchaseServiceProvider);

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(t.subsTitleMenu)),
      body: StreamBuilder<bool>(
        initialData: service.isPremium,
        stream: service.premiumStream,
        builder: (context, snapshot) {
          final isPremium = snapshot.data ?? false;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                t.subsTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                t.subsDescription,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              if (isPremium)
                _PremiumHeader(t: t)
              else
                _buildOfferingArea(context, t),
              const SizedBox(height: 16),
              _FreePlanCard(t: t, cs: cs),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _restoring ? null : _restore,
                icon: const Icon(Icons.restore),
                label: Text(t.subsRestore),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOfferingArea(BuildContext context, AppLocalizations t) {
    final offerings = ref.watch(offeringsProvider);
    return offerings.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => _NoProducts(t: t),
      data: (offerings) {
        final packages = offerings?.current?.availablePackages ?? [];
        if (packages.isEmpty) return _NoProducts(t: t);
        return Column(
          children: packages
              .map(
                (p) => _PackageCard(
                  package: p,
                  purchasing: _purchasing,
                  onTap: () => _purchase(p),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Future<void> _purchase(Package package) async {
    final t = AppLocalizations.of(context)!;
    if (_purchasing) return;
    setState(() => _purchasing = true);
    try {
      final info = await PurchaseService.instance.purchase(package);
      if (!mounted) return;
      if (info?.entitlements.active[Environment.REVENUECAT_ENTITLEMENT_ID] !=
          null) {
        CustomToast.show(
          context,
          message: t.subsAlreadyPremium,
          type: ToastType.success,
        );
      }
    } on PlatformException catch (e) {
      if (!mounted) return;
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        CustomToast.show(context, message: t.subsPurchaseCanceled);
      } else {
        CustomToast.show(
          context,
          message: t.subsPurchaseError,
          type: ToastType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _restore() async {
    final t = AppLocalizations.of(context)!;
    if (_restoring) return;
    setState(() => _restoring = true);
    try {
      await PurchaseService.instance.restore();
      if (!mounted) return;
      CustomToast.show(
        context,
        message: t.subsRestored,
        type: ToastType.success,
      );
    } catch (_) {
      if (!mounted) return;
      CustomToast.show(
        context,
        message: t.subsPurchaseError,
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }
}

class _NoProducts extends StatelessWidget {
  final AppLocalizations t;
  const _NoProducts({required this.t});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.storefront_outlined, size: 40, color: cs.primary),
            const SizedBox(height: 12),
            Text(
              t.subsNoProducts,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              t.subsNoProductsHint,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final Package package;
  final bool purchasing;
  final VoidCallback onTap;

  const _PackageCard({
    required this.package,
    required this.purchasing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final sp = package.storeProduct;
    final isAnnual = package.packageType == PackageType.annual;
    final isLifetime = package.packageType == PackageType.lifetime;

    final String periodLabel;
    if (isLifetime) {
      periodLabel = t.subsUpgrade;
    } else if (isAnnual) {
      periodLabel = '${sp.pricePerMonthString ?? sp.priceString}/mes*';
    } else {
      periodLabel = sp.subscriptionPeriod != null && sp.pricePerMonth != null
          ? '${sp.pricePerMonthString}/mes'
          : sp.priceString;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isAnnual || isLifetime ? cs.primary : cs.outlineVariant,
          width: isAnnual || isLifetime ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isAnnual || isLifetime)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        t.subsRecommended,
                        style: TextStyle(
                          color: cs.onPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    sp.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sp.priceString,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (periodLabel.isNotEmpty)
                    Text(
                      periodLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  if (sp.introductoryPrice != null)
                    Text(
                      t.subsFreeTrial,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: cs.tertiary),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: purchasing ? null : onTap,
              child: purchasing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(t.subsSubscribe),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumHeader extends StatelessWidget {
  final AppLocalizations t;
  const _PremiumHeader({required this.t});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium, color: cs.onPrimaryContainer, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              t.subsAlreadyPremium,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: cs.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FreePlanCard extends StatelessWidget {
  final AppLocalizations t;
  final ColorScheme cs;
  const _FreePlanCard({required this.t, required this.cs});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    t.subsFreeBadge,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  t.subsFreePlanTitle,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(t.subsFreePlanDesc, style: textTheme.bodySmall),
            const SizedBox(height: 12),
            _FreeFeature(icon: Icons.public, label: t.subsFreeBasicFilters),
            _FreeFeature(icon: Icons.restaurant, label: t.subsFreeQuotaDishes),
            _FreeFeature(
              icon: Icons.favorite_border,
              label: t.subsFreeQuotaFavorites,
            ),
            _FreeFeature(
              icon: Icons.thumb_down_off_alt,
              label: t.subsFreeQuotaAvoid,
            ),
            _FreeFeature(icon: Icons.history, label: t.subsFreeHistory),
          ],
        ),
      ),
    );
  }
}

class _FreeFeature extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FreeFeature({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
