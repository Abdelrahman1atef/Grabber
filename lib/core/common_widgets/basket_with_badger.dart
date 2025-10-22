
import 'package:flutter/material.dart';

class BasketWithBadger extends StatelessWidget {
  const BasketWithBadger ({super.key, required this.totalCount});
  final int totalCount;
  @override
  Widget build(BuildContext context) {
    return
    Visibility(
      visible: totalCount > 0,
      child: Positioned(
        top: -9,
        right: -4,
        child: TweenAnimationBuilder<double>(
          key: ValueKey(totalCount),
          tween: Tween<double>(begin: 0.7, end: 1.0),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Text(
              totalCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onEnd: () {}, // optional
        ),
      ),
    );

  }
}
