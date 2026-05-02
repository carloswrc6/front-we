import 'dart:convert';

import 'package:frontwe/infrastructure/models/food_bd/paginationbd_response.dart';
import 'package:frontwe/infrastructure/models/food_bd/plan_planbd.dart';

PlanDbResponse planFromJson(String str) =>
    PlanDbResponse.fromJson(json.decode(str));

String planToJson(PlanDbResponse data) => json.encode(data.toJson());

class PlanDbResponse {
  final List<PlanPlanDB> data;
  final Pagination meta;

  PlanDbResponse({required this.data, required this.meta});

  factory PlanDbResponse.fromJson(Map<String, dynamic> json) => PlanDbResponse(
    data: List<PlanPlanDB>.from(
      json["data"].map((x) => PlanPlanDB.fromJson(x)),
    ),
    meta: Pagination.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };
}
