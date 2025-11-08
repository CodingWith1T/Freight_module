import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/shipment.dart';
import 'status_timeline.dart';

class ShipmentCard extends StatelessWidget {
  final Shipment shipment;
  final VoidCallback onTap;

  const ShipmentCard({
    Key? key,
    required this.shipment,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: shipment.status == 'Delivered' ? AppColors.primary : AppColors.cardDark,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  shipment.orderId,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: shipment.status == 'Delivered' ? Colors.white.withOpacity(0.2) : AppColors.inTransit,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    shipment.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: AppTextStyles.caption.copyWith(
                          color: shipment.status == 'Delivered'
                              ? Colors.white.withOpacity(0.7)
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(shipment.from, style: AppTextStyles.bodyLarge),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To',
                        style: AppTextStyles.caption.copyWith(
                          color: shipment.status == 'Delivered'
                              ? Colors.white.withOpacity(0.7)
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(shipment.to, style: AppTextStyles.bodyLarge),
                    ],
                  ),
                ),
              ],
            ),
            if (shipment.status == 'In Transit') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Placed by', style: AppTextStyles.caption),
                        const SizedBox(height: 4),
                        Text(
                          shipment.placedDate,
                          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estimated Date', style: AppTextStyles.caption),
                        const SizedBox(height: 4),
                        Text(
                          shipment.estimatedDate,
                          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StatusTimeline(currentStep: shipment.currentStep, compact: true),
            ],
          ],
        ),
      ),
    );
  }
}

