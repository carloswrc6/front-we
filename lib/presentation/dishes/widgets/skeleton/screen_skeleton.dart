import 'package:flutter/material.dart';
import 'package:frontwe/presentation/dishes/widgets/skeleton/filter_bar_skeleton.dart';
import 'package:frontwe/presentation/shared/widgets/SkeletonWidget.dart';

class DishesScreenSkeleton extends StatelessWidget {
  const DishesScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ShimmerLayout(
      child: Column(
        children: [
          const DishFilterBarSkeleton(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _iconButton(36, 36),
                      const SizedBox(width: 16),
                      _iconButton(36, 36),
                      const SizedBox(width: 16),
                      _iconButton(48, 48),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _resultCard(cs),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _resultCard(ColorScheme cs) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
    child: Card(
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                SkeletonCircle(radius: 32),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: SkeletonCircle(radius: 8),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(child: SkeletonBox(height: 20)),
                      const SizedBox(width: 8),
                      SkeletonBox(width: 16, height: 16, borderRadius: 4),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SkeletonBox(width: 80, height: 12),
                  const SizedBox(height: 6),
                  SkeletonBox(width: 120, height: 12),
                  const SizedBox(height: 6),
                  SkeletonBox(width: 200, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _iconButton(double w, double h) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SkeletonCircle(radius: w / 2),
      const SizedBox(height: 4),
      SkeletonBox(width: w * 0.8, height: 8),
    ],
  );
}
