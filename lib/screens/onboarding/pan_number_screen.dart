import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'business_info_screen.dart';

class PANNumberScreen extends StatefulWidget {
  const PANNumberScreen({
    super.key,
    required this.userType,
    required this.gstNumber,
  });

  final String userType;
  final String gstNumber;

  @override
  State<PANNumberScreen> createState() => _PANNumberScreenState();
}

class _PANNumberScreenState extends State<PANNumberScreen> {
  final TextEditingController _panController = TextEditingController();

  void _handleContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BusinessInfoScreen(
              userType: widget.userType,
              gstNumber: widget.gstNumber,
              panNumber: _panController.text.trim(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPAN = _panController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter Your\nPAN Number',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'For business verification and\ninvoicing purposes.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _panController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: 'PAN Number',
                        hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                        filled: true,
                        fillColor: AppColors.cardBackground,
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.selectedBorder,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: hasPAN ? _handleContinue : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.lightprimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _handleContinue,
                      child: const Text(
                        'Skip for now',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _panController.dispose();
    super.dispose();
  }
}
