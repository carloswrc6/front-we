class AvoidReasonModel {
  final String key;
  final String label;
  final String description;

  AvoidReasonModel({
    required this.key,
    required this.label,
    required this.description,
  });

  factory AvoidReasonModel.fromJson(Map<String, dynamic> json) {
    return AvoidReasonModel(
      key: json['key'] as String,
      label: json['label'] as String,
      description: json['description'] as String,
    );
  }
}
