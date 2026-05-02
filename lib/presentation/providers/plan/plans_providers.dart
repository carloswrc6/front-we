// C:\calochop-py\front_we\lib\presentation\providers\plan\plans_providers.dart
import 'package:frontwe/domain/entities/plan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/presentation/providers/plan/plan_repository_provider.dart';

final nowPlayingPlansProvider =
    StateNotifierProvider<PlansNotifier, List<Plan>>((ref) {
      final fetchMorePlans = ref.watch(planRepositoryProvider).getPlans;
      return PlansNotifier(fetchMorePlans: fetchMorePlans);
    });

typedef PlansCallBack = Future<List<Plan>> Function({int page});

class PlansNotifier extends StateNotifier<List<Plan>> {
  int currentPage = 1;
  PlansCallBack fetchMorePlans;

  PlansNotifier({required this.fetchMorePlans}) : super([]);

  Future<void> loadNextPage() async {
    currentPage++;
    final List<Plan> plans = await fetchMorePlans(page: currentPage);
    state = [...state, ...plans];
  }
}
