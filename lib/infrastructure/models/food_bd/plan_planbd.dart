class PlanPlanDB {
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

  PlanPlanDB({
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

  factory PlanPlanDB.fromJson(Map<String, dynamic> json) => PlanPlanDB(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    price: (json["price"] ?? 0).toDouble(),
    currency: json["currency"] ?? '',
    priceFormatted: json["priceFormatted"] ?? '',

    duration: json["duration"],
    durationType: json["durationType"],

    billingType: json["billingType"] ?? 'recurring',
    trialDays: json["trialDays"],

    isFree: json["isFree"] ?? false,
    isRecommended: json["isRecommended"] ?? false,

    badge: json["badge"],
    discountPercentage: json["discountPercentage"],

    features: json["features"] != null
        ? List<String>.from(json["features"])
        : [],

    order: json["order"] ?? 0,
    ctaText: json["ctaText"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "price": price,
    "currency": currency,
    "priceFormatted": priceFormatted,
    "duration": duration,
    "durationType": durationType,
    "billingType": billingType,
    "trialDays": trialDays,
    "isFree": isFree,
    "isRecommended": isRecommended,
    "badge": badge,
    "discountPercentage": discountPercentage,
    "features": features,
    "order": order,
    "ctaText": ctaText,
  };
}
