import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';

class StatusTimeline extends StatelessWidget {
  final int currentStep;
  final bool compact;

  const StatusTimeline({
    Key? key,
    required this.currentStep,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = ['Packed', 'Shipped', 'In Transit', 'Delivered'];

    return Row(
      children: List.generate(steps.length, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted ? AppColors.primary : Colors.grey.shade700,
                      ),
                    ),
                  Container(
                    width: compact ? 12 : 16,
                    height: compact ? 12 : 16,
                    decoration: BoxDecoration(
                      color: isCompleted || isCurrent ? AppColors.primary : Colors.grey.shade700,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrent ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted ? AppColors.primary : Colors.grey.shade700,
                      ),
                    ),
                ],
              ),
              if (!compact) ...[
                const SizedBox(height: 8),
                Text(
                  steps[index],
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    color: isCompleted || isCurrent ? Colors.white : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

