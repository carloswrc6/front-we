import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Planes de suscripción')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return SubscriptionCard(
                    title: plan.title,
                    price: plan.price.toString(),
                    description: plan.description,
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
