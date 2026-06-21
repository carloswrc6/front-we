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
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (dishes) {
          if (dishes.isEmpty) return Center(child: Text(t.dishesEmpty));
          return countriesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Text('Error: $err'),
            data: (countries) {
              if (!_defaultsInitialized) {
                _defaultsInitialized = true;
                _selectedMealType = 'lunch';
                final peru = countries.where((c) => c.code == 'PE').firstOrNull;
                if (peru != null) _selectedCountryId = peru.id;
              }
              final filtered = _filter(dishes);
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

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: CountrySelector(
              showAll: false,
              countries: countries,
              selectedCountryId: _selectedCountryId,
              onChanged: (v) => setState(() {
                _selectedCountryId = v;
                _selectedDish = null;
              }),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String?>(
              value: _selectedMealType,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: t.filterMealType,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                isDense: true,
              ),
              items: [
                DropdownMenuItem(value: null, child: Text(t.filterAll)),
                ...mealTypes.map(
                  (mt) => DropdownMenuItem(
                    value: mt,
                    child: Text(_mealTypeLabel(t, mt)),
                  ),
                ),
              ],
              onChanged: (v) => setState(() {
                _selectedMealType = v;
                _selectedDish = null;
              }),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: filtered.isEmpty ? null : () => _spin(filtered),
            icon: const Icon(Icons.shuffle),
            label: Text(t.spinButton),
          ),
        ],
      ),
    );
  }

  Widget _buildWheel(AppLocalizations t, List<Dish> dishes) {
    if (dishes.isEmpty) {
      return Center(child: Text(t.filterEmpty));
    }

    if (dishes.length <= 1) {
      final dish = dishes.first;
      return Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(dish.image),
              onBackgroundImageError: (_, __) => const Icon(Icons.restaurant),
            ),
            title: Text(
              dish.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              '${dish.country.name} · ${_mealTypeLabel(t, dish.mealType)}',
            ),
          ),
        ),
      );
    }

    final items = dishes.map((d) {
      return FortuneItem(
        child: Text(d.name, style: const TextStyle(fontSize: 11)),
      );
    }).toList();

    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          width: 320,
          height: 320,
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
        if (_selectedDish != null) ...[
          const SizedBox(height: 12),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(_selectedDish!.image),
                onBackgroundImageError: (_, __) => const Icon(Icons.restaurant),
              ),
              title: Text(
                _selectedDish!.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${_selectedDish!.country.name} · ${_mealTypeLabel(t, _selectedDish!.mealType)}',
              ),
            ),
          ),
        ],
      ],
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
