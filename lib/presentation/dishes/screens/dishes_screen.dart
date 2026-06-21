import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';

class DishesScreen extends ConsumerWidget {
  const DishesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final dishesAsync = ref.watch(localDishesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.menuDishes)),
      body: dishesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (dishes) {
          if (dishes.isEmpty) {
            return Center(child: Text(t.dishesEmpty));
          }
          return ListView.builder(
            itemCount: dishes.length,
            itemBuilder: (context, index) {
              final dish = dishes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(dish.image),
                    onBackgroundImageError: (_, __) =>
                        const Icon(Icons.restaurant),
                  ),
                  title: Text(dish.name),
                  subtitle: Text(
                    '${dish.country.name} · ${_mealTypeLabel(t, dish.mealType)}',
                  ),
                ),
              );
            },
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
