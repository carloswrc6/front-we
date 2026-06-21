import 'dart:convert';

class DishModel {
  final String id;
  final String name;
  final String image;
  final List<String> ingredients;
  final String mealType;
  final String countryId;
  final Map<String, dynamic>? country;

  DishModel({
    required this.id,
    required this.name,
    required this.image,
    required this.ingredients,
    required this.mealType,
    required this.countryId,
    this.country,
  });

  factory DishModel.fromJson(Map<String, dynamic> json) => DishModel(
    id: json['id'],
    name: json['name'],
    image: json['image'],
    ingredients: List<String>.from(json['ingredients'] ?? []),
    mealType: json['mealType'],
    countryId: json['countryId'],
    country: json['country'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'ingredients': ingredients,
    'mealType': mealType,
    'countryId': countryId,
    'country': country,
  };

  String get ingredientsJson => jsonEncode(ingredients);

  static List<String> ingredientsFromJson(String json) =>
      List<String>.from(jsonDecode(json));
}
