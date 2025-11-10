import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/shipment.dart';
import '../../widgets/shipment_card.dart';
import '../tracking/shipment_tracking_screen.dart';
import '../profile/shipper_profile_setup_screen.dart';
import '../orders/create_load_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Shipment> _shipments;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _shipments = _generateShipments();
  }

  Future<void> _refreshShipments() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    setState(() {
      _shipments = _generateShipments();
    });
  }

  List<Shipment> _generateShipments() {
    return [
      Shipment(
        orderId: 'TMID-4587321',
        from: 'Mumbai',
        to: 'Delhi',
        status: 'In Transit',
        placedDate: '12 Jan, 2025',
        estimatedDate: '18 Jan, 2025',
        currentStep: 2,
        fromAddress: 'Gateway Logistics Hub, Andheri East, Mumbai, MH 400069',
        toAddress: 'Okhla Industrial Estate, Phase II, New Delhi, DL 110020',
      ),
      Shipment(
        orderId: 'TMID-9036712',
        from: 'Bengaluru',
        to: 'Hyderabad',
        status: 'Out for Delivery',
        placedDate: '10 Jan, 2025',
        estimatedDate: '14 Jan, 2025',
        currentStep: 3,
        fromAddress: 'Whitefield Distribution Center, Bengaluru, KA 560066',
        toAddress: 'Kukatpally Delivery Hub, Hyderabad, TS 500072',
      ),
      Shipment(
        orderId: 'TMID-7125490',
        from: 'Chennai',
        to: 'Kolkata',
        status: 'Delivered',
        placedDate: '05 Jan, 2025',
        estimatedDate: '11 Jan, 2025',
        currentStep: 3,
        fromAddress: 'Ennore Port Warehouse, Chennai, TN 600057',
        toAddress: 'Salt Lake Logistics Park, Kolkata, WB 700091',
      ),
    ];
  }

  Future<void> _openProfileSetup() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const ShipperProfileSetupScreen(),
      ),
    );

    if (!mounted || result == null) return;
    setState(() {
      _isVerified = result;
    });
  }

  Future<void> _openCreateLoad() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateLoadScreen()),
    );
    if (!mounted) return;
    setState(() => _selectedIndex = 0);
  }

  void _onNavTap(int index) {
    if (_selectedIndex == index && index != 1) return;

    if (index == 1) {
      setState(() => _selectedIndex = index);
      _openCreateLoad();
      return;
    }

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _refreshShipments,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _shipments.length,
                  itemBuilder: (context, index) {
                    return ShipmentCard(
                      shipment: _shipments[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShipmentTrackingScreen(
                              shipment: _shipments[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
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
          GestureDetector(
            onTap: _openProfileSetup,
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                    Row(
                      children: [
                        const Text(
                          'Hi Pramod,',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.verified,
                          color: _isVerified ? AppColors.primary : Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                    Text(
                      'Bihar',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
              color: AppColors.primary,
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
      onTap: () => _onNavTap(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : AppColors.primary,
          size: 28,
        ),
      ),
    );
  }
}
