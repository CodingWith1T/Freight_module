import 'package:flutter/material.dart';

import 'package:freight_front/theme/app_color.dart';

class PartnerLogo extends StatelessWidget {
  const PartnerLogo({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColor.partnerMuted,
      ),
    );
  }
}
