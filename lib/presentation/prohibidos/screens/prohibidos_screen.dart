import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/dishes/widgets/filter_bar.dart';
import 'package:frontwe/presentation/shared/widgets/BottomNavBar.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';

class EvitarScreen extends ConsumerStatefulWidget {
  const EvitarScreen({super.key});

  @override
  ConsumerState<EvitarScreen> createState() => _EvitarScreenState();
}

class _EvitarScreenState extends ConsumerState<EvitarScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  List<Dish> _avoided = [];
  final Set<String> _removingIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          _avoided = dishes.where((d) => d.isAvoided).toList();
          _removingIds.removeWhere((id) => !_avoided.any((d) => d.id == id));

          final filtered = _avoided.where((d) {
            if (_searchQuery.isEmpty) return true;
            return d.name.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _searchQuery.isNotEmpty ? Icons.search_off : Icons.thumb_down_outlined,
                    size: 64,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isNotEmpty ? t.filterEmpty : t.avoidEmpty,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              FilterContainer(
                topChild: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: t.searchDishes,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: cs.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                ),
                bottomChild: const SizedBox.shrink(),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final dish = filtered[index];
                    final isRemoving = _removingIds.contains(dish.id);

                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: isRemoving ? 0.0 : 1.0,
                      child: _buildCard(dish, cs, t),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(Dish dish, ColorScheme cs, AppLocalizations t) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _dishImage(dish, cs),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => _removeAvoided(dish),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        dish.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  dish.country.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeAvoided(Dish dish) async {
    setState(() => _removingIds.add(dish.id));

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    await ref.read(dishRepositoryProvider).toggleAvoided(dish.id);
    ref.invalidate(localDishesProvider);
  }

  Future<void> _editReason(Dish dish) async {
    final controller = TextEditingController(text: dish.avoidReason ?? '');
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Motivo'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '¿Por qué lo evitas?',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, '__clear__'),
            child: const Text('Limpiar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (reason != null && mounted) {
      await ref.read(dishRepositoryProvider).setAvoidReason(
        dish.id,
        reason == '__clear__' ? null : reason,
      );
      ref.invalidate(localDishesProvider);
    }
  }

  Future<void> _clearReason(Dish dish) async {
    await ref.read(dishRepositoryProvider).setAvoidReason(dish.id, null);
    ref.invalidate(localDishesProvider);
  }

  Widget _dishImage(Dish dish, ColorScheme cs) {
    final hasReason = dish.avoidReason != null && dish.avoidReason!.isNotEmpty;
    return GestureDetector(
      onTap: () => _editReason(dish),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (dish.image.isEmpty)
            _imagePlaceholder(cs)
          else
            Image.network(
              dish.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _imagePlaceholder(cs),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: cs.surfaceContainerHigh,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () => _editReason(dish),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        hasReason ? dish.avoidReason! : 'Toca para añadir motivo',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontStyle: hasReason ? FontStyle.normal : FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (hasReason)
                      GestureDetector(
                        onTap: () => _clearReason(dish),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(Icons.close, size: 16, color: Colors.white70),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder(ColorScheme cs) {
    return Container(
      color: cs.surfaceContainerHigh,
      child: Center(
        child: Icon(Icons.restaurant, size: 48, color: cs.onSurfaceVariant),
      ),
    );
  }
}
