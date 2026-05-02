class Plan {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final int duration;
  final String durationType;

  Plan({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.duration,
    required this.durationType,
  });
}
