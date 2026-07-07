import 'dart:convert';

class DishModel {
  final String id;
  final String name;
  final String image;
  final List<String> ingredients;
  final String mealType;
  final String countryId;
  final Map<String, dynamic>? country;
  final String? difficulty;

  DishModel({
    required this.id,
    required this.name,
    required this.image,
    required this.ingredients,
    required this.mealType,
    required this.countryId,
    this.country,
    this.difficulty,
  });

  factory DishModel.fromJson(Map<String, dynamic> json) => DishModel(
    id: json['id'],
    name: json['name'],
    image: json['image'],
    ingredients: List<String>.from(json['ingredients'] ?? []),
    mealType: json['mealType'],
    countryId: json['countryId'],
    country: json['country'],
    difficulty: json['difficulty'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'ingredients': ingredients,
    'mealType': mealType,
    'countryId': countryId,
    'country': country,
    'difficulty': difficulty,
  };

  String get ingredientsJson => jsonEncode(ingredients);

  static List<String> ingredientsFromJson(String json) =>
      List<String>.from(jsonDecode(json));
}
