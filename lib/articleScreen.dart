import 'dart:io';
import 'package:flutter/material.dart';
import 'history_service.dart';
import 'app_theme.dart';
import 'scanScreen.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  void _handleNavigation(int index) async {
    if (index == 0) {
      // kembali ke home
      Navigator.pop(context);
    } else if (index == 1) {
      // ke scan
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ScanScreen()),
      );
    }
    // index == 2 adalah halaman saat ini (article)
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: const Color(0xFF051021),
      body: Stack(
        children: [
          // Background dengan decorative oval
          Positioned(
            left: -13,
            top: 502,
            child: Container(
              width: screenWidth * 1.08,
              height: 163,
              decoration: const BoxDecoration(
                color: Color(0xFF38C5B0),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Article content section
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 102),
                    decoration: const BoxDecoration(
                      color: Color(0xFFECEBEB),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(65),
                        topRight: Radius.circular(65),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Header
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
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Back',
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

                        const SizedBox(height: 20),

                        // Scrollable grid
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: _buildArticleGrid(),
                          ),
                        ),

                        const SizedBox(height: 90), // Space for bottom nav
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom navigation bar
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2, // Article page acts as extended history
        onTap: _handleNavigation,
      ),
    );
  }

  Widget _buildArticleGrid() {
    final allScans = HistoryService.scans.reversed.toList();
    
    // Placeholder data untuk artikel
    final placeholderArticles = [
      {'image': 'assets/coincomodo.png', 'name': 'Komodo Coin', 'year': '1991 - 1998'},
      {'image': 'assets/coin50rupiah.png', 'name': '50 Rupiah Coin', 'year': '1971'},
      {'image': 'assets/coin100padang.png', 'name': '100 Rupiah Coin', 'year': '1978'},
      {'image': 'assets/coin1rupiah.png', 'name': '1 Rupiah Coin', 'year': '1970'},
      {'image': 'assets/coincomodo.png', 'name': 'Komodo Coin', 'year': '1991 - 1998'},
      {'image': 'assets/coin50rupiah.png', 'name': '50 Rupiah Coin', 'year': '1971'},
      {'image': 'assets/coin100padang.png', 'name': '100 Rupiah Coin', 'year': '1978'},
      {'image': 'assets/coin1rupiah.png', 'name': '1 Rupiah Coin', 'year': '1970'},
      {'image': 'assets/coincomodo.png', 'name': 'Komodo Coin', 'year': '1991 - 1998'},
      {'image': 'assets/coin50rupiah.png', 'name': '50 Rupiah Coin', 'year': '1971'},
    ];

    // Gabungkan scans dan placeholder
    final displayItems = <Map<String, dynamic>>[];
    
    // Tambahkan scan results terlebih dahulu
    for (var scan in allScans) {
      displayItems.add({
        'type': 'scan',
        'scan': scan,
      });
    }
    
    // Tambahkan placeholder jika kurang dari 10 items
    if (displayItems.length < 10) {
      final remaining = 10 - displayItems.length;
      for (var i = 0; i < remaining; i++) {
        final placeholder = placeholderArticles[i % placeholderArticles.length];
        displayItems.add({
          'type': 'placeholder',
          'image': placeholder['image'],
          'name': placeholder['name'],
          'year': placeholder['year'],
        });
      }
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: displayItems.length,
      itemBuilder: (context, index) {
        final item = displayItems[index];
        
        if (item['type'] == 'scan') {
          final scan = item['scan'] as ScanResult;
          return _buildArticleCard(
            imagePath: scan.imagePath,
            coinName: scan.coinName,
            year: scan.year,
            isFromScan: true,
          );
        } else {
          return _buildArticleCard(
            assetImage: item['image'] as String,
            coinName: item['name'] as String,
            year: item['year'] as String,
            isFromScan: false,
          );
        }
      },
    );
  }

  Widget _buildArticleCard({
    String? imagePath,
    String? assetImage,
    required String coinName,
    required String year,
    required bool isFromScan,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Coin image
          Positioned(
            left: 20,
            top: 0,
            right: 20,
            bottom: 40,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: isFromScan
                      ? FileImage(File(imagePath!)) as ImageProvider
                      : AssetImage(assetImage!),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(1, 2),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(2, 8),
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