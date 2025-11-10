import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/custom_text_field.dart';

class CreateLoadScreen extends StatefulWidget {
  const CreateLoadScreen({super.key});

  @override
  State<CreateLoadScreen> createState() => _CreateLoadScreenState();
}

class _CreateLoadScreenState extends State<CreateLoadScreen> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _loadTypeController = TextEditingController();
  final TextEditingController _materialQtyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final List<String> _vehicleTypes = [
    'Mini Truck',
    '3-Wheeler',
    '2-Wheeler',
    'Lorry',
  ];

  final List<String> _loadQuantities = ['Full Load', 'Partial Load'];

  String _selectedVehicle = 'Mini Truck';
  String _selectedLoadQty = 'Full Load';
  DateTime _scheduledAt = DateTime.now().add(const Duration(minutes: 12));

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _loadTypeController.dispose();
    _materialQtyController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    final hasPermission = await _ensurePermission();
    if (!hasPermission) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      final placemark = placemarks.isNotEmpty ? placemarks.first : null;
      final formatted = [
        placemark?.street,
        placemark?.locality,
        placemark?.administrativeArea,
        placemark?.postalCode,
      ].whereType<String>().where((value) => value.isNotEmpty).join(', ');

      setState(() {
        _originController.text = formatted.isEmpty
            ? 'Current location'
            : formatted;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Current location set as pickup.'),
          backgroundColor: AppColors.primary,
        ),
      );
    } on LocationServiceDisabledException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled. Please enable them.'),
          backgroundColor: AppColors.primary,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to fetch location: $error'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Future<bool> _ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enable location services.'),
          backgroundColor: AppColors.primary,
        ),
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permission denied. Please allow it in settings.',
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      return false;
    }

    return true;
  }

  // ignore: unused_element
  Future<void> _pickSchedule() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDate: _scheduledAt,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.cardDark,
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;
    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.cardDark,
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time == null || !mounted) return;

    setState(() {
      _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submitOrder() {
    if (_originController.text.isEmpty || _destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide both origin and destination.'),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    final bookingSummary =
        '''
Status: pending
Vehicle: $_selectedVehicle
Load type: ${_loadTypeController.text.isEmpty ? 'N/A' : _loadTypeController.text}
Quantity: $_selectedLoadQty
Material qty: ${_materialQtyController.text.isEmpty ? 'N/A' : _materialQtyController.text}
Price: ${_priceController.text.isEmpty ? 'N/A' : _priceController.text}
''';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Load created for ${_originController.text} → ${_destinationController.text}\n$bookingSummary',
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 4),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          'Book a Delivery',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              title: 'Select Locations',
              child: Column(
                children: [
                  _buildLocationField(
                    controller: _originController,
                    label: 'Your location',
                    hint: 'Enter pickup address',
                    icon: Icons.my_location,
                  ),
                  const SizedBox(height: 12),
                  _buildLocationField(
                    controller: _destinationController,
                    label: 'Routing to',
                    hint: 'Enter drop address',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _useCurrentLocation,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Use Current Location'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Enter Address'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 20),
            // _buildCard(
            //   title: 'Schedule & Distance',
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           Expanded(
            //             child: _buildInfoTile(
            //               label: 'ETA',
            //               value:
            //                   '${_scheduledAt.difference(DateTime.now()).inMinutes} mins',
            //             ),
            //           ),
            //           const SizedBox(width: 12),
            //           Expanded(
            //             child: _buildInfoTile(
            //               label: 'Distance',
            //               value: '8.4 km',
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 16),
            //       Align(
            //         alignment: Alignment.centerLeft,
            //         child: Text(
            //           'Schedule Time',
            //           style: AppTextStyles.bodyMedium.copyWith(
            //             color: Colors.white,
            //             fontSize: 12,
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       ElevatedButton.icon(
            //         onPressed: _pickSchedule,
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: AppColors.primary,
            //           minimumSize: const Size.fromHeight(48),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //         ),
            //         icon: const Icon(Icons.schedule),
            //         label: Text(
            //           '${_scheduledAt.hour.toString().padLeft(2, '0')}:${_scheduledAt.minute.toString().padLeft(2, '0')}  •  ${_scheduledAt.day}/${_scheduledAt.month}/${_scheduledAt.year}',
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 20),
            _buildCard(
              title: 'Select Vehicle Type',
              child: SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _vehicleTypes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final type = _vehicleTypes[index];
                    final isSelected = type == _selectedVehicle;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedVehicle = type);
                      },
                      child: Container(
                        width: 140,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.cardDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.white,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                              size: 28,
                            ),
                            const Spacer(),
                            Text(
                              type,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _vehicleSubtitle(type),
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: 'Load Details',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _loadTypeController,
                    label: 'Load Type',
                    hint: 'Eg: Electronics, Furniture',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Load Quantity',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    children: _loadQuantities.map((qty) {
                      final isSelected = qty == _selectedLoadQty;
                      return ChoiceChip(
                        label: Text(qty),
                        selected: isSelected,
                        onSelected: (_) =>
                            setState(() => _selectedLoadQty = qty),
                        selectedColor: AppColors.primary,
                        labelStyle: AppTextStyles.bodyLarge.copyWith(
                          fontSize: 12,
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textPrimary,
                        ),
                        backgroundColor: AppColors.cardDark,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _materialQtyController,
                    label: 'Material Quantity (tons)',
                    hint: 'Enter amount',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _priceController,
                    label: 'Proposed Price (₹)',
                    hint: 'Enter price',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _noteController,
                    label: 'Additional Notes',
                    hint: 'Share any special instructions',
                    maxLines: 3,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pickup scheduled for later.'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Schedule Later',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                TextField(
                  controller: controller,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hint,
                    hintStyle: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildInfoTile({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _vehicleSubtitle(String type) {
    switch (type) {
      case 'Mini Truck':
        return 'Up to 500kg';
      case '3-Wheeler':
        return 'Up to 300kg';
      case '2-Wheeler':
        return 'Up to 20kg';
      case 'Lorry':
        return 'Up to 5 tons';
      default:
        return '';
    }
  }
}
