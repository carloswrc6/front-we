import 'package:frontwe/domain/entities/plan.dart';
import 'package:frontwe/infrastructure/models/food_bd/plan_planbd.dart';

class PlanMapper {
  static Plan planDBToEntity(PlanPlanDB planDB) => Plan(
    id: planDB.id,
    title: planDB.title,
    description: planDB.description,

    price: planDB.price,
    currency: planDB.currency,
    priceFormatted: planDB.priceFormatted,

    duration: planDB.duration,
    durationType: planDB.durationType,

    billingType: planDB.billingType,
    trialDays: planDB.trialDays,

    isFree: planDB.isFree,
    isRecommended: planDB.isRecommended,

    badge: planDB.badge,
    discountPercentage: planDB.discountPercentage,

    features: planDB.features,

    order: planDB.order,
    ctaText: planDB.ctaText,
  );
}
