import 'package:frontwe/domain/entities/plan.dart';

abstract class PlanDatasource {
  Future<List<Plan>> getPlans({int page = 1});
}
