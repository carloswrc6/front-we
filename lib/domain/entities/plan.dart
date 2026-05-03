class Plan {
  final String id;
  final String title;
  final String description;

  final double price;
  final String currency;
  final String priceFormatted;

  final int? duration;
  final String? durationType;

  final String billingType;
  final int? trialDays;

  final bool isFree;
  final bool isRecommended;

  final String? badge;
  final int? discountPercentage;

  final List<String> features;

  final int order;
  final String? ctaText;

  Plan({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.priceFormatted,
    this.duration,
    this.durationType,
    required this.billingType,
    this.trialDays,
    required this.isFree,
    required this.isRecommended,
    this.badge,
    this.discountPercentage,
    required this.features,
    required this.order,
    this.ctaText,
  });
}
