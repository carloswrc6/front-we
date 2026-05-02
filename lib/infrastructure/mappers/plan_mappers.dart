import 'package:frontwe/domain/entities/plan.dart';
import 'package:frontwe/infrastructure/models/food_bd/plan_planbd.dart';

class PlanMapper {
  static Plan planDBToEntity(PlanPlanDB planDB) => Plan(
    id: planDB.id,
    title: planDB.title,
    description: planDB.description,
    price: planDB.price,
    currency: planDB.currency,
    duration: planDB.duration,
    durationType: planDB.durationType,
  );
}
