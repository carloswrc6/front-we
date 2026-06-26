import 'package:flutter/material.dart';
import 'package:frontwe/presentation/shared/widgets/SkeletonWidget.dart';

class DishesScreenSkeleton extends StatelessWidget {
  const DishesScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLayout(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            color: Colors.white,
            child: Column(
              children: [
                const Row(
                  children: [
                    SkeletonBox(width: 90, height: 100, borderRadius: 16),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonCircle(radius: 18),
                      SizedBox(width: 12),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: SkeletonCircle(radius: 120),
                        ),
                      ),
                      SizedBox(width: 12),
                      SkeletonCircle(radius: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Center(child: SkeletonBox(width: 160, height: 14)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  color: const Color.fromARGB(255, 119, 62, 62),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          SkeletonBox(width: 90, height: 300, borderRadius: 16),
                          SizedBox(width: 8),
                        ],
                      ),
                    ],
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
