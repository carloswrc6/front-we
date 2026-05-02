// entities <- datasource <- repository
import 'package:frontwe/domain/entities/plan.dart';

abstract class PlanRepository {
  Future<List<Plan>> getPlans({int page = 1});
}
