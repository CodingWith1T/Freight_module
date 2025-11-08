import 'package:flutter/material.dart';

import 'package:freight_front/theme/app_color.dart';

import '../widgets/app_icon.dart';
import '../widgets/partner_logo.dart';

class FreightCardScreen extends StatelessWidget {
  const FreightCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLime,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Freight',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ...List.generate(4, (index) {
                    return Container(
                      width: 380.0 + (index * 40),
                      height: 480.0 + (index * 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60 + (index * 10)),
                        border: Border.all(
                          color: Color.lerp(
                            AppColor.neonGreen,
                            AppColor.backgroundLime,
                            index / 4,
                          )!,
                          width: 2,
                        ),
                      ),
                    );
                  }),
                  Container(
                    width: 280,
                    height: 560,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(45),
                      border: Border.all(color: Colors.black, width: 8),
                    ),
                    child: Column(
                      children: [
                        _StatusBar(),
                        _FreightHeader(),
                        const SizedBox(height: 20),
                        const _CardPreview(),
                        _ProgressIndicator(),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  FreightAppIcon(
                                    icon: Icons.folder,
                                    primaryColor: Colors.orange,
                                    secondaryColor: Colors.orangeAccent,
                                  ),
                                  _HighlightBar(),
                                  FreightAppIcon(
                                    icon: Icons.wallet,
                                    primaryColor: Colors.purple,
                                    secondaryColor: Colors.purpleAccent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 30),
              child: Column(
                children: [
                  const Text(
                    'Your everyday card',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Scan & pay anywhere, anytime',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      PartnerLogo(text: 'RuPay'),
                      SizedBox(width: 16),
                      PartnerLogo(text: 'YES BANK'),
                      SizedBox(width: 16),
                      PartnerLogo(text: 'NPCI'),
                      SizedBox(width: 16),
                      PartnerLogo(text: 'UPI'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.neonGreen,
                        foregroundColor: AppColor.textPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Get started',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            '9:41',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_4_bar, size: 16),
              SizedBox(width: 4),
              Icon(Icons.wifi, size: 16),
              SizedBox(width: 4),
              Icon(Icons.battery_full, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class _FreightHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _HeaderDot(color: AppColor.neonGreen),
          const Text(
            'Freight',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.textPrimary,
            ),
          ),
          const _HeaderDot(color: AppColor.neonGreen),
        ],
      ),
    );
  }
}

class _HeaderDot extends StatelessWidget {
  const _HeaderDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _CardPreview extends StatelessWidget {
  const _CardPreview();

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        width: 220,
        height: 140,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.neonGreen, AppColor.neonGreenDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.15,
                child: Icon(Icons.credit_card, size: 100, color: Colors.white),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Text(
                'RuPay',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black.withValues(alpha: 0.87),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                width: 36,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Icon(
                    Icons.credit_card_outlined,
                    size: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.neonGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFFF5544),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 30,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.neutralShade,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightBar extends StatelessWidget {
  const _HighlightBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 20,
      decoration: BoxDecoration(
        color: AppColor.neonGreen,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
