import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/dishes/widgets/filter_bar.dart';
import 'package:frontwe/presentation/shared/widgets/BottomNavBar.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';
import 'package:frontwe/presentation/shared/widgets/CountrySelector.dart';
import 'package:go_router/go_router.dart';


class PlatosScreen extends ConsumerStatefulWidget {
  const PlatosScreen({super.key});

  @override
  ConsumerState<PlatosScreen> createState() => _PlatosScreenState();
}

class _PlatosScreenState extends ConsumerState<PlatosScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCountryId;
  String? _selectedMealType;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final dishesAsync = ref.watch(localDishesProvider);
    final countriesAsync = ref.watch(localCountriesProvider);

    return dishesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('$err')),
      data: (dishes) {
        return Scaffold(
          drawer: const SideMenu(),
          appBar: AppBar(title: Text(t.platosTitle)),
          floatingActionButton: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.primary,
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => context.push('/crear-plato'),
                    icon: const Icon(Icons.add),
                    color: cs.onPrimary,
                    tooltip: 'Add dish',
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: const BottomNavBar(),
          body: countriesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (countries) {
              final filtered = _filter(dishes).where((d) {
                if (_searchQuery.isEmpty) return true;
                return d.name.toLowerCase().contains(_searchQuery);
              }).toList();

              return Column(
                children: [
                  FilterContainer(
                    topChild: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextField(
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
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: CountrySelector(
                            compact: true,
                            showAll: true,
                            countries: countries,
                            selectedCountryId: _selectedCountryId,
                            onChanged: (v) => setState(() => _selectedCountryId = v),
                          ),
                        ),
                      ],
                    ),
                    bottomChild: DishFilterBar(
                      selectedMealType: _selectedMealType,
                      dishCount: filtered.length,
                      onMealTypeChanged: (v) => setState(() => _selectedMealType = v),
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off, size: 48, color: cs.onSurfaceVariant),
                                const SizedBox(height: 8),
                                Text(t.filterEmpty, style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final dish = filtered[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: GestureDetector(
                                          onDoubleTap: () => _toggleFavorite(dish),
                                          child: _dishImage(dish, cs),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () => _toggleFavorite(dish),
                                                        child: Container(
                                                          padding: const EdgeInsets.all(4),
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey.withValues(alpha: 0.3),
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          child: Icon(
                                                            dish.isFavorite ? Icons.favorite : Icons.favorite_border,
                                                            size: 16,
                                                            color: dish.isFavorite ? Colors.red : Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      GestureDetector(
                                                        onTap: () => _toggleAvoided(dish),
                                                        onLongPressStart: (_) => _showAvoidReasonDialog(dish),
                                                        child: Container(
                                                          padding: const EdgeInsets.all(4),
                                                          decoration: BoxDecoration(
                                                            color: dish.isAvoided ? Colors.blue.withValues(alpha: 0.8) : Colors.grey.withValues(alpha: 0.3),
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          child: Icon(
                                                            dish.isAvoided ? Icons.thumb_down : Icons.thumb_down_outlined,
                                                            size: 14,
                                                            color: dish.isAvoided ? Colors.white : Colors.grey,
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
                                            Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  List<Dish> _filter(List<Dish> dishes) {
    return dishes.where((d) {
      if (_selectedCountryId != null && d.country.id != _selectedCountryId) {
        return false;
      }
      if (_selectedMealType != null && d.mealType != _selectedMealType) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _toggleFavorite(Dish dish) async {
    await ref.read(dishRepositoryProvider).toggleFavorite(dish.id);
    ref.invalidate(localDishesProvider);
  }

  Future<void> _toggleAvoided(Dish dish) async {
    await ref.read(dishRepositoryProvider).toggleAvoided(dish.id);
    ref.invalidate(localDishesProvider);
  }

  Future<void> _showAvoidReasonDialog(Dish dish) async {
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
    if (reason != null) {
      if (!dish.isAvoided) {
        await ref.read(dishRepositoryProvider).toggleAvoided(dish.id);
      }
      await ref.read(dishRepositoryProvider).setAvoidReason(
        dish.id,
        reason == '__clear__' ? null : reason,
      );
      ref.invalidate(localDishesProvider);
    }
  }

  Widget _dishImage(Dish dish, ColorScheme cs) {
    return Stack(
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
        if (dish.isUserCreated)
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, size: 11, color: Colors.white70),
                  const SizedBox(width: 3),
                  Text(
                    'Tú',
                    style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
      ],
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
