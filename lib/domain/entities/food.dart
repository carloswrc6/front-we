class Food {
  final String name;
  final String type; // desayuno, almuerzo, cena, snack
  final bool isFavorite;
  final bool isHealthy;
  final int calories;

  Food({
    required this.name,
    required this.type,
    required this.isFavorite,
    required this.isHealthy,
    required this.calories,
  });
}
