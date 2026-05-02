import 'package:dio/dio.dart';
import 'package:frontwe/config/constants/enviroment.dart';
import 'package:frontwe/domain/datasource/plan_datasource.dart';
import 'package:frontwe/domain/entities/plan.dart';
import 'package:frontwe/infrastructure/mappers/plan_mappers.dart';
import 'package:frontwe/infrastructure/models/food_bd/planbd_response.dart';

class PlanDbDatasource extends PlanDatasource {
  final dio = Dio(BaseOptions(baseUrl: Enviroment.API_URL_BACK));

  @override
  Future<List<Plan>> getPlans({int page = 1}) async {
    try {
      print('➡️ Calling API...');
      print('Base URL: ${dio.options.baseUrl}');
      print('Endpoint: /subscription/plans');

      final response = await dio.get('/subscription/plans');

      print('✅ Status code: ${response.statusCode}');
      print('📦 Response data: ${response.data}');

      final planDBResponse = PlanDbResponse.fromJson(response.data);

      final List<Plan> plans = planDBResponse.data
          .map((plandb) => PlanMapper.planDBToEntity(plandb))
          .toList();

      print('🎯 Plans parsed: ${plans.length}');

      return plans;
    } on DioException catch (e) {
      print('❌ Dio error: ${e.message}');
      print('❌ Status code: ${e.response?.statusCode}');
      print('❌ Data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('❌ Unknown error: $e');
      rethrow;
    }
  }
}
