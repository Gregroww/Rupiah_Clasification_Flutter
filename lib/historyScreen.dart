import 'dart:io';
import 'package:flutter/material.dart';
import 'history_service.dart';
import 'app_theme.dart';
import 'scanScreen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void _handleNavigation(int index) {
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
    // index == 2 adalah halaman saat ini (history)
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF040E1E),
      body: Stack(
        children: [
          // Decorative oval background
          Positioned(
            left: -77,
            top: -30,
            child: Container(
              width: screenWidth * 1.5,
              height: 115,
              decoration: const BoxDecoration(
                color: Color(0xFF38C5B0),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.96,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Content area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: _buildList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom navigation bar
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: _handleNavigation,
      ),
    );
  }

  Widget _buildList() {
    final scans = HistoryService.scans.reversed.toList();
    
    if (scans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada riwayat scan',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: scans.length,
      separatorBuilder: (_, __) => const SizedBox(height: 17),
      itemBuilder: (context, index) {
        final scan = scans[index];
        return _buildCard(scan, index);
      },
    );
  }

  Widget _buildCard(ScanResult scan, int listIndex) {
    // Format time manually
    final hour = scan.scanDate.hour.toString().padLeft(2, '0');
    final minute = scan.scanDate.minute.toString().padLeft(2, '0');
    final timeString = '$hour:$minute';
    
    // Format date manually
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final monthName = months[scan.scanDate.month - 1];
    final dateString = '$monthName ${scan.scanDate.day}, ${scan.scanDate.year}';

    return Container(
      width: double.infinity,
      height: 187,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Coin image
          Positioned(
            left: 19,
            top: 33,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  image: FileImage(File(scan.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Coin name
          Positioned(
            left: 151,
            top: 33,
            child: Text(
              scan.coinName,
              style: const TextStyle(
                color: Color(0xFF06152C),
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.60,
              ),
            ),
          ),

          // Year
          Positioned(
            left: 156,
            top: 57,
            child: Text(
              scan.year,
              style: const TextStyle(
                color: Color(0xFF06152C),
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
                letterSpacing: -0.39,
              ),
            ),
          ),

          // Date
          Positioned(
            right: 16,
            top: 113,
            child: Text(
              dateString,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w200,
                letterSpacing: -0.33,
              ),
            ),
          ),

          // Time
          Positioned(
            right: 16,
            top: 129,
            child: Text(
              timeString,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w200,
                letterSpacing: -0.33,
              ),
            ),
          ),

          // Delete button
          Positioned(
            right: 20,
            bottom: 5,
            child: GestureDetector(
              onTap: () {
                // Konfirmasi delete
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text('Hapus Riwayat'),
                    content: const Text('Apakah Anda yakin ingin menghapus riwayat ini?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          final origIndex = HistoryService.scans.length - 1 - listIndex;
                          setState(() {
                            HistoryService.removeAt(origIndex);
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Hapus',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                width: 75,
                height: 23,
                decoration: BoxDecoration(
                  color: const Color(0xFF31837D),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    'Delete',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.39,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
