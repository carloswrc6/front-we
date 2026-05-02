import 'package:dio/dio.dart';
import 'package:frontwe/config/constants/enviroment.dart';
import 'package:frontwe/domain/datasource/food_datasource.dart';
import 'package:frontwe/domain/entities/food.dart';

class FoodDbDatasource extends FoodDatasource {
  final dio = Dio(BaseOptions(baseUrl: Enviroment.API_URL_BACK));
  @override
  Future<List<Food>> getFoods({int page = 1}) async {
    final response = await dio.get('food/list');
    final List<Food> food = [];
    return food;
  }
}
