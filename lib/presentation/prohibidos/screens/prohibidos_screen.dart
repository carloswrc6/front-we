import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/country.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/providers/dish_providers.dart';
import 'package:frontwe/presentation/dishes/widgets/filter_bar.dart';
import 'package:frontwe/presentation/shared/widgets/avoid_reason_dialog.dart';
import 'package:frontwe/presentation/shared/providers/avoid_reason_provider.dart';
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
  List<String> _customReasons = [];
  bool _sugerenciasExpanded = true;
  bool _tusMotivosExpanded = true;

  @override
  void initState() {
    super.initState();
    _loadCustomReasons();
  }
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
    final countriesAsync = ref.watch(localCountriesProvider);
    final reasonsAsync = ref.watch(avoidReasonsProvider);
    final apiReasons = reasonsAsync.whenOrNull(
      data: (list) => list.map((m) => AvoidReason(m.key, m.label, m.description)).toList(),
    );

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

          return countriesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (countries) {
              return Column(
                children: [
                  FilterContainer(
                    topChild: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: t.searchDishes,
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
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
                    child: filtered.isEmpty
                        ? Center(
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
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final dish = filtered[index];
                              final isRemoving = _removingIds.contains(dish.id);
                              final dishCountry = countries.where((c) => c.id == dish.country.id).firstOrNull;

                              return AnimatedOpacity(
                                duration: const Duration(milliseconds: 400),
                                opacity: isRemoving ? 0.0 : 1.0,
                                child: _buildCard(dish, dishCountry, cs, t, apiReasons ?? []),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCard(Dish dish, Country? dishCountry, ColorScheme cs, AppLocalizations t, List<AvoidReason> reasons) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _dishImage(dish, cs, reasons),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(_codeToFlag(dishCountry?.code ?? ''), style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 6),
                    Icon(_mealTypeIcon(dish.mealType), size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${_mealTypeLabel(t, dish.mealType)} · ${dishCountry?.name ?? dish.country.name}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () => _removeAvoided(dish),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                      ),
                    ),
                  ],
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
    final repo = ref.read(dishRepositoryProvider);
    final apiReasonsAsync = ref.read(avoidReasonsProvider);
    final apiReasons = apiReasonsAsync.whenOrNull(
      data: (list) => list.map((m) => AvoidReason(m.key, m.label, m.description)).toList(),
    );
    final reason = await showAvoidReasonDialog(
      context,
      initialReason: dish.avoidReason,
      predefined: apiReasons ?? [],
      customReasons: _customReasons,
      onSaveCustomReason: (label) => repo.saveCustomAvoidReason(label),
      sugerenciasExpanded: _sugerenciasExpanded,
      tusMotivosExpanded: _tusMotivosExpanded,
      onSugerenciasExpandedChanged: (v) => _sugerenciasExpanded = v,
      onTusMotivosExpandedChanged: (v) => _tusMotivosExpanded = v,
    );
    if (reason != null && mounted) {
      await repo.setAvoidReason(
        dish.id,
        reason == '__clear__' ? null : reason,
      );
      ref.invalidate(localDishesProvider);
    }
    _loadCustomReasons();
  }

  Future<void> _loadCustomReasons() async {
    final reasons = await ref.read(dishRepositoryProvider).getCustomAvoidReasons();
    if (mounted) setState(() => _customReasons = reasons);
  }

  Future<void> _clearReason(Dish dish) async {
    await ref.read(dishRepositoryProvider).setAvoidReason(dish.id, null);
    ref.invalidate(localDishesProvider);
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

  IconData _mealTypeIcon(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.restaurant;
      case 'dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  Widget _dishImage(Dish dish, ColorScheme cs, List<AvoidReason> reasons) {
    final hasReason = dish.avoidReason != null && dish.avoidReason!.isNotEmpty;
    String reasonLabel(String? key) {
      if (key == null || key.isEmpty) return '';
      final match = reasons.where((r) => r.key == key);
      return match.isNotEmpty ? match.first.label : key;
    }
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
                        hasReason
                            ? reasonLabel(dish.avoidReason)
                            : 'Toca para añadir motivo',
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

String _codeToFlag(String code) {
  return code.toUpperCase().split('').map((c) {
    return String.fromCharCode(c.codeUnitAt(0) - 0x41 + 0x1F1E6);
  }).join('');
}
