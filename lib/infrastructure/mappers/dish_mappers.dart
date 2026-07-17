import 'package:flutter/foundation.dart';
import 'package:frontwe/config/constants/enviroment.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/infrastructure/models/dish_model.dart';

class DishMapper {
  static Dish modelToEntity(DishModel model) {
    final countryData = model.country;
    final image = Environment.resolveImageUrl(model.image);
    debugPrint('[DishMapper] original: ${model.image} → resolved: $image');
    return Dish(
      id: model.id,
      name: model.name,
      image: image,
      ingredients: model.ingredients,
      mealType: model.mealType,
      difficulty: model.difficulty,
      country: Country(
        id: countryData?['id'] ?? model.countryId,
        code: countryData?['code'] ?? '',
        name: countryData?['name'] ?? '',
      ),
      isHealthy: model.isHealthy,
    );
  }
}
