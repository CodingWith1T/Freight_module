import 'package:flutter/material.dart';

import 'package:freight_front/features/freight_card/presentation/screens/freight_card_screen.dart';
import 'package:freight_front/theme/app_color.dart';

class FreightApp extends StatelessWidget {
  const FreightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Freight Front',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.neonGreen,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColor.backgroundLime,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.neonGreen,
            foregroundColor: AppColor.textPrimary,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const FreightCardScreen(),
    );
  }
}
