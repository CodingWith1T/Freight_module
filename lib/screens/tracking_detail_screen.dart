import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/shipment.dart';
import '../widgets/status_timeline.dart';
import '../widgets/custom_button.dart';

class TrackingDetailScreen extends StatelessWidget {
  final Shipment shipment;

  const TrackingDetailScreen({Key? key, required this.shipment})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [_buildMap(), _buildDetails()]),
              ),
            ),
            _buildLiveTrackingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text('Tracking Shipment', style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: const NetworkImage(
            'https://api.mapbox.com/styles/v1/mapbox/dark-v11/static/-118.2437,34.0522,9,0/600x400@2x?access_token=pk.eyJ1IjoiZXhhbXBsZSIsImEiOiJjazB3MjNpemgwMDAwM25wYzUzcDI2cnVwIn0.example',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: CustomPaint(
              size: const Size(300, 200),
              painter: RouteLinePainter(),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.inTransit,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'In Transit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text('Order ID', style: AppTextStyles.caption)),
          const SizedBox(height: 4),
          Center(
            child: Text(
              shipment.orderId,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      shipment.fromAddress ?? shipment.from,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('To', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(
                      shipment.toAddress ?? shipment.to,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
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
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.grey),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery Partner', style: AppTextStyles.caption),
                    const Text(
                      'Michael Johnson',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          StatusTimeline(currentStep: shipment.currentStep),
        ],
      ),
    );
  }

  Widget _buildLiveTrackingButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: CustomButton(
        text: 'Live Tracking',
        icon: Icons.gps_fixed,
        onPressed: () {},
      ),
    );
  }
}

class RouteLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.1,
      size.width * 0.8,
      size.height * 0.3,
    );
    canvas.drawPath(path, paint);

    final circlePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      6,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.3),
      6,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
