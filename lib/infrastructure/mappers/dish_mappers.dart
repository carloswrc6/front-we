import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/infrastructure/models/dish_model.dart';

class DishMapper {
  static Dish modelToEntity(DishModel model) {
    final countryData = model.country;
    return Dish(
      id: model.id,
      name: model.name,
      image: model.image,
      ingredients: model.ingredients,
      mealType: model.mealType,
      country: Country(
        id: countryData?['id'] ?? model.countryId,
        code: countryData?['code'] ?? '',
        name: countryData?['name'] ?? '',
      ),
    );
  }
}
