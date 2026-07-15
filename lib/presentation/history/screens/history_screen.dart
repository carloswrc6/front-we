import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontwe/domain/entities/dish_history.dart';
import 'package:frontwe/infrastructure/services/local_db_service.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/widgets/detail_sheet.dart';
import 'package:frontwe/presentation/history/providers/history_provider.dart';
import 'package:frontwe/presentation/shared/widgets/BottomNavBar.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';
import 'package:frontwe/presentation/shared/widgets/SkeletonWidget.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _dateFilter;
  String? _sourceFilter = 'spin';
  final Set<DishHistory> _selectedEntries = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final historyAsync = ref.watch(historyProvider);
    final selectionMode = _selectedEntries.isNotEmpty;

    return Scaffold(
      drawer: selectionMode ? null : const SideMenu(),
      appBar: AppBar(
        title: selectionMode
            ? Text('${_selectedEntries.length} ${t.historialSelectedCount}')
            : Text(t.historialTitle),
        leading: selectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() {
                  _selectedEntries.clear();
                  _dateFilter = null;
                  _sourceFilter = null;
                }),
              )
            : null,
        actions: [
          if (selectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelected,
            )
          else if (historyAsync.hasValue && historyAsync.value!.isNotEmpty)
            IconButton(
              onPressed: _clearHistory,
              icon: const Icon(Icons.delete_outline),
              tooltip: t.historialClearAll,
            ),
        ],
      ),
      bottomNavigationBar: selectionMode ? null : const BottomNavBar(),
      body: historyAsync.when(
        loading: () => const _HistorySkeleton(),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: cs.error),
              const SizedBox(height: 16),
              Text('${t.errorLabel}: $err'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => ref.invalidate(historyProvider),
                icon: const Icon(Icons.refresh),
                label: Text(t.retryButton),
              ),
            ],
          ),
        ),
        data: (history) {
          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 64, color: cs.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(
                    t.historialEmpty,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
          final filtered = _filtered(history);
          final dateFilters = [
            _DateFilter(id: null, label: t.filterAll),
            _DateFilter(id: 'today', label: t.historialToday),
            _DateFilter(id: 'yesterday', label: t.historialYesterday),
            _DateFilter(id: 'week', label: t.historialThisWeek),
            _DateFilter(id: 'earlier', label: t.historialPrevious),
          ];
          final dateFiltered = _dateFilter != null
              ? _filterByDate(filtered, _dateFilter!)
              : filtered;
          final grouped = _groupByDate(dateFiltered, t);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: t.searchDishes,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() {
                    _searchQuery = v.toLowerCase();
                    _dateFilter = null;
                    _sourceFilter = null;
                    _selectedEntries.clear();
                  }),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: dateFilters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final f = dateFilters[i];
                    final selected = _dateFilter == f.id;
                    return FilterChip(
                      label: Text(f.label, style: const TextStyle(fontSize: 13)),
                      selected: selected,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onSelected: (_) => setState(() {
                        _dateFilter = f.id;
                        _selectedEntries.clear();
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final sourceFilters = [
                      _DateFilter(id: null, label: t.historialBoth),
                      _DateFilter(id: 'spin', label: t.historialSpin),
                      _DateFilter(id: 'view', label: t.historialView),
                    ];
                    final f = sourceFilters[i];
                    final selected = _sourceFilter == f.id;
                    return FilterChip(
                      label: Text(f.label, style: const TextStyle(fontSize: 13)),
                      selected: selected,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onSelected: (_) => setState(() {
                        _sourceFilter = f.id;
                        _selectedEntries.clear();
                      }),
                    );
                  },
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
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        children: [
                          for (final group in grouped) ...[
                            _SectionHeader(label: group.label),
                            for (final entry in group.entries) _HistoryItem(
                              entry: entry,
                              isSelected: _selectedEntries.contains(entry),
                              onTap: () => _onItemTap(entry),
                              onLongPress: () => _toggleSelection(entry),
                              getFlag: _codeToFlag,
                              getMealTypeLabel: (mt) => _mealTypeLabel(t, mt),
                              getMealTypeIcon: _mealTypeIcon,
                              formatDate: _formatDate,
                            ),
                          ],
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onItemTap(DishHistory entry) {
    if (_selectedEntries.isNotEmpty) {
      _toggleSelection(entry);
    } else {
      DishDetailSheet.show(context, entry.dish);
    }
  }

  void _toggleSelection(DishHistory entry) {
    setState(() {
      if (_selectedEntries.contains(entry)) {
        _selectedEntries.remove(entry);
      } else {
        _selectedEntries.add(entry);
      }
    });
  }

  List<DishHistory> _filtered(List<DishHistory> history) {
    var result = history;
    if (_sourceFilter != null) {
      result = result.where((e) =>
        _sourceFilter == 'spin' ? e.fromSpin : !e.fromSpin
      ).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result.where((e) =>
        e.dishName.toLowerCase().contains(_searchQuery)
      ).toList();
    }
    return result;
  }

  List<DishHistory> _filterByDate(List<DishHistory> entries, String filter) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));
    return entries.where((e) {
      final day = DateTime(e.selectedAt.year, e.selectedAt.month, e.selectedAt.day);
      switch (filter) {
        case 'today': return day == today;
        case 'yesterday': return day == yesterday;
        case 'week': return day.isAfter(thisWeekStart.subtract(const Duration(days: 1)));
        case 'earlier': return !day.isAfter(thisWeekStart.subtract(const Duration(days: 1)));
        default: return true;
      }
    }).toList();
  }

  List<_DateGroup> _groupByDate(List<DishHistory> entries, AppLocalizations t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));

    Map<String, List<DishHistory>> groups = {};
    for (final e in entries) {
      final day = DateTime(e.selectedAt.year, e.selectedAt.month, e.selectedAt.day);
      String label;
      if (day == today) {
        label = t.historialToday;
      } else if (day == yesterday) {
        label = t.historialYesterday;
      } else if (day.isAfter(thisWeekStart.subtract(const Duration(days: 1)))) {
        label = t.historialThisWeek;
      } else {
        label = t.historialPrevious;
      }
      groups.putIfAbsent(label, () => []).add(e);
    }
    final order = [t.historialToday, t.historialYesterday, t.historialThisWeek, t.historialPrevious];
    return order
      .where((l) => groups.containsKey(l))
      .map((l) => _DateGroup(label: l, entries: groups[l]!))
      .toList();
  }

  Future<void> _deleteSelected() async {
    final t = AppLocalizations.of(context)!;
    final count = _selectedEntries.length;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.historialDelete),
        content: Text('${t.historialDeleteConfirm} ($count)'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.historialCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(t.historialDelete)),
        ],
      ),
    );
    if (confirm == true) {
      final db = LocalDbService.instance;
      for (final entry in _selectedEntries) {
        final dbInstance = await db.database;
        await dbInstance.delete('dish_history', where: 'id = ?', whereArgs: [entry.id]);
      }
      setState(_selectedEntries.clear);
      ref.invalidate(historyProvider);
    }
  }

  Future<void> _clearHistory() async {
    final t = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.historialClearAll),
        content: Text(t.historialClearConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.historialCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(t.historialDelete)),
        ],
      ),
    );
    if (confirm == true) {
      await LocalDbService.instance.clearHistory();
      ref.invalidate(historyProvider);
    }
  }

  String _mealTypeLabel(AppLocalizations t, String mealType) {
    switch (mealType) {
      case 'breakfast': return t.mealTypeBreakfast;
      case 'lunch': return t.mealTypeLunch;
      case 'dinner': return t.mealTypeDinner;
      default: return mealType;
    }
  }

  IconData _mealTypeIcon(String mealType) {
    switch (mealType) {
      case 'breakfast': return Icons.free_breakfast;
      case 'lunch': return Icons.restaurant;
      case 'dinner': return Icons.dinner_dining;
      default: return Icons.restaurant;
    }
  }

  String _codeToFlag(String code) {
    return code.toUpperCase().split('').map((c) {
      return String.fromCharCode(c.codeUnitAt(0) - 0x41 + 0x1F1E6);
    }).join('');
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inHours < 1) return 'Hace ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'Hace ${diff.inHours} h';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} d';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _DateFilter {
  final String? id;
  final String label;
  const _DateFilter({this.id, required this.label});
}

class _DateGroup {
  final String label;
  final List<DishHistory> entries;
  _DateGroup({required this.label, required this.entries});
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: cs.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final DishHistory entry;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String Function(String) getFlag;
  final String Function(String) getMealTypeLabel;
  final IconData Function(String) getMealTypeIcon;
  final String Function(DateTime) formatDate;

  const _HistoryItem({
    required this.entry,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.getFlag,
    required this.getMealTypeLabel,
    required this.getMealTypeIcon,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dish = entry.dish;

    return Material(
      color: isSelected ? cs.primaryContainer.withValues(alpha: 0.3) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: dish.image.isNotEmpty
                        ? NetworkImage(dish.image)
                        : null,
                    onBackgroundImageError: dish.image.isNotEmpty
                        ? (_, __) => const Icon(Icons.restaurant, size: 20)
                        : null,
                    child: dish.image.isEmpty
                        ? Icon(Icons.restaurant, size: 20, color: cs.onSurfaceVariant)
                        : null,
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cs.primary
                            : entry.fromSpin
                                ? cs.primary
                                : cs.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        border: Border.all(color: cs.surface, width: 2),
                      ),
                      child: Icon(
                        isSelected ? Icons.check : (entry.fromSpin ? Icons.shuffle : Icons.remove_red_eye),
                        size: 12,
                        color: isSelected ? cs.onPrimary : (entry.fromSpin ? cs.onPrimary : cs.onSurfaceVariant),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(getFlag(dish.country.code), style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Icon(getMealTypeIcon(dish.mealType), size: 13, color: cs.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          '${getMealTypeLabel(dish.mealType)} · ${dish.country.name}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (isSelected)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(Icons.check_circle, size: 14, color: cs.primary),
                          ),
                        Text(
                          formatDate(entry.selectedAt),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected ? cs.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSelected ? Icons.check : Icons.chevron_right,
                  size: 18,
                  color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistorySkeleton extends StatelessWidget {
  const _HistorySkeleton();

  @override
  Widget build(BuildContext context) {
    return ShimmerLayout(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        children: [
          _skeletonSectionHeader(),
          ...List.generate(3, (_) => _skeletonItem()),
          _skeletonSectionHeader(),
          ...List.generate(2, (_) => _skeletonItem()),
          _skeletonSectionHeader(),
          ...List.generate(2, (_) => _skeletonItem()),
        ],
      ),
    );
  }

  Widget _skeletonSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
      child: SkeletonBox(width: 80, height: 14),
    );
  }

  Widget _skeletonItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SkeletonCircle(radius: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 160, height: 14),
                const SizedBox(height: 6),
                SkeletonBox(width: 120, height: 12),
                const SizedBox(height: 4),
                SkeletonBox(width: 60, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
