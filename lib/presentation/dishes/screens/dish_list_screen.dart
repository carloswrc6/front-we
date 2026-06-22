import 'package:flutter/material.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/widgets/dish_detail_sheet.dart';

class DishListScreen extends StatelessWidget {
  final List<Dish> dishes;
  final String title;

  const DishListScreen({
    super.key,
    required this.dishes,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(title.isNotEmpty ? title : t.menuDishes),
      ),
      body: ListView.builder(
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          final dish = dishes[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(dish.name[0]),
            ),
            title: Text(dish.name),
            subtitle: Text('${dish.country.name} · ${_mealTypeLabel(t, dish.mealType)}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => DishDetailSheet.show(context, dish),
          );
        },
      ),
    );
  }

  String _mealTypeLabel(AppLocalizations t, String mealType) {
    switch (mealType) {
      case 'breakfast':
        return t.mealTypeBreakfast;
      case 'lunch':
        return t.mealTypeLunch;
      case 'dinner':
        return t.mealTypeDinner;
      default:
        return mealType;
    }
  }
}
