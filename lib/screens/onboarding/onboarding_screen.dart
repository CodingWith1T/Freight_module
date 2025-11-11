import 'package:flutter/material.dart';

import '../auth/phone_number_screen.dart';
import '../../widgets/glassmorphism_button.dart';
import '../../widgets/animated_progress_dots.dart';

// IMAGE ASSET INSTRUCTIONS:
// To use local images instead of network images:
// 1. Add your images to: assets/images/onboarding/
// 2. Replace Image.network() with Image.asset()
// 3. Example: Image.asset('assets/images/onboarding/carousel_left.jpg')
//
// Recommended images:
// - carousel_left.jpg (truck/logistics, 80x190px)
// - carousel_center.jpg (handshake/partnership, 180x230px)
// - carousel_right.jpg (warehouse/business, 80x190px)
// - shipper_hero.jpg (warehouse manager, 340x360px)
// - trucker_background.jpg (truck on highway, full width x 430px)
// - tracking_background.jpg (GPS/smartphone, full width x 450px)

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PhoneNumberScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildScreen1(),
          _buildScreen2(),
          _buildScreen3(),
          _buildScreen4(),
        ],
      ),
    );
  }

  // SCREEN 1: WELCOME & INTRODUCTION (FULLSCREEN)
  Widget _buildScreen1() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 70),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
              children: [
                TextSpan(
                  text: 'Connect Shippers with\n',
                  style: TextStyle(color: Color(0xFF2D3748)),
                ),
                TextSpan(
                  text: 'Trusted Truckers',
                  style: TextStyle(color: Color(0xFF7B68EE)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'LoadLink brings together businesses and transport partners across India to deliver loads efficiently and reliably',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 45),
          SizedBox(
            height: 250,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Left Card (behind, on left side)
                Positioned(
                  left: -20,
                  top: 35,
                  child: Opacity(
                    opacity: 0.75,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/onboarding/left card.jpg',
                          width: 75,
                          height: 170,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 75,
                              height: 170,
                              color: const Color(0xFFC4C4C4),
                              child: const Icon(
                                Icons.local_shipping_outlined,
                                size: 36,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // Right Card (behind, on right side)
                Positioned(
                  right: -20,
                  top: 35,
                  child: Opacity(
                    opacity: 0.75,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/onboarding/right.png',
                          width: 75,
                          height: 170,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 75,
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFC107),
                                    Color(0xFF000000),
                                  ],
                                  stops: [0.5, 0.5],
                                  transform: GradientRotation(0.785),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // Center Card (in front, centered)
                Positioned(
                  top: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/onboarding/center.png',
                        width: 190,
                        height: 230,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 190,
                            height: 230,
                            color: const Color(0xFFC4C4C4),
                            child: const Icon(
                              Icons.handshake_outlined,
                              size: 75,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AnimatedProgressDots(
            currentPage: _currentPage,
            totalPages: 4,
            activeColor: const Color(0xFF2D3748),
            inactiveColor: const Color(0xFFE5E7EB),
          ),
          const Spacer(),
          GlassmorphismButton(
            text: 'Get Started',
            onPressed: _nextPage,
            backgroundColor: const Color(0xFF1565C0),
            glowColor: const Color(0xFF1565C0),
            textColor: Colors.white,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // SCREEN 2: FOR SHIPPERS (FULLSCREEN)
  Widget _buildScreen2() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 50),
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              'assets/images/onboarding/shipper.png',
              width: double.infinity,
              height: 380,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 380,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC4C4C4),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.warehouse_outlined,
                    size: 130,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: 'Post Your Load Requirements ',
                  style: TextStyle(color: Color(0xFF2D3748)),
                ),
                TextSpan(
                  text: 'Instantly',
                  style: TextStyle(color: Color(0xFF7B68EE)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Share your shipment details, pickup and delivery locations, and connect with verified truckers across India in minutes',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
          const Spacer(),
          GlassmorphismButton(
            text: 'Next',
            onPressed: _nextPage,
            width: 230,
            backgroundColor: const Color(0xFF1565C0),
            glowColor: const Color(0xFF1565C0),
            textColor: Colors.white,
            icon: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Color(0xFF1565C0),
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // SCREEN 3: FOR TRUCKERS (FULLSCREEN SPLIT)
  Widget _buildScreen3() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ClipPath(
            clipper: CurvedBottomClipper(),
            child: Container(
              width: double.infinity,
              height: 470,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                    'assets/images/onboarding/trucker.png',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.3),
                    BlendMode.darken,
                  ),
                  onError: (exception, stackTrace) {},
                ),
                color: const Color(0xFF4A5568),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: 'Find Profitable Loads on ',
                          style: TextStyle(color: Color(0xFF2D3748)),
                        ),
                        TextSpan(
                          text: 'Your Route',
                          style: TextStyle(color: Color(0xFF7B68EE)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Browse available shipments, choose loads that match your truck capacity and route, and maximize your earnings on every trip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6B7280),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedProgressDots(
                    currentPage: _currentPage,
                    totalPages: 4,
                    activeColor: const Color(0xFF7B68EE),
                    inactiveColor: const Color(0xFFE5E7EB),
                  ),
                  const Spacer(),
                  GlassmorphismButton(
                    text: 'Next',
                    onPressed: _nextPage,
                    backgroundColor: const Color(0xFF1565C0),
                    glowColor: const Color(0xFF1565C0),
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SCREEN 4: REAL-TIME TRACKING (FULLSCREEN SPLIT)
  Widget _buildScreen4() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ClipPath(
            clipper: CurvedBottomClipperRight(),
            child: Container(
              width: double.infinity,
              height: 420,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                    'assets/images/onboarding/realtime.png',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withValues(alpha: 0.2),
                    BlendMode.lighten,
                  ),
                  onError: (exception, stackTrace) {},
                ),
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  children: [
                    const SizedBox(height: 28),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                        children: [
                          TextSpan(
                            text: 'Track Every Delivery in ',
                            style: TextStyle(color: Color(0xFF2D3748)),
                          ),
                          TextSpan(
                            text: 'Real-Time',
                            style: TextStyle(color: Color(0xFF7B68EE)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Stay updated with live GPS tracking, secure payments, and instant communication between shippers and truckers throughout India',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    GlassmorphismButton(
                      text: 'Next',
                      onPressed: _nextPage,
                      height: 56,
                      backgroundColor: const Color(0xFF1565C0),
                      glowColor: const Color(0xFF1565C0),
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    AnimatedProgressDots(
                      currentPage: _currentPage,
                      totalPages: 4,
                      activeColor: const Color(0xFF2D3748),
                      inactiveColor: const Color(0xFFE5E7EB),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for curved bottom edge (Screen 3)
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom clipper for curved bottom edge from right (Screen 4)
class CurvedBottomClipperRight extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
