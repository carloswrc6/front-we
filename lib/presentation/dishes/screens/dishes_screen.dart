import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/shared/widgets/country_selector.dart';
import 'package:frontwe/presentation/shared/widgets/CustomButton.dart';

class DishesScreen extends ConsumerStatefulWidget {
  const DishesScreen({super.key});

  @override
  ConsumerState<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends ConsumerState<DishesScreen> {
  String? _selectedCountryId;
  String? _selectedMealType;
  Dish? _selectedDish;
  final _controller = StreamController<int>.broadcast();
  final _random = Random();
  int _targetIndex = 0;
  bool _defaultsInitialized = false;

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final dishesAsync = ref.watch(localDishesProvider);
    final countriesAsync = ref.watch(localCountriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.menuDishes)),
      body: dishesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('Error: $err'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => ref.invalidate(localDishesProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (dishes) {
          if (dishes.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.restaurant,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.dishesEmpty,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          return countriesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (countries) {
              if (!_defaultsInitialized) {
                _defaultsInitialized = true;
                _selectedMealType = 'lunch';
                final peru = countries.where((c) => c.code == 'PE').firstOrNull;
                if (peru != null) _selectedCountryId = peru.id;
              }

              final filtered = _filter(dishes);
              if (filtered.length == 1) {
                _selectedDish ??= filtered.first;
              }

              return Column(
                children: [
                  _buildFilters(t, countries, filtered),
                  Expanded(child: _buildWheel(t, filtered)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFilters(
    AppLocalizations t,
    List<Country> countries,
    List<Dish> filtered,
  ) {
    final mealTypes = ['breakfast', 'lunch', 'dinner'];
    final mealTypeIcons = <String, IconData>{
      'breakfast': Icons.free_breakfast,
      'lunch': Icons.lunch_dining,
      'dinner': Icons.dinner_dining,
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CountrySelector(
            showAll: false,
            countries: countries,
            selectedCountryId: _selectedCountryId,
            onChanged: (v) => setState(() {
              _selectedCountryId = v;
              _selectedDish = null;
            }),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(
                label: Text('${filtered.length}'),
                visualDensity: VisualDensity.compact,
                labelStyle: const TextStyle(fontSize: 12),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SegmentedButton<String>(
                  segments: mealTypes.map((mt) {
                    return ButtonSegment(
                      value: mt,
                      label: const SizedBox.shrink(),
                      icon: Icon(mealTypeIcons[mt], size: 20),
                    );
                  }).toList(),
                  selected: _selectedMealType != null
                      ? {_selectedMealType!}
                      : <String>{},
                  onSelectionChanged: (Set<String> selection) {
                    setState(() {
                      _selectedMealType = selection.isNotEmpty
                          ? selection.first
                          : null;
                      _selectedDish = null;
                    });
                  },
                  showSelectedIcon: false,
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomButton(
                label: t.spinButton,
                onPressed: filtered.isEmpty ? null : () => _spin(filtered),
                icon: const Icon(Icons.shuffle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWheel(AppLocalizations t, List<Dish> dishes) {
    if (dishes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(t.filterEmpty, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }

    if (dishes.length == 1) {
      return _buildSingleDishWheel(t, dishes.first);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wheelSize =
            min(constraints.maxWidth, constraints.maxHeight * 0.6) * 0.85;

        final cs = Theme.of(context).colorScheme;
        final palette = [cs.primary, cs.secondary, cs.tertiary];
        final itemCount = dishes.length;

        final items = dishes.asMap().entries.map((entry) {
          final progress = entry.key / max(itemCount - 1, 1);
          final segment = progress * (palette.length - 1);
          final fromIndex = segment.floor();
          final toIndex = (fromIndex + 1) % palette.length;
          final t = segment - fromIndex;
          final color = Color.lerp(palette[fromIndex], palette[toIndex], t)!;

          return FortuneItem(
            style: FortuneItemStyle(
              color: color,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text(entry.value.name, overflow: TextOverflow.ellipsis),
          );
        }).toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              SizedBox(
                width: wheelSize,
                height: wheelSize,
                child: FortuneWheel(
                  animateFirst: false,
                  selected: _controller.stream,
                  items: items,
                  onAnimationEnd: () {
                    if (_targetIndex >= 0 && _targetIndex < dishes.length) {
                      setState(() => _selectedDish = dishes[_targetIndex]);
                    }
                  },
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedDish != null
                    ? _buildResultCard(t, _selectedDish!)
                    : const SizedBox(key: ValueKey('empty')),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSingleDishWheel(AppLocalizations t, Dish dish) {
    final cs = Theme.of(context).colorScheme;
    final palette = [cs.primary, cs.secondary, cs.tertiary];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wheelSize =
            min(constraints.maxWidth, constraints.maxHeight * 0.6) * 0.85;

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showDishDetails(dish),
                child: Container(
                  width: wheelSize,
                  height: wheelSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [palette[0], palette[1], palette[2], palette[0]],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    dish.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedDish != null
                    ? _buildResultCard(t, _selectedDish!)
                    : const SizedBox(key: ValueKey('empty')),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultCard(AppLocalizations t, Dish dish) {
    return Padding(
      key: const ValueKey('result'),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: GestureDetector(
        onTap: () => _showDishDetails(dish),
        child: Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(dish.image),
                  onBackgroundImageError: (_, __) =>
                      const Icon(Icons.restaurant),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dish.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${dish.country.name} · ${_mealTypeLabel(t, dish.mealType)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (dish.ingredients.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          dish.ingredients.join(', '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDishDetails(Dish dish) {
    final t = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    dish.image,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: const Icon(Icons.restaurant, size: 64),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  dish.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dish.country.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.schedule_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _mealTypeLabel(t, dish.mealType),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                if (dish.ingredients.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: dish.ingredients.map((ing) {
                      return Chip(
                        label: Text(ing),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _spin(List<Dish> dishes) {
    if (dishes.isEmpty) return;
    _targetIndex = _random.nextInt(dishes.length);
    setState(() => _selectedDish = null);
    _controller.add(_targetIndex);
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
