import 'package:frontwe/domain/entities/country.dart';

class Dish {
  final String id;
  final String name;
  final String image;
  final List<String> ingredients;
  final String mealType;
  final Country country;
  final bool isUserCreated;
  final bool isFavorite;

  Dish({
    required this.id,
    required this.name,
    required this.image,
    required this.ingredients,
    required this.mealType,
    required this.country,
    this.isUserCreated = false,
    this.isFavorite = false,
  });

  Dish copyWith({bool? isFavorite}) {
    return Dish(
      id: id,
      name: name,
      image: image,
      ingredients: ingredients,
      mealType: mealType,
      country: country,
      isUserCreated: isUserCreated,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
