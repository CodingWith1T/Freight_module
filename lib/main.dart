import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/get_started_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ShippingApp());
}

class ShippingApp extends StatelessWidget {
  const ShippingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Shipping',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        fontFamily: 'SF Pro Display',
      ),
      home: const GetStartedScreen(),
    );
  }
}
