class PlanPlanDB {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final int duration;
  final String durationType;

  PlanPlanDB({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.duration,
    required this.durationType,
  });

  factory PlanPlanDB.fromJson(Map<String, dynamic> json) => PlanPlanDB(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    price: json["price"]?.toDouble(),
    currency: json["currency"],
    duration: json["duration"],
    durationType: json["durationType"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "price": price,
    "currency": currency,
    "duration": duration,
    "durationType": durationType,
  };
}
