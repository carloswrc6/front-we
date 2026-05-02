import 'package:frontwe/domain/entities/food.dart';

abstract class FoodDatasource {
  Future<List<Food>> getFoods({int page = 1});
}
