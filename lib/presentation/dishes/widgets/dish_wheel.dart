import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/widgets/dish_detail_sheet.dart';
import 'package:frontwe/presentation/dishes/widgets/dish_result_card.dart';

class DishWheel extends StatefulWidget {
  final List<Dish> dishes;
  final int maxWheelItems;
  final Dish? selectedDish;
  final bool fromSpin;
  final ValueChanged<Dish> onSpinResult;
  final ValueChanged<Dish> onTapResult;
  final VoidCallback? onViewList;

  const DishWheel({
    super.key,
    required this.dishes,
    required this.maxWheelItems,
    required this.selectedDish,
    required this.fromSpin,
    required this.onSpinResult,
    required this.onTapResult,
    this.onViewList,
  });

  @override
  State<DishWheel> createState() => DishWheelState();
}

class DishWheelState extends State<DishWheel> {
  final _controller = StreamController<int>.broadcast();
  final _random = Random();
  int _targetIndex = 0;
  int _visualIndex = 0;

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void spin() {
    if (widget.dishes.isEmpty) return;
    _targetIndex = _random.nextInt(widget.dishes.length);
    _visualIndex = _targetIndex < widget.maxWheelItems
        ? _targetIndex
        : widget.maxWheelItems;
    _controller.add(_visualIndex);
  }

  void _onWheelTap(TapDownDetails details, List<Dish> displayDishes,
      int segmentCount, double wheelSize) {
    final center = wheelSize / 2;
    final dx = details.localPosition.dx - center;
    final dy = details.localPosition.dy - center;
    if (dx * dx + dy * dy > center * center) return;

    double angle = atan2(dy, dx) + pi / 2;
    if (angle < 0) angle += 2 * pi;

    final segmentAngle = 2 * pi / segmentCount;
    final rawIndex = (angle / segmentAngle).floor() % segmentCount;
    final adjustedIndex = (rawIndex + _visualIndex) % segmentCount;

    if (adjustedIndex < displayDishes.length) {
      widget.onTapResult(displayDishes[adjustedIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final dishes = widget.dishes;

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
            min(constraints.maxWidth - 96, constraints.maxHeight * 0.6) * 0.85;

        final cs = Theme.of(context).colorScheme;
        final palette = [cs.primary, cs.secondary, cs.tertiary];
        final displayDishes = dishes.take(widget.maxWheelItems).toList();
        final remaining = dishes.length - widget.maxWheelItems;
        final itemCount = displayDishes.length;

        final items = displayDishes.asMap().entries.map((entry) {
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

        if (remaining > 0) {
          items.add(FortuneItem(
            style: FortuneItemStyle(
              color: cs.surfaceContainerHighest,
              textStyle: TextStyle(
                color: cs.onSurfaceVariant,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text('+$remaining'),
          ));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: widget.onViewList,
                    icon: const Icon(Icons.list),
                    tooltip: t.viewList,
                  ),
                  SizedBox(
                    width: wheelSize,
                    height: wheelSize,
                    child: GestureDetector(
                      onTapDown: (details) => _onWheelTap(
                          details, displayDishes, items.length, wheelSize),
                      child: FortuneWheel(
                        animateFirst: false,
                        selected: _controller.stream,
                        items: items,
                        onAnimationEnd: () {
                          if (_targetIndex >= 0 &&
                              _targetIndex < dishes.length) {
                            widget.onSpinResult(dishes[_targetIndex]);
                          }
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: widget.dishes.isEmpty
                        ? null
                        : () => spin(),
                    icon: const Icon(Icons.shuffle),
                    tooltip: t.spinButton,
                  ),
                ],
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: widget.selectedDish != null
                    ? DishResultCard(
                        dish: widget.selectedDish!,
                        fromSpin: widget.fromSpin,
                      )
                    : Padding(
                        key: const ValueKey('empty'),
                        padding: const EdgeInsets.only(top: 24),
                        child: Center(
                          child: Text(
                            t.tapHint,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 24),
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
            min(constraints.maxWidth - 96, constraints.maxHeight * 0.6) * 0.85;

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: widget.onViewList,
                    icon: const Icon(Icons.list),
                    tooltip: t.viewList,
                  ),
                  GestureDetector(
                    onTap: () => DishDetailSheet.show(context, dish),
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
                  IconButton(
                    onPressed: () => spin(),
                    icon: const Icon(Icons.shuffle),
                    tooltip: t.spinButton,
                  ),
                ],
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: widget.selectedDish != null
                    ? DishResultCard(
                        dish: widget.selectedDish!,
                        fromSpin: widget.fromSpin,
                      )
                    : Padding(
                        key: const ValueKey('empty'),
                        padding: const EdgeInsets.only(top: 24),
                        child: Center(
                          child: Text(
                            t.tapHint,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
