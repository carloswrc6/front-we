import 'package:dio/dio.dart';
import 'package:frontwe/domain/datasource/plan_datasource.dart';
import 'package:frontwe/domain/entities/plan.dart';
import 'package:frontwe/infrastructure/datasource/api_client.dart';
import 'package:frontwe/infrastructure/mappers/plan_mappers.dart';
import 'package:frontwe/infrastructure/models/food_bd/planbd_response.dart';

class PlanDbDatasource extends PlanDatasource {
  final dio = ApiClient.dio;

  @override
  Future<List<Plan>> getPlans({int page = 1}) async {
    try {
      final response = await dio.get('/subscription/plans');
      final planDBResponse = PlanDbResponse.fromJson(response.data);
      final List<Plan> plans = planDBResponse.data
          .map((plandb) => PlanMapper.planDBToEntity(plandb))
          .toList();
      return plans;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
