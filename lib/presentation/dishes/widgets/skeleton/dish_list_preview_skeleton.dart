import 'package:flutter/material.dart';
import 'package:frontwe/presentation/shared/widgets/SkeletonWidget.dart';

class DishListPreviewSkeleton extends StatelessWidget {
  final int itemCount;

  const DishListPreviewSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ShimmerLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            child: Row(
              children: [
                Expanded(
                  child: SkeletonBox(height: 24, width: 120, borderRadius: 4),
                ),
                const SizedBox(width: 8),
                SkeletonBox(height: 24, width: 18, borderRadius: 4),
              ],
            ),
          ),
          ...List.generate(itemCount, (i) => _item()),
        ],
      ),
    );
  }

  Widget _item() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: const Row(
        children: [
          SkeletonCircle(radius: 16),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(height: 14, width: 140, borderRadius: 4),
                SizedBox(height: 4),
                SkeletonBox(height: 12, width: 80, borderRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
