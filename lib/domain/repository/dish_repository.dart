import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/domain/entities/dish.dart';

abstract class DishRepository {
  Future<List<Dish>> getDishes({int offset = 0, int limit = 100});
  Future<List<Country>> getRemoteCountries();
  Future<List<Dish>> syncDishes();
  Future<List<Dish>> getLocalDishes();
  Future<List<Country>> getLocalCountries();
  Future<int> getLocalDishCount();
  Future<bool> hasLocalData();
}
