import 'package:flutter/material.dart';
import 'package:frontwe/presentation/dishes/widgets/skeleton/filter_bar_skeleton.dart';
import 'package:frontwe/presentation/dishes/widgets/skeleton/list_preview_skeleton.dart';
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
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SkeletonCircle(radius: 18),
                  const SizedBox(width: 12),
                  Expanded(
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
                  const SizedBox(width: 12),
                  const SkeletonCircle(radius: 18),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 160,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            const DishResultCardSkeleton(),
            const DishListPreviewSkeleton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
