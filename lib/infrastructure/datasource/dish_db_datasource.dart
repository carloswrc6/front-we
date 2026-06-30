import 'package:dio/dio.dart';
import 'package:frontwe/domain/datasource/dish_datasource.dart';
import 'package:frontwe/domain/entities/country.dart';
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

  @override
  Future<Dish> createDish({
    required String name,
    required String image,
    required List<String> ingredients,
    required String mealType,
    required String countryId,
  }) async {
    final response = await dio.post(
      '/dishes',
      data: {
        'name': name,
        if (image.isNotEmpty) 'image': image,
        'ingredients': ingredients,
        'mealType': mealType,
        'countryId': countryId,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return DishMapper.modelToEntity(DishModel.fromJson(data));
  }

  @override
  Future<List<Country>> getCountries() async {
    final response = await dio.get('/countries');
    final data = response.data as List;
    return data
        .map(
          (json) => Country(
            id: json['id'] as String,
            code: json['code'] as String,
            name: json['name'] as String,
          ),
        )
        .toList();
  }
}
