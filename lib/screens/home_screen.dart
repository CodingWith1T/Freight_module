import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/shipment.dart';
import '../widgets/shipment_card.dart';
import 'tracking_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Shipment> shipments = [
    Shipment(
      orderId: 'ORD-123456789',
      from: 'Los Angeles',
      to: 'New York',
      status: 'In Transit',
      placedDate: '12 Jan, 2025',
      estimatedDate: '26 Jan, 2025',
      currentStep: 2,
      fromAddress: 'Warehouse A, 123 Industrial Park, Los Angeles, CA 90001',
      toAddress: 'Central Logistics Hub, 101 Commerce Drive, Dallas, TX 75201',
    ),
    Shipment(
      orderId: 'ORD-987654321',
      from: 'Los Angeles',
      to: 'San Francisco',
      status: 'Delivered',
      placedDate: '08 Jan, 2025',
      estimatedDate: '15 Jan, 2025',
      currentStep: 3,
    ),
    Shipment(
      orderId: 'ORD-567890123',
      from: 'Seattle',
      to: 'Portland',
      status: 'Delivered',
      placedDate: '05 Jan, 2025',
      estimatedDate: '10 Jan, 2025',
      currentStep: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: shipments.length,
                itemBuilder: (context, index) {
                  return ShipmentCard(
                    shipment: shipments[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TrackingDetailScreen(shipment: shipments[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hi John,', style: AppTextStyles.bodyLarge),
              Text(
                'Los Angeles',
                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Shipping', style: AppTextStyles.headline2),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search Shipping',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.local_shipping_outlined, 1),
          _buildNavItem(Icons.chat_bubble_outline, 2),
          _buildNavItem(Icons.settings_outlined, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
