import 'package:flutter/material.dart';

class AnimatedProgressDots extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color activeColor;
  final Color inactiveColor;

  const AnimatedProgressDots({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor = const Color(0xFF2D3748),
    this.inactiveColor = const Color(0xFFE5E7EB),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: isActive ? 26 : 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }
}
