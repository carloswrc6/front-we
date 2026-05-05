import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/providers/plan/plans_providers.dart';
import 'package:frontwe/presentation/subscription/widgets/SubscriptionCard.dart';
import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SubscriptionView();
  }
}

class _SubscriptionView extends ConsumerStatefulWidget {
  const _SubscriptionView();

  @override
  ConsumerState<_SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends ConsumerState<_SubscriptionView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingPlansProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(nowPlayingPlansProvider);
    final t = AppLocalizations.of(
      context,
    ); // no tiene el lang correcto del login register..se pierde
    // y esta q se duplica los planes .. en el register

    return Scaffold(
      appBar: AppBar(title: const Text('Planes de suscripción')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: plans.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t!.subsTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(t.subsDescription),
                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: plans.length,
                      itemBuilder: (context, index) {
                        final plan = plans[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SubscriptionCard(
                            txtRecommented: t!.subsRecommended,
                            title: plan.title,
                            price: plan.priceFormatted,
                            description: plan.description,
                            isRecommended: plan.isRecommended,
                            badge: plan.badge,
                            features: plan.features,
                            ctaText: plan.ctaText,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
