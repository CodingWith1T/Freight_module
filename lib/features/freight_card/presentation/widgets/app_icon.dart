import 'package:flutter/material.dart';

import 'package:freight_front/theme/app_color.dart';

class FreightAppIcon extends StatelessWidget {
  const FreightAppIcon({
    super.key,
    required this.icon,
    this.primaryColor = AppColor.neonGreen,
    this.secondaryColor = AppColor.neonGreenDark,
  });

  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.white, size: 32),
    );
  }
}
