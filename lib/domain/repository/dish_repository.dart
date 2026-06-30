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
  Future<Dish> createDish({
    required String name,
    required String image,
    required List<String> ingredients,
    required String mealType,
    required String countryId,
  });
  Future<void> toggleFavorite(String dishId);
  Future<void> toggleAvoided(String dishId);
  Future<void> setAvoidReason(String dishId, String? reason);
}
