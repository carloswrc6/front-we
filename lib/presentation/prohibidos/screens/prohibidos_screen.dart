import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/shared/widgets/BottomNavBar.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';

class EvitarScreen extends ConsumerWidget {
  const EvitarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final dishesAsync = ref.watch(localDishesProvider);

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(t.avoidTitle)),
      bottomNavigationBar: const BottomNavBar(),
      body: dishesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('$err')),
        data: (dishes) {
          final avoided = dishes.where((d) => d.isAvoided).toList();
          if (avoided.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.thumb_down, size: 64, color: cs.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(
                    t.avoidEmpty,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: avoided.length,
            itemBuilder: (context, index) {
              final dish = avoided[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: Icon(Icons.thumb_down, color: Colors.blue),
                  title: Text(dish.name),
                  subtitle: dish.avoidReason != null && dish.avoidReason!.isNotEmpty
                      ? Text(dish.avoidReason!)
                      : Text(dish.country.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.undo),
                    tooltip: 'Quitar',
                    onPressed: () async {
                      await ref.read(dishRepositoryProvider).toggleAvoided(dish.id);
                      ref.invalidate(localDishesProvider);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
