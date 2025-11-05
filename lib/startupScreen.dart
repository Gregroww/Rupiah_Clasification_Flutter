import 'dart:io';
import 'package:flutter/material.dart';
import 'package:money_clasification/getStartupScreen.dart';
import 'scanScreen.dart';
import 'historyScreen.dart';
import 'history_service.dart';
import 'app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _handleNavigation(int index) async {
    if (index == 0) {
      // sudah di home, tidak perlu navigasi
      return;
    } else if (index == 1) {
      // ke scan
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ScanScreen()),
      );
      // refresh setelah scan
      if (mounted) setState(() {});
    } else if (index == 2) {
      // ke history
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HistoryScreen()),
      );
      // refresh jika ada perubahan
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF051021), Color(0xFF0A1628)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Hero Section dengan Koin
                Expanded(
                  child: Stack(
                    children: [
                      // Decorative circles background
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.03),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 100,
                        left: -70,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.03),
                          ),
                        ),
                      ),

                      // Main content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 1),

                          // Coin showcase dengan rotasi
                          SizedBox(
                            height: screenHeight * 0.25,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Koin kiri (rotasi)
                                Positioned(
                                  left: screenWidth * 0.05,
                                  top: screenHeight * 0.08,
                                  child: Transform.rotate(
                                    angle: -0.49,
                                    child: Container(
                                      width: isSmallScreen ? 120 : 140,
                                      height: isSmallScreen ? 120 : 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: const DecorationImage(
                                          image: AssetImage('assets/coin.png'),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.25),
                                            blurRadius: 8,
                                            offset: const Offset(2, 5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Koin kanan (rotasi)
                                Positioned(
                                  right: screenWidth * 0.05,
                                  top: 0,
                                  child: Transform.rotate(
                                    angle: 0.49,
                                    child: Container(
                                      width: isSmallScreen ? 120 : 140,
                                      height: isSmallScreen ? 120 : 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: const DecorationImage(
                                          image: AssetImage('assets/coin.png'),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.25),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Title
                          Text(
                            'Scan Your',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 36 : 48,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Outfit',
                              letterSpacing: -1.44,
                              shadows: [
                                Shadow(
                                  offset: const Offset(5, 4),
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(0.25),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Money',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 36 : 48,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Outfit',
                              letterSpacing: -1.44,
                              shadows: [
                                Shadow(
                                  offset: const Offset(5, 4),
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(0.25),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(flex: 2),
                        ],
                      ),
                    ],
                  ),
                ),

                // Spacer untuk menurunkan box artikel
                const SizedBox(height: 40),

                // Article Section (Bottom Sheet)
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFECEBEB),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(65),
                      topRight: Radius.circular(65),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Decorative oval accent
                      Transform.translate(
                        offset: const Offset(0, -30),
                        child: Container(
                          width: screenWidth * 1.1,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Color(0xFF38C5B0),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // Article header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Article',
                              style: TextStyle(
                                color: Color(0xFF06152C),
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.60,
                              ),
                            ),
                            TextButton(
                              onPressed: () => _handleNavigation(2),
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  color: Color(0xFF535353),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: -0.36,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Article grid (2x2)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: _buildArticleGrid(),
                      ),

                      const SizedBox(height: 90), // Space for bottom nav
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onTap: _handleNavigation,
      ),
    );
  }

  Widget _buildArticleGrid() {
    final recentScans = HistoryService.scans.reversed.take(4).toList();
    
    // Placeholder images jika belum ada scan
    final placeholderImages = [
      'assets/coincomodo.png',
      'assets/coin50rupiah.png',
      'assets/coincomodo.png',
      'assets/coin50rupiah.png',
    ];
    
    final placeholderTitles = [
      'Komodo Coin',
      '50 Rupiah Coin',
      'Komodo Coin',
      '50 Rupiah Coin',
    ];
    
    final placeholderYears = [
      '1991 - 1998',
      '1971',
      '1991 - 1998',
      '1971',
    ];

    return Column(
      children: [
        // Row 1
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildArticleCard(
              recentScans.length > 0 ? recentScans[0] : null, 
              0,
              placeholderImage: placeholderImages[0],
              placeholderTitle: placeholderTitles[0],
              placeholderYear: placeholderYears[0],
            ),
            _buildArticleCard(
              recentScans.length > 1 ? recentScans[1] : null, 
              1,
              placeholderImage: placeholderImages[1],
              placeholderTitle: placeholderTitles[1],
              placeholderYear: placeholderYears[1],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildArticleCard(
              recentScans.length > 2 ? recentScans[2] : null, 
              2,
              placeholderImage: placeholderImages[2],
              placeholderTitle: placeholderTitles[2],
              placeholderYear: placeholderYears[2],
            ),
            _buildArticleCard(
              recentScans.length > 3 ? recentScans[3] : null, 
              3,
              placeholderImage: placeholderImages[3],
              placeholderTitle: placeholderTitles[3],
              placeholderYear: placeholderYears[3],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArticleCard(
    ScanResult? scan, 
    int index, {
    String? placeholderImage,
    String? placeholderTitle,
    String? placeholderYear,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = (screenWidth - 60) / 2;

    // Gunakan data scan jika ada, jika tidak gunakan placeholder
    final imagePath = scan?.imagePath;
    final coinName = scan?.coinName ?? placeholderTitle ?? 'Unknown Coin';
    final year = scan?.year ?? placeholderYear ?? '';
    final useAsset = scan == null && placeholderImage != null;

    return Container(
      width: cardSize,
      height: cardSize,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Coin image
          Positioned(
            left: cardSize * 0.13,
            top: cardSize * 0.06,
            child: Container(
              width: cardSize * 0.63,
              height: cardSize * 0.63,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: useAsset
                      ? AssetImage(placeholderImage!) as ImageProvider
                      : (imagePath != null ? FileImage(File(imagePath)) : const AssetImage('assets/coin.png')),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
            ),
          ),

          // Text info
          Positioned(
            left: 8,
            bottom: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coinName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.36,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  year,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
