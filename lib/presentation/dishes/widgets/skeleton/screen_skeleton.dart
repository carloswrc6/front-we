import 'package:flutter/material.dart';
import 'package:frontwe/presentation/dishes/widgets/skeleton/filter_bar_skeleton.dart';
import 'package:frontwe/presentation/dishes/widgets/skeleton/result_card_skeleton.dart';
import 'package:frontwe/presentation/shared/widgets/SkeletonWidget.dart';

class DishesScreenSkeleton extends StatelessWidget {
  const DishesScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const DishFilterBarSkeleton(),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buttonColumn(50),
                const SizedBox(width: 32),
                _buttonColumn(35),
              ],
            ),
            const DishResultCardSkeleton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

Widget _buttonColumn(double labelWidth) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SkeletonCircle(radius: 18),
      const SizedBox(height: 4),
      SkeletonBox(width: labelWidth, height: 10),
    ],
  );
}
