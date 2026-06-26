import 'package:flutter/material.dart';
import 'package:frontwe/presentation/shared/widgets/SkeletonWidget.dart';

class DishResultCardSkeleton extends StatelessWidget {
  const DishResultCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerLayout(
      child: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Card(
        color: cs.surfaceContainerHighest,
        child: const Padding(
          padding: EdgeInsets.all(16),
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
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SkeletonBox(height: 20, width: 180),
                        ),
                        SizedBox(width: 8),
                        SkeletonBox(height: 90, width: 16, borderRadius: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
