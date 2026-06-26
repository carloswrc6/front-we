import 'package:flutter/material.dart';
import 'package:frontwe/presentation/shared/widgets/SkeletonWidget.dart';

class DishFilterBarSkeleton extends StatelessWidget {
  const DishFilterBarSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 12),
                  child: _circle(24),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 44,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _chip(88, 28, 14),
                const SizedBox(width: 8),
                _chip(66, 28, 14),
                const SizedBox(width: 8),
                _chip(78, 28, 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _circle(double size) {
  return Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
  );
}

Widget _chip(double w, double h, double r) {
  return Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(r),
    ),
  );
}
