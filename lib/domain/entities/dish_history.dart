import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/domain/entities/dish.dart';

class DishHistory {
  final int id;
  final String dishId;
  final String dishName;
  final String dishImage;
  final String mealType;
  final String countryId;
  final String countryCode;
  final String countryName;
  final List<String> ingredients;
  final bool fromSpin;
  final DateTime selectedAt;

  DishHistory({
    required this.id,
    required this.dishId,
    required this.dishName,
    required this.dishImage,
    required this.mealType,
    required this.countryId,
    required this.countryCode,
    required this.countryName,
    required this.ingredients,
    required this.fromSpin,
    required this.selectedAt,
  });

  Dish get dish => Dish(
    id: dishId,
    name: dishName,
    image: dishImage,
    mealType: mealType,
    country: Country(id: countryId, code: countryCode, name: countryName),
    ingredients: ingredients,
  );

  factory DishHistory.fromMap(Map<String, dynamic> map) {
    return DishHistory(
      id: map['id'] as int,
      dishId: map['dish_id'] as String,
      dishName: map['dish_name'] as String,
      dishImage: map['dish_image'] as String,
      mealType: map['meal_type'] as String,
      countryId: map['country_id'] as String,
      countryCode: map['country_code'] as String,
      countryName: map['country_name'] as String,
      ingredients: (map['ingredients'] as String).split('||'),
      fromSpin: (map['from_spin'] as int) == 1,
      selectedAt: DateTime.parse(map['selected_at'] as String),
    );
  }
}
