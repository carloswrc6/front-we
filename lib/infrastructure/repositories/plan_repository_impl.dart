import 'package:frontwe/domain/datasource/plan_datasource.dart';
import 'package:frontwe/domain/entities/plan.dart';
import 'package:frontwe/domain/repository/plan_repository.dart';

class PlanRepositoryImpl extends PlanRepository {
  final PlanDatasource datasource;
  PlanRepositoryImpl(this.datasource);

  @override
  Future<List<Plan>> getPlans({int page = 1}) {
    return datasource.getPlans(page: page);
  }
}
