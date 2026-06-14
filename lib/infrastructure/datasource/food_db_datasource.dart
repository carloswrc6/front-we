import 'package:dio/dio.dart';
import 'package:frontwe/domain/datasource/food_datasource.dart';
import 'package:frontwe/domain/entities/food.dart';

class FoodDbDatasource extends FoodDatasource {
  final Dio dio;

  FoodDbDatasource({required this.dio});

  @override
  Future<List<Food>> getFoods({int page = 1}) async {
    try {
      final response = await dio.get('/food/list', queryParameters: {'page': page});
      // TODO: Parse response and map to Food entities
      // For now returning empty list - awaiting Food model definition
      final List<Food> foods = [];
      return foods;
    } catch (e) {
      rethrow;
    }
  }
}
