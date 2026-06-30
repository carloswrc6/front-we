import 'package:frontwe/domain/entities/country.dart';

class Dish {
  final String id;
  final String name;
  final String image;
  final List<String> ingredients;
  final String mealType;
  final Country country;
  final bool isUserCreated;

  Dish({
    required this.id,
    required this.name,
    required this.image,
    required this.ingredients,
    required this.mealType,
    required this.country,
    this.isUserCreated = false,
  });
}
