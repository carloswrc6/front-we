import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/domain/entities/dish.dart';

abstract class DishDatasource {
  Future<List<Dish>> getDishes({int offset = 0, int limit = 100});
  Future<List<Country>> getCountries();
  Future<Dish> createDish({
    required String name,
    required String image,
    required List<String> ingredients,
    required String mealType,
    required String countryId,
  });
}
