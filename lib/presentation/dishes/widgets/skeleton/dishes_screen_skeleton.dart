import 'package:flutter/material.dart';
import 'package:frontwe/presentation/dishes/widgets/skeleton/dish_filter_bar_skeleton.dart';
import 'package:frontwe/presentation/shared/widgets/SkeletonWidget.dart';

class DishesScreenSkeleton extends StatelessWidget {
  const DishesScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLayout(
      child: Column(
        children: [
          const DishFilterBarSkeleton(),
          const SizedBox(height: 15),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _skeletonCircle(36),
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
                      _skeletonCircle(36),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _skeletonCircle(double size) {
  return Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
  );
}
