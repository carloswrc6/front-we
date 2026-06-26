import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:frontwe/domain/entities/dish.dart';
import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/dishes/widgets/detail_sheet.dart';
import 'package:frontwe/presentation/dishes/widgets/result_card.dart';

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

class DishWheelState extends State<DishWheel> with SingleTickerProviderStateMixin {
  final _controller = StreamController<int>.broadcast();
  final _random = Random();
  int _targetIndex = 0;
  int _visualIndex = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.close();
    _pulseController.dispose();
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ListButton(onPressed: widget.onViewList, label: t.viewList),
                  const SizedBox(width: 32),
                  _SpinButton(
                    onPressed: widget.dishes.isEmpty ? null : () => spin(),
                    pulseAnimation: _pulseAnimation,
                    label: t.spinButton,
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: widget.selectedDish != null
                    ? Column(
                        children: [
                          DishResultCard(
                            dish: widget.selectedDish!,
                            fromSpin: widget.fromSpin,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ListButton(onPressed: widget.onViewList, label: t.viewList),
                  const SizedBox(width: 32),
                  _SpinButton(
                    onPressed: () => spin(),
                    pulseAnimation: _pulseAnimation,
                    label: t.spinButton,
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: widget.selectedDish != null
                    ? Column(
                        children: [
                          DishResultCard(
                            dish: widget.selectedDish!,
                            fromSpin: widget.fromSpin,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _ListButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const _ListButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.list),
            tooltip: label,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: cs.onSurfaceVariant,
        )),
      ],
    );
  }
}

class _SpinButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Animation<double> pulseAnimation;
  final String label;

  const _SpinButton({
    required this.onPressed,
    required this.pulseAnimation,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: onPressed != null ? pulseAnimation.value : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: onPressed != null ? cs.primary : cs.surfaceContainerHighest,
                  boxShadow: onPressed != null
                      ? [
                          BoxShadow(
                            color: cs.primary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.shuffle,
                    color: onPressed != null ? cs.onPrimary : cs.onSurfaceVariant,
                  ),
                  tooltip: label,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: cs.onSurfaceVariant,
        )),
      ],
    );
  }
}
