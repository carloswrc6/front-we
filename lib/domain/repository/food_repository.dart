// entities <- datasource <- repository
import 'package:frontwe/domain/entities/food.dart';

abstract class FoodRepository {
  Future<List<Food>> getFoods({int page = 1});
}
