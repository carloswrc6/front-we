import 'package:dio/dio.dart';
import 'package:frontwe/domain/datasource/dish_datasource.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/infrastructure/mappers/dish_mappers.dart';
import 'package:frontwe/infrastructure/models/dish_model.dart';

class DishDbDatasource extends DishDatasource {
  final Dio dio;

  DishDbDatasource({required this.dio});

  @override
  Future<List<Dish>> getDishes({int offset = 0, int limit = 100}) async {
    final response = await dio.get(
      '/dishes',
      queryParameters: {'offset': offset, 'limit': limit},
    );

    final data = response.data['data'] as List;
    final dishes = data
        .map((json) => DishMapper.modelToEntity(DishModel.fromJson(json)))
        .toList();

    return dishes;
  }
}
